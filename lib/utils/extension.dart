import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/app_assets.dart';

extension SpaceWidget on double {
  addHSpace() {
    return SizedBox(
      height: this,
    );
  }

  addWSpace() {
    return SizedBox(
      width: this,
    );
  }
}

/// add Line from hide keyboard
hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

Widget appBarTitle(BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [Image.asset(AppAssets.applogoImage)],
    // children:  [
    //   Text("Flut",style: TextStyle(color: context.textTheme.headline1!.color,fontSize: 30,fontWeight: FontWeight.w700),),
    //   const Text("GPT",style: TextStyle(color: Color(0xff62A193),fontSize: 35,fontWeight: FontWeight.w700),),
    // ],
  );
}
