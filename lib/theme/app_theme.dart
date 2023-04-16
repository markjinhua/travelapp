import 'package:flutter/material.dart';

import '../utils/app_keys.dart';

class AppTheme {
  static final dark = ThemeData.dark().copyWith(
      backgroundColor: Colors.black,
      primaryColor: const Color(0xff1E1E1E),
      textTheme: const TextTheme(headline1: TextStyle(color: Colors.white)));

  static final light = ThemeData.light().copyWith(
      backgroundColor: const Color(0xff38b6ff),
      primaryColor: const Color(0xff1E1E1E),
      textTheme: const TextTheme(headline1: TextStyle(color: Colors.black)));
}
