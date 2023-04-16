import 'package:chat_gpt/screens/home_pages/home_screen.dart';
import 'package:chat_gpt/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/app_color.dart';
import '../../utils/shared_prefs_utils.dart';
import 'on_boarding_page_view/on_boarding_controller.dart';
import 'on_boarding_page_view/page_view_1.dart';
import 'on_boarding_page_view/page_view_2.dart';
import 'on_boarding_page_view/page_view_3.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onBoardingController  = Get.put(OnBoardingController());
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: Stack(
        children: [
          PageView(
              controller: onBoardingController.pageController.value,
              onPageChanged: onBoardingController.onChange,
              physics: const BouncingScrollPhysics(),
              children: const [
                Screen1(),
                Screen2(),
                Screen3(),
              ]),



          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [




              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) =>
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: onBoardingController.currentIndex.value == index ?  const Color(0xff40B5F0) : const Color(0xffBCC7EC),
                              shape: BoxShape.circle
                          ),
                        ).marginAll(2))
                );
              }),
              15.0.addHSpace(),

              appButton((){

                if( onBoardingController.currentIndex.value == 2){
                  Get.offAll(const HomeScreen(),transition: Transition.rightToLeft);
                  SharedPrefsUtils.storeOnBoarding(true);
                }else{
                  onBoardingController.pageController.value.nextPage(duration: const Duration(seconds: 1), curve: Curves.linear);
                }
                // onBoardingController.currentIndex.value == 2 ? Get.offAll(const HomeScreen(),transition: Transition.rightToLeft) :  onBoardingController.pageController.value.nextPage(duration: const Duration(seconds: 1), curve: Curves.linear);
              }),

            ],
          ).marginOnly(bottom: 45,left: 24,right: 24),
        ],
      ),
    );
  }

  Widget appButton(VoidCallback onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColor.greenColor,borderRadius: BorderRadius.circular(12),),
        child:  Center(child: Text("Next",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),)),
      ),
    );
  }

}
