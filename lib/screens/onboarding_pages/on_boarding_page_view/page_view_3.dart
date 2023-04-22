import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/app_assets.dart';

class Screen3 extends StatelessWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(height: height / 5),
        // Image.asset(AppAssets.image3),
        Container(height: height / 10),
        Text(
          "Enable Notifications",
          style: TextStyle(
              color: context.textTheme.headline1!.color,
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ),
        Container(height: height / 50),

        const Text("allow us to send notifications. s you",
            style: TextStyle(
                color: Color(0xff9092A1),
                fontWeight: FontWeight.w500,
                fontSize: 16)),
        const Text("wouldn’t miss anything",
            style: TextStyle(
                color: Color(0xff9092A1),
                fontWeight: FontWeight.w500,
                fontSize: 16)),
      ],
    );
  }
}
