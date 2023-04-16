// ignore_for_file: unrelated_type_equality_checks
import 'dart:async';
import 'package:chat_gpt/screens/premium_pages/premium_screen.dart';
import 'package:chat_gpt/utils/app_keys.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chat_gpt/constant/app_assets.dart';
import 'package:chat_gpt/utils/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/app_color.dart';
import '../../constant/app_icon.dart';
import '../../modals/message_model.dart';
import '../../utils/shared_prefs_utils.dart';
import '../../widgets/app_textfield.dart';
import '../home_pages/home_screen.dart';
import '../home_pages/home_screen_controller.dart';
import '../setting_pages/setting_page_controller.dart';
import 'chat_controller.dart';
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class ChatScreen extends StatefulWidget {
  String message;
  ChatScreen({Key? key, required this.message}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  HomeScreenController homeScreenController = HomeScreenController();

  int messageLimit = 0;
  getMessageLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    messageLimit = prefs.getInt('messageLimit') ?? 0;
    setState(() {});
  }

  storeMessage(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('messageLimit', value);
  }

  getVoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isVoiceOn = prefs.getBool('voice') ?? true;
    setState(() {});
  }

  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addMessageToMessageList(widget.message, true);
    sendMessageToAPI(widget.message);
    initTts();
    getVoice();
    getMessageLimit();
  }

  late FlutterTts flutterTts;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {}
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {}
  }

  Future _speak(String newVoiceText) async {
    double volume = 0.5;
    double pitch = 1.0;
    double rate = 0.5;
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (newVoiceText != null) {
      if (newVoiceText.isNotEmpty) {
        await flutterTts.speak(newVoiceText);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  initTts() {
    flutterTts = FlutterTts();
    _setAwaitOptions();
    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }
    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });
    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {});
      });
    }
    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        ttsState = TtsState.paused;
      });
    });
    flutterTts.setContinueHandler(() {
      setState(() {
        ttsState = TtsState.continued;
      });
    });
    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }

  ChatController chatController = Get.put(ChatController());
  TextEditingController messageController = TextEditingController();
  List<MessageModel> messageList = [];
  bool inProgress = true;

  //initialize openai
  final openAI = OpenAI.instance.build(
    token: openAiToken,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 12),
      connectTimeout: const Duration(seconds: 12),
      sendTimeout: const Duration(seconds: 12),
    ),
    isLog: true,
  );

  @override
  void dispose() {
    messageController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final BannerAd myBanner = BannerAd(
      adUnitId: Platform.isAndroid ? bannerAndroidID : bannerIOSID,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      alignment: Alignment.center,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
      child: adWidget, // myBanner.size.height.toDouble(),
    );

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(const HomeScreen(), transition: Transition.rightToLeft);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: Screenshot(
          controller: screenshotController,
          child: Scaffold(
              backgroundColor: context.theme.backgroundColor,
              appBar: AppBar(
                centerTitle: true,
                title: appBarTitle(context).marginOnly(left: 0),
                backgroundColor: context.theme.backgroundColor,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: () {
                      isVoiceOn
                          ? _speak(answerList.last)
                          : Fluttertoast.showToast(
                              msg: "voiceIsOff".tr,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0);
                    },
                    icon: AppIcon.speakerIcon(context),
                  ),
                  IconButton(
                    onPressed: () async {
                      await screenshotController
                          .capture(delay: const Duration(milliseconds: 10))
                          .then((image) async {
                        if (image != null) {
                          final directory =
                              await getApplicationDocumentsDirectory();
                          final imagePath =
                              await File('${directory.path}/image.png')
                                  .create();
                          await imagePath.writeAsBytes(image);

                          /// Share Plugin
                          await Share.shareFiles([imagePath.path]);
                        }
                      });
                    },
                    icon: AppIcon.shareIcon(context),
                  ),
                ],
                leading: IconButton(
                    onPressed: () {
                      Get.offAll(const HomeScreen(),
                          transition: Transition.rightToLeft);
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: context.textTheme.headline1!.color,
                    )),
              ),
              body: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: messageList.isEmpty
                              ? const Center(
                                  child: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 28),
                                  ),
                                )
                              : buildMessageListWidget()),
                    ],
                  ),
                  Obx(() => chatController.textField.value == true
                      ? buildSendWidget()
                      : appButton()),
                  showAds == false ? Container() : adContainer,
                ],
              )),
        ),
      ),
    );
  }

  Widget appButton() {
    return GestureDetector(
      onTap: () {
        chatController.onchangeTextField(true);
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.greenColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Text(
          "continueChat".tr,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        )),
      ).marginOnly(bottom: showAds == false ? 15 : 50, left: 15, right: 15),
    );
  }

  final dataKey = GlobalKey();
  Widget buildSendWidget() {
    return Scrollbar(
      controller: _scrollController,
      isAlwaysShown: true,
      child: Container(
        color: Colors.white,
        child: Container(
                // height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: context.isDarkMode == false
                      ? Color(0xffEDEDED)
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: AppTextField(
                          key: dataKey,
                          scrollController: _scrollController,
                          controller: messageController,
                          onTap: () {
                            // _scrollController.jumpTo(double.infinity);
                            // Scrollable.ensureVisible(dataKey.currentContext!);
                          },
                          onChanged: (value) {
                            value.isEmpty ? isColor = false : isColor = true;
                            setState(() {});
                          },
                          maxLines: messageController.text.length < 10
                              ? messageController.text.length < 20
                                  ? 3
                                  : 1
                              : 2,
                        )),
                    IconButton(
                        onPressed: () async {
                          if (isPremium == true) {
                            ttsState;
                            hideKeyboard(context);
                            String question = messageController.text.toString();
                            // setState(() {});
                            if (question.isEmpty) return;
                            addMessageToMessageList(question, true);
                            sendMessageToAPI(question);
                            messageLimit++;
                            setState(() {});
                            storeMessage(messageLimit);
                            setState(() {});
                          } else if (messageLimit >= maxMessageLimit) {
                            Get.to(const PremiumScreen(),
                                transition: Transition.rightToLeft);
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color:
                              isColor ? Colors.green : const Color(0xffABAABA),
                        ))
                  ],
                ))
            .marginOnly(
                bottom: showAds == false ? 15 : 50, left: 15, right: 15),
      ),
    );
  }

  Widget buildMessageListWidget() {
    // final ItemPositionsListener itemPositionsListener =  ItemPositionsListener.create();
    // final ItemScrollController itemScrollController = ItemScrollController();

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // return buildSingleMessageRow(messageList[index]);
              return Container(
                padding: const EdgeInsets.all(10),
                margin: messageList[index].sentByMe
                    ? const EdgeInsets.only(left: 50)
                    : const EdgeInsets.only(right: 50),
                child: Align(
                  alignment: messageList[index].sentByMe
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: messageList[index].sentByMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          messageList[index].sentByMe
                              ? Container()
                              : CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xffB2E7CA),
                                  child: Center(
                                      child: Image.asset(AppAssets.botImage)),
                                ),
                          5.0.addWSpace(),
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: messageList[index].sentByMe
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20))
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                  color: messageList[index].sentByMe
                                      ? AppColor.greenColor
                                      : context.theme.primaryColor,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: messageList[index].sentByMe
                                    ? Text(messageList[index].message,
                                        // maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          // overflow: TextOverflow.visible
                                        ))
                                    :

                                    // messageList[index] == index ?     AnimatedTextKit(
                                    //     totalRepeatCount: 1,
                                    //     animatedTexts: [
                                    //       TypewriterAnimatedText(
                                    //         messageList[index].answer,
                                    //         textStyle: const TextStyle(
                                    //           fontSize: 16,
                                    //           color: Colors.white,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ) :

                                    Column(
                                        children: [
                                          Text(messageList[index].answer,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              )),
                                          5.0.addHSpace(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  Fluttertoast.showToast(
                                                      msg: "copy".tr,
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.white,
                                                      textColor: Colors.black,
                                                      fontSize: 16.0);
                                                  await Clipboard.setData(
                                                      ClipboardData(
                                                          text:
                                                              messageList[index]
                                                                  .answer));
                                                },
                                                child: const SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: Center(
                                                      child: Icon(
                                                    Icons.copy,
                                                    color: Colors.white,
                                                  )),
                                                ),
                                              ),

                                              // Icon(Icons.copy,color: Colors.white,)
                                            ],
                                          )
                                        ],
                                      )),
                          ),
                          5.0.addWSpace(),
                          messageList[index].sentByMe
                              ? CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xffD8F4E5),
                                  child: Center(
                                      child: Text("me".tr,
                                          style: TextStyle(
                                              color: AppColor.greenColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10))),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            reverse: true,
            itemCount: messageList.length,
          ),
          if (inProgress)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xffB2E7CA),
                  child: Center(child: Image.asset(AppAssets.botImage)),
                ),
                5.0.addWSpace(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 50),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: context.theme.primaryColor,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(AppAssets.loadingFile, height: 20),
                      ],
                    ),
                  ),
                ),
                5.0.addWSpace(),
                Container(),
              ],
            ).paddingAll(10),
          100.0.addHSpace(),
        ],
      ),
    );
  }

  bool isColor = false;

  dynamic chatComplete(String question) async {
    String data = "";
    try {
      final request = ChatCompleteText(messages: [
        Map.of({"role": "user", "content": question.trim()})
      ], maxToken: token, model: ChatModel.chatGptTurbo0301Model);
      final response = await openAI.onChatCompletion(request: request);
      for (var element in response!.choices) {
        print("data -> ${element.message?.content}");
        data = element.message?.content.toString() ?? "";
      }
    } catch (e) {
      final request = CompleteText(
          prompt: question, model: Model.kTextDavinci3, maxTokens: token);
      final response = await openAI.onCompletion(request: request);
      String answer = response?.choices.last.text.trim() ?? "";
      data = answer;
      setState(() {});
    }
    return data;
  }

  void sendMessageToAPI(String question) async {
    setState(() {
      inProgress = true;
    });

    String day = DateTime.now().day.toString();
    String month = DateTime.now().month.toString();
    String year = DateTime.now().year.toString();
    try {
      String answer = await chatComplete(question);
      await SharedPrefsUtils.storeChat(
          chat: messageController.text,
          sentByMe: false,
          dateTime: "$day/$month/$year",
          answer: answer);
      addMessageToMessageList(answer, false);
      _speak(answer);
      messageController.clear();
    } catch (e) {
      await SharedPrefsUtils.storeChat(
          chat: messageController.text,
          sentByMe: false,
          dateTime: "$day/$month/$year",
          answer: 'Failed to get response please try again');
      addMessageToMessageList("Failed to get response please try again", false);
      _speak("Failed to get response please try again");
      messageController.clear();
    }

    setState(() {
      inProgress = false;
    });
  }

  void addMessageToMessageList(String message, bool sentByMe) {
    String day = DateTime.now().day.toString();
    String month = DateTime.now().month.toString();
    String year = DateTime.now().year.toString();

    setState(() {
      messageList.insert(
          0,
          MessageModel(
              message: message,
              sentByMe: sentByMe,
              dateTime: "$day/$month/$year",
              answer: message));
    });
  }

  List<Map> chatMessages = [];

  void addMessages(Map data) {
    chatMessages.add(data);
    setState(() {});
  }

  void deleteMessages() {
    chatMessages.clear();
    setState(() {});
  }
}

List<String> answerList = [];
