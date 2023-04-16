import 'dart:async';

import 'package:chat_gpt/constant/app_assets.dart';
import 'package:chat_gpt/screens/home_pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/app_icon.dart';
import '../../main.dart';
import '../../utils/app_keys.dart';
import '../onboarding_pages/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnBoarding();
    showAds == false ? null : loadAppOpenAd();
    Future.delayed(
      const Duration(seconds: 5),
    ).then((value) => Get.offAll(
        isHomeScreen == true ? const HomeScreen() : const HomeScreen(),
        transition: Transition.rightToLeft));
  }

  bool isHomeScreen = false;

  getOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isHomeScreen = prefs.getBool('isHomeScreen') ?? false;
    print(' -----------> ${isHomeScreen}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff38b6ff),
      body: Center(
        child: Image.asset(AppAssets.splashScreenImage),
      ),
    );
  }
}
