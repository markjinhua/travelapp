import 'package:chat_gpt/theme/theme_services.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool isVoiceOn = true;



class SettingPageController  extends GetxController{

  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    getTheme();
    // TODO: implement onInit
    super.onInit();
  }


  onChangeVoiceChange(bool value){
    isVoiceOn =  value;
    storeVoice(isVoiceOn);
    HapticFeedback.mediumImpact();
    update();
  }
  onChangeTheme(bool value){
    isDarkMode.value = value;
    storeTheme(isDarkMode.value);
    ThemeServices().switchTheme();
    HapticFeedback.mediumImpact();
    update();
  }


  storeTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    isVoiceOn = prefs.getBool('voice') ?? true;
    update();
  }


  storeVoice(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('voice', value);
    update();
  }





}