import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/app_assets.dart';
import '../../../constant/app_icon.dart';

class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            height : height /5
        ),
        Image.asset(AppAssets.image1),
        Container(
            height : height /10
        ),
        Text("Your AI Assistance",style: TextStyle(color: context.textTheme.headline1!.color,fontSize: 24,fontWeight: FontWeight.w700),),
        Container(
            height : height /50
        ),

        const Text("Using This App, You can Ask Your",style: TextStyle(color: Color(0xff9092A1),fontWeight: FontWeight.w500,fontSize: 16)),
        const Text("questions and recieve articles using",style: TextStyle(color: Color(0xff9092A1),fontWeight: FontWeight.w500,fontSize: 16)),
        const Text("artificial assistance",style: TextStyle(color: Color(0xff9092A1),fontWeight: FontWeight.w500,fontSize: 16))
      ],
    );
  }
}
