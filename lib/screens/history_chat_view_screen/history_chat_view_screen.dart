import 'dart:io';

import 'package:chat_gpt/screens/premium_pages/premium_screen.dart';
import 'package:chat_gpt/screens/premium_pages/premium_screen_controller.dart';
import 'package:chat_gpt/theme/theme_services.dart';
import 'package:chat_gpt/utils/extension.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/app_assets.dart';
import '../../constant/app_color.dart';
import '../../constant/app_icon.dart';
import '../../modals/message_model.dart';
import '../../utils/app_keys.dart';
import '../../utils/shared_prefs_utils.dart';
import '../../widgets/app_textfield.dart';
import '../chat_pages/chat_screen.dart';
import '../history_pages/history_screen.dart';
import '../home_pages/home_screen.dart';
import '../home_pages/home_screen_controller.dart';
import 'history_chat_controller.dart';

class HistoryChatViewScreen extends StatefulWidget {
  bool historyPage = false;
  String? question;
  String? answer;
  HistoryChatViewScreen(
      {Key? key, this.answer, this.question, required this.historyPage})
      : super(key: key);

  @override
  State<HistoryChatViewScreen> createState() => _HistoryChatViewScreenState();
}

class _HistoryChatViewScreenState extends State<HistoryChatViewScreen> {
  final historyController = Get.put(HistoryChatController());

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTts();
    getMessageLimit();
  }

  final homeScreenController = Get.put(HomeScreenController());

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

  TextEditingController messageController = TextEditingController();
  List<MessageModel> messageList = [];
  bool inProgress = false;

  //initialize openai
  final openAI = OpenAI.instance.build(
      token: openAiToken,
      baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 6),
          connectTimeout: const Duration(seconds: 6),
          sendTimeout: const Duration(seconds: 6)),
      isLog: true);

  @override
  void dispose() {
    messageController.dispose();
    flutterTts.stop();
    super.dispose();
  }

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
        widget.historyPage == false
            ? Get.offAll(const HomeScreen(), transition: Transition.leftToRight)
            : Get.offAll(const HistoryScreen(),
                transition: Transition.leftToRight);
        return true;
      },
      child: Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: context.theme.backgroundColor,
          title: appBarTitle(context).marginOnly(left: 0),
          leading: IconButton(
              onPressed: () {
                widget.historyPage == false
                    ? Get.offAll(const HomeScreen(),
                        transition: Transition.leftToRight)
                    : Get.offAll(const HistoryScreen(),
                        transition: Transition.leftToRight);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: context.textTheme.headline1!.color,
              )),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    10.0.addHSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 50),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              color: AppColor.greenColor,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              widget.question ?? "",
                              // maxLines: 2,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                // overflow: TextOverflow.visible
                              ),
                            ),
                          ),
                        ),
                        5.0.addWSpace(),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xffD8F4E5),
                          child: Center(
                              child: Text("me".tr,
                                  style: TextStyle(
                                      color: AppColor.greenColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10))),
                        )
                      ],
                    ).paddingAll(10),
                    10.0.addHSpace(),
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
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  widget.answer ?? "",
                                  // maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    // overflow: TextOverflow.visible
                                  ),
                                ),
                                5.0.addHSpace(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Fluttertoast.showToast(
                                            msg: 'copy'.tr,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            fontSize: 16.0);
                                        await Clipboard.setData(ClipboardData(
                                            text: widget.answer ?? "Null"));
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
                            ),

                            // Column(
                            //   // crossAxisAlignment: CrossAxisAlignment.end,
                            //   children: [
                            //     Text(
                            //       messageModel.message,
                            //       style: const TextStyle(
                            //         fontSize: 16,
                            //         color: Colors.white
                            //       ),
                            //     ),
                            //    // Row(children: [ messageModel.sentByMe ? Container() : AppIcon.copyIcon()],)
                            //   ],
                            // )
                          ),
                        ),
                        5.0.addWSpace(),
                        Container(),
                      ],
                    ).paddingAll(10),
                    buildMessageListWidget()
                  ],
                ),
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Obx(() => historyController.textField.value == true
                    ? buildSendWidget()
                    : appButton()),
                showAds == false ? Container() : adContainer
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget appButton() {
    return GestureDetector(
      onTap: () {
        historyController.onchangeTextField(true);
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
          "askNewQuestion".tr,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        )),
      ).marginOnly(left: 15, right: 15, bottom: showAds == false ? 15 : 50),
    );
  }

  Widget buildMessageListWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListView.builder(
          itemCount: messageList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
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
                                  : Column(
                                      children: [
                                        Text(
                                          messageList[index].answer,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
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
                                                        text: messageList[index]
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
              // messageModel.sentByMe
              //     ?
              // CircleAvatar(radius: 16,backgroundColor: const Color(0xffD8F4E5),child: Center(child: Text("ME",style: TextStyle(color: AppColor.greenColor,fontWeight: FontWeight.w700,fontSize: 10))),)
              //     :
              Container(),
            ],
          ).paddingAll(10),
        100.0.addHSpace(),
      ],
    );
  }

  Widget buildSingleMessageRow(MessageModel messageModel) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: messageModel.sentByMe
          ? const EdgeInsets.only(left: 150)
          : const EdgeInsets.only(right: 50),
      child: Align(
        alignment:
            messageModel.sentByMe ? Alignment.topRight : Alignment.topLeft,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: messageModel.sentByMe
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                messageModel.sentByMe
                    ? Container()
                    : CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xffB2E7CA),
                        child: Center(child: Image.asset(AppAssets.botImage)),
                      ),
                5.0.addWSpace(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: messageModel.sentByMe
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20))
                          : const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                      color: messageModel.sentByMe
                          ? AppColor.greenColor
                          : const Color(0xff434554),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      messageModel.message,
                      // maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        // overflow: TextOverflow.visible
                      ),
                    ),
                  ),
                ),
                5.0.addWSpace(),
                messageModel.sentByMe
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
  }

  Widget buildSendWidget() {
    return Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: context.isDarkMode == false
              ? const Color(0xffEDEDED)
              : Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
                child: AppTextField(
              controller: messageController,
            )),
            IconButton(
                onPressed: () async {
                  // if(messageLimit >= 5){
                  //   Get.to(const PremiumScreen(),transition: Transition.rightToLeft);
                  // }else{
                  messageLimit++;
                  setState(() {});
                  storeMessage(messageLimit);
                  hideKeyboard(context);
                  ttsState = TtsState.stopped;
                  String question = messageController.text.toString();
                  if (question.isEmpty) return;
                  addMessageToMessageList(question, true);
                  sendMessageToAPI(question);
                  setState(() {});
                  // }

                  //   Container(
                  //   color: Colors.white,
                  //   height: 60,
                  //   padding: const EdgeInsets.all(10),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: TextField(
                  //             controller: messageController,
                  //             decoration: const InputDecoration(
                  //               hintText: "How can i help you?",
                  //               border: InputBorder.none,
                  //             ),
                  //           )),
                  //       const SizedBox(
                  //         width: 16,
                  //       ),
                  //       FloatingActionButton(
                  //         onPressed: () {
                  //           String question = messageController.text.toString();
                  //           if (question.isEmpty) return;
                  //           messageController.clear();
                  //           addMessageToMessageList(question, true);
                  //           sendMessageToAPI(question);
                  //         },
                  //         elevation: 0,
                  //         child: const Icon(
                  //           Icons.send,
                  //           size: 18,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // );
                },
                icon: const Icon(
                  Icons.send,
                  color: Color(0xffABAABA),
                ))
          ],
        )).marginOnly(left: 15, right: 15, bottom: showAds == false ? 15 : 50);
  }

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
}
