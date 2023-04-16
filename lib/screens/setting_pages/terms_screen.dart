import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../constant/app_color.dart';
import '../../utils/app_keys.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor: AppColor.backGroundColor),
      body: WebView(
        initialUrl: termsLink,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}


class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor: AppColor.backGroundColor),
      body: WebView(
        initialUrl: privacyLink,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
