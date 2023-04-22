import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/app_assets.dart';

class Screen2 extends StatelessWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(height: height / 5),
        // Image.asset(AppAssets.image2),
        Container(height: height / 3.8),
        Text(
          "Help Us Grow",
          style: TextStyle(
              color: context.textTheme.headline1!.color,
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ),
        Container(height: height / 50),

        const Text("Show your by giving us review",
            style: TextStyle(
                color: Color(0xff9092A1),
                fontWeight: FontWeight.w500,
                fontSize: 16)),
        const Text("on the store",
            style: TextStyle(
                color: Color(0xff9092A1),
                fontWeight: FontWeight.w500,
                fontSize: 16)),
      ],
    );
  }
}
