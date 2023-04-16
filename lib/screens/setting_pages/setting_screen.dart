import 'dart:io';

import 'package:chat_gpt/constant/app_color.dart';
import 'package:chat_gpt/screens/premium_pages/premium_screen.dart';
import 'package:chat_gpt/screens/premium_pages/premium_screen_controller.dart';
import 'package:chat_gpt/screens/setting_pages/setting_page_controller.dart';
import 'package:chat_gpt/screens/setting_pages/terms_screen.dart';
import 'package:chat_gpt/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import '../../constant/app_icon.dart';
import '../../utils/app_keys.dart';
import '../lenguage_pages/lenguage_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

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

    final InAppReview inAppReview = InAppReview.instance;

    final settingPageController = Get.put(SettingPageController());

    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: AppBar(
            backgroundColor: context.theme.backgroundColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:
                  Icon(Icons.close, color: context.textTheme.headline1!.color),
            ),
            centerTitle: true,
            title: appBarTitle(context),
            actions: [
              CupertinoButton(
                onPressed: () {},
                child: const Text(""),
              )
            ]),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.0.addHSpace(),
                  showAds == true
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            Get.to(const PremiumScreen(),
                                transition: Transition.rightToLeft);
                          },
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: context.theme.primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppIcon.diamondIcon().marginOnly(left: 13),
                                25.0.addWSpace(),
                                Expanded(
                                    child: Text(
                                  "premium".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.white),
                                ).marginOnly(right: 30))
                              ],
                            ),
                          ).marginSymmetric(horizontal: 24),
                        ),
                  25.0.addHSpace(),
                  // const Text("SOCIAL",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),).marginSymmetric(horizontal: 24),
                  // 8.0.addHSpace(),
                  // bottomListTile(context,suffix :const Icon(Icons.arrow_forward_sharp),onTap: (){},title: "Follow us on twitter",icon: AppIcon.twitterIcon()),
                  // 2.0.addHSpace(),
                  // bottomListTile(context,suffix : Container(),onTap: (){},title: "Join our Discord",icon: AppIcon.discordIcon()),
                  // 8.0.addHSpace(),

                  Text(
                    "setting".tr,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: context.textTheme.headline1!.color),
                  ).marginSymmetric(horizontal: 24),
                  8.0.addHSpace(),

                  bottomListTile(context, suffix: Container(), onTap: () {
                    Get.to(const LanguageScreen(),
                        transition: Transition.rightToLeft);
                  }, title: "language".tr, icon: AppIcon.lenguageIcon()),

                  2.0.addHSpace(),

                  isDarkMode == false || isLightMode == false
                      ? Container()
                      : Obx(() {
                          return bottomListTile(context,
                              suffix: CupertinoSwitch(
                                  value: settingPageController.isDarkMode.value,
                                  trackColor: AppColor.backGroundColor,
                                  onChanged:
                                      settingPageController.onChangeTheme),
                              onTap: () {},
                              title: "Dark".tr,
                              icon: AppIcon.themeIcon());
                        }),

                  2.0.addHSpace(),

                  GetBuilder<SettingPageController>(builder: (logic) {
                    return bottomListTile(context,
                        suffix: CupertinoSwitch(
                            value: isVoiceOn,
                            trackColor: AppColor.backGroundColor,
                            onChanged: logic.onChangeVoiceChange),
                        onTap: () {},
                        title: "voice".tr,
                        icon: AppIcon.voiceIcon());
                  }),
                  8.0.addHSpace(),
                  Text(
                    "about".tr,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: context.textTheme.headline1!.color),
                  ).marginSymmetric(horizontal: 24),
                  8.0.addHSpace(),
                  bottomListTile(context, suffix: Container(), onTap: () async {
                    try {
                      if (await inAppReview.isAvailable()) {
                        inAppReview.requestReview();
                      }
                    } catch (e) {
                      print("eorro is -0-------> $e");
                    }
                  }, title: "rateUs".tr, icon: AppIcon.rateUsIcon()),
                  2.0.addHSpace(),
                  bottomListTile(context, suffix: Container(), onTap: () async {
                    await Share.share(Platform.isAndroid
                        ? shareAppLinkAndroid
                        : shareAppLinkIOSid);
                  }, title: "shareWithF".tr, icon: AppIcon.shareFriendIcon()),
                  2.0.addHSpace(),
                  bottomListTile(context, suffix: Container(), onTap: () {
                    Get.to(const TermsScreen(),
                        transition: Transition.rightToLeft);
                  }, title: "terms".tr, icon: AppIcon.termsAndConditions()),
                  2.0.addHSpace(),
                  bottomListTile(context, suffix: Container(), onTap: () {
                    Get.to(const PrivacyScreen(),
                        transition: Transition.rightToLeft);
                  }, title: "privacy".tr, icon: AppIcon.privacyAndPolicyIcon()),
                  33.0.addHSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      appBarTitle(context),
                    ],
                  ),
                  // 5.0.addHSpace(),
                  // Center(child: Text("poweredBy".tr, style: const TextStyle(
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.w500,
                  //     color: Color(0xff434554)),)),
                  50.0.addHSpace(),
                ],
              ),
            ),
            showAds == false ? Container() : adContainer
          ],
        ));
  }

  Widget bottomListTile(BuildContext context,
      {required String title,
      VoidCallback? onTap,
      required Widget suffix,
      required Widget icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        color: context.theme.primaryColor,
        child: Row(
          children: [
            9.0.addWSpace(),
            // AppIcon.iconBackImage(),
            icon,
            // Container(height: 35, width: 35, decoration: BoxDecoration(color: const Color(0xff3FB085), borderRadius: BorderRadius.circular(5)), child: icon.marginAll(5)),
            15.0.addWSpace(),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            const Spacer(),
            suffix,
            9.0.addWSpace()
          ],
        ),
      ).marginSymmetric(horizontal: 24),
    );
  }
}
