import 'dart:io';

import 'package:chat_gpt/constant/app_icon.dart';
import 'package:chat_gpt/screens/chat_pages/chat_screen.dart';
import 'package:chat_gpt/screens/premium_pages/premium_screen.dart';
import 'package:chat_gpt/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/app_assets.dart';
import '../../constant/app_color.dart';
import '../../main.dart';
import '../../modals/all_modal.dart';
import '../../theme/theme_services.dart';
import '../../utils/app_keys.dart';
import '../../utils/shared_prefs_utils.dart';
import '../../widgets/app_textfield.dart';
import '../history_pages/history_screen.dart';
import '../premium_pages/premium_screen_controller.dart';
import '../search_images_pages/search_images_screen.dart';
import '../setting_pages/setting_page_controller.dart';
import '../setting_pages/setting_screen.dart';
import 'home_screen_controller.dart';

int messageLimit = 0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int messageLimit = 0;
  InterstitialAd? _interstitialAd;
  PremiumScreenController premiumScreenController =
      Get.put(PremiumScreenController());
  SettingPageController settingPageController =
      Get.put(SettingPageController());

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid ? interstitialAndroidId : interstitialIosId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
          );
        },
        onAdFailedToLoad: (err) {},
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessageLimit();
    _loadInterstitialAd();
  }

  getMessageLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    messageLimit = prefs.getInt('messageLimit') ?? 0;
    setState(() {});
  }

  bool isColor = false;

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        title: appBarTitle(context).marginOnly(left: 0),
        backgroundColor: context.theme.backgroundColor,
        actions: [
          showImageGeneration == false
              ? Container()
              : IconButton(
                  onPressed: () {
                    Get.to(const ImageGenerationScreen(),
                        transition: Transition.rightToLeft);
                  },
                  icon: AppIcon.aiImageIcon(context)),
          IconButton(
            onPressed: () {
              Get.to(const HistoryScreen(), transition: Transition.rightToLeft);
            },
            icon: AppIcon.historyIcon(context),
          ),
          IconButton(
            onPressed: () {
              Get.to(const SettingScreen(), transition: Transition.fade);
            },
            icon: AppIcon.settingIcon(context),
          ),
          isPremium == true
              ? Container()
              : IconButton(
                  onPressed: () {
                    Get.to(const PremiumScreen(), transition: Transition.fade);
                  },
                  icon: AppIcon.premiumIcon1(),
                )
        ],
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<HomeScreenController>(
            assignId: true,
            builder: (logic) {
              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.0.addHSpace(),
                      Obx(() => homeScreenController.isLoading.value == true
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: const Center(
                                  child: CircularProgressIndicator()))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                          homeScreenController
                                              .categoriesList.length,
                                          (index) => GestureDetector(
                                                onTap: () {
                                                  homeScreenController
                                                      .onChangeIndex(
                                                          index,
                                                          homeScreenController
                                                                  .categoriesList[
                                                              index]);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 9,
                                                      horizontal: 15),
                                                  decoration: BoxDecoration(
                                                      color: homeScreenController
                                                                  .selectedIndex
                                                                  .value ==
                                                              index
                                                          ? const Color(
                                                              0xff3FB085)
                                                          : context.theme
                                                              .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Text(
                                                      homeScreenController
                                                                  .categoriesList[
                                                              index] ??
                                                          "",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ).marginOnly(left: 10),
                                              )),
                                    ),
                                  ).marginOnly(left: 8);
                                }),
                                10.0.addHSpace(),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: chatGPTList.length,
                                    itemBuilder: (context, index) {
                                      return chatGPTList[index].name ==
                                              homeScreenController.selectedText
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: chatGPTList[index]
                                                  .categoriesData
                                                  .length,
                                              itemBuilder: (context, i) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    if (showAds == true) {
                                                      _interstitialAd?.show();
                                                      _loadInterstitialAd();
                                                      messageController.text =
                                                          chatGPTList[index]
                                                              .categoriesData[i]
                                                              .question;
                                                      setState(() {});
                                                    } else {
                                                      messageController.text =
                                                          chatGPTList[index]
                                                              .categoriesData[i]
                                                              .question;
                                                      setState(() {});
                                                    }
                                                    // Get.offAll(ChatScreen(message: chatGPTList[index].categoriesData[i].question),transition: Transition.rightToLeft);
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 15),
                                                    decoration: BoxDecoration(
                                                        color: context
                                                            .theme.primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          chatGPTList[index]
                                                              .categoriesData[i]
                                                              .title,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        7.0.addHSpace(),
                                                        Text(
                                                          chatGPTList[index]
                                                              .categoriesData[i]
                                                              .description,
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff9193A2),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ).marginSymmetric(
                                                        horizontal: 10),
                                                  ).marginSymmetric(
                                                      horizontal: 18,
                                                      vertical: 5),
                                                );
                                              })
                                          : Container();
                                    }),
                                10.0.addHSpace(),
                              ],
                            )),
                    ],
                  ),
                ),
              );
            },
          ),
          Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: context.isDarkMode == false
                        ? const Color(0xffEDEDED)
                        : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            AppTextField(
                              controller: messageController,
                              onChanged: (value) {
                                value.isEmpty
                                    ? isColor = false
                                    : isColor = true;
                                setState(() {});
                              },
                              maxLines: messageController.text.length < 10
                                  ? messageController.text.length < 20
                                      ? 3
                                      : 1
                                  : 2,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            hideKeyboard(context);
                            if (messageLimit >= maxMessageLimit &&
                                isPremium == false) {
                              Get.to(const PremiumScreen(),
                                  transition: Transition.rightToLeft);
                            } else if (messageController.text.isNotEmpty) {
                              Get.offAll(
                                  ChatScreen(message: messageController.text),
                                  transition: Transition.rightToLeft);
                              messageController.clear();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "pleaseEnterText".tr,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 16.0);
                            }
                            // if(isPremium == true) {
                            //   if(messageLimit >= 5){
                            //     Get.to(const PremiumScreen(),transition: Transition.rightToLeft);
                            //   }else{
                            //     if(messageController.text.isNotEmpty){
                            //       Get.offAll(ChatScreen(message: messageController.text), transition: Transition.rightToLeft);
                            //       messageController.clear();
                            //     }else{
                            //       Fluttertoast.showToast(
                            //           msg: "pleaseEnterText".tr,
                            //           toastLength: Toast.LENGTH_SHORT,
                            //           gravity: ToastGravity.SNACKBAR,
                            //           timeInSecForIosWeb: 1,
                            //           backgroundColor: Colors.white,
                            //           textColor: Colors.black,
                            //           fontSize: 16.0
                            //       );
                            //     }
                            //   }
                            // }
                            // messageLimit ++;
                            // storeMessage(messageLimit);
                          },
                          icon: Icon(
                            Icons.send,
                            color: isColor
                                ? Colors.green
                                : const Color(0xffABAABA),
                          )),
                    ],
                  )).marginSymmetric(horizontal: 15, vertical: 10),
            ],
          ),
        ],
      ),
    );
  }

  storeMessage(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('messageLimit', value);
  }
}
