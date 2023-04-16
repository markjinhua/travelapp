import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController  extends GetxController{
  Rx<PageController> pageController =  PageController().obs;


  RxInt currentIndex = 0.obs;


  @override
  void onInit() async {
    onChange;
    super.onInit();
  }



  onChange(int index) {
    // setState(() {
    currentIndex.value = index;
    update();
    // });
  }
}