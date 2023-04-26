import 'dart:io';

import 'package:chat_gpt/constant/app_color.dart';
import 'package:chat_gpt/screens/premium_pages/premium_screen_controller.dart';
import 'package:chat_gpt/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../theme/theme_services.dart';
import '../../utils/app_keys.dart';
import 'lenguage_screen_controller.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LanguageScreenController languageScreenController =
        Get.put(LanguageScreenController());

    updateLanguage(Locale locale) {
      Get.updateLocale(locale);
    }

    List<String> languageList = [
      'English',
      'Spanish',
      'French',
      'German',
      'Chinese',
      'Hindi',
      'Arabic',
      'Italian',
      'Polish',
      'Japanese'
    ];

    List local = const [
      Locale('en', 'US'),
      Locale('sp', 'SP'),
      Locale('fre', 'FRE'),
      Locale('gem', 'GEM'),
      Locale('ch', 'CH'),
      Locale('hi', 'IN'),
      Locale('ar', 'AR'),
      Locale('ity', 'ITY'),
      Locale('polish', 'POLISH'),
      Locale('japa', 'JAPA'),
    ];

    List<String> languageCode = [
      'en',
      'sp',
      'fre',
      'gem',
      'ch',
      'hi',
      'ar',
      'ity',
      'polish',
      'japa',
    ];

    List<String> countryCode = [
      'US',
      'SP',
      'FRE',
      'GEM',
      'CH',
      'IN',
      'AR',
      'ITY',
      'POLISH',
      'JAPA'
    ];
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

    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text("language".tr,
            style: TextStyle(color: context.textTheme.headline1!.color)),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: context.textTheme.headline1!.color,
            )),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(15)),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: languageList.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    return InkWell(
                      onTap: () {
                        languageScreenController.onChangeIndex(index);
                        languageScreenController
                            .storeCountryCode(countryCode[index]);
                        languageScreenController
                            .storeLanguageCode(languageCode[index]);
                        updateLanguage(local[index]);
                      },
                      child: SizedBox(
                        height: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  languageList[index],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const Spacer(),
                                languageScreenController.selectedIndex.value ==
                                        index
                                    ? const Icon(
                                        Icons.check,
                                        color: Color(0xff3FB085),
                                      )
                                    : Container()
                              ],
                            ).marginSymmetric(horizontal: 20),
                            5.0.addHSpace(),
                            // Divider(color: Colors.black,)
                          ],
                        ),
                      ),
                    );
                  });
                }),
          ).marginOnly(left: 20, right: 20, top: 10, bottom: 105),
          showAds == false ? Container() : adContainer
        ],
      ),
    );
  }
}
