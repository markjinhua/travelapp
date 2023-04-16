import 'dart:io';

import 'package:chat_gpt/screens/home_pages/home_screen.dart';
import 'package:chat_gpt/screens/onboarding_pages/on_boarding_screen.dart';
import 'package:chat_gpt/screens/search_images_pages/search_images_screen.dart';
import 'package:chat_gpt/screens/splash_screen_pages/splash_screen.dart';
import 'package:chat_gpt/theme/app_theme.dart';
import 'package:chat_gpt/theme/theme_services.dart';
import 'package:chat_gpt/utils/app_keys.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt/utils/lenguage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_controller.dart';

AppOpenAd? myAppOpenAd;
loadAppOpenAd() {
  AppOpenAd.load(
      adUnitId: Platform.isAndroid ? appOpenAndroidId : appOpenIosId,  //Your ad Id from admob
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            myAppOpenAd = ad;
            myAppOpenAd!.show();
          },
          onAdFailedToLoad: (error) {}),
      orientation: AppOpenAd.orientationPortrait);
}

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mainPageController = Get.put(MainPageController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // locale:  Locale(mainPageController.languageCode,mainPageController.countryCode),
      translations: LocalString(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDarkMode == true
          ?
      isLightMode == true
          ?
      ThemeMode.light
          :
      ThemeMode.dark
          :
      ThemeServices().theme,
      home: const SplashScreen(),
    );
  }
}
