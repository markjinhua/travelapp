import 'package:chat_gpt/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../constant/app_color.dart';
import '../../utils/app_keys.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: AppColor.backGroundColor),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: height / 50),
            const Text(
              "Terms of Use for the Brilliant AI LLC Mobile App:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'Welcome to the Brilliant AI LLC Mobile App! These Terms of Use ("Terms") are a binding agreement between you and the owners of the Brilliant AI LLC Mobile App ("we", "us", "our", or "Brilliant AI"), and govern your use of the Brilliant AI LLC Mobile App, including all related features, content, and services (collectively, the "Service"). By accessing or using the Service, you agree to be bound by these Terms, so please read them carefully before using the Service.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "1. Access to the Service",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'The Brilliant AI LLC Mobile App is available for download on the Apple Store and Google Store, and you must have a compatible device in order to use the Service. You are responsible for obtaining and maintaining all equipment and software necessary to access and use the Service.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "2. Subscription and Payment",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'The Brilliant AI LLC Mobile App offers weekly, monthly, and annual subscription plans. By subscribing to the Service, you agree to pay the subscription fees in accordance with the terms and conditions of your chosen plan. You can cancel your subscription at any time by following the instructions provided in the app. Subscription fees are non-refundable.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "3. Use of the Service",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'The Brilliant AI LLC Mobile App is an overlay to chat and allows you to communicate in a selected area to learn new things, such as how to train a dog, how to spend time with your husband, how to spend time, where to go on vacation, etc. You agree to use the Service only for lawful purposes and in accordance with these Terms.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "4. User Content",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'You may have the ability to submit content to the Service, including text, photos, and other materials ("User Content"). You retain ownership of all User Content that you submit, but you grant Brilliant AI a non-exclusive, royalty-free, perpetual, irrevocable, and fully sublicensable right to use, reproduce, modify, adapt, publish, translate, create derivative works from, distribute, and display such User Content throughout the world in any media, now known or hereafter developed.You represent and warrant that: (i) you own or control all rights in and to your User Content and have the right to grant the license granted above, and (ii) your User Content does not violate these Terms or any applicable laws or regulations.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "5. Privacy",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'Your privacy is important to us. Please review our Privacy Policy, which describes how we collect, use, and share information about you when you use the Service.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "6. Intellectual Property",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'The Service and its entire contents, features, and functionality (including but not limited to all information, software, text, displays, images, video, and audio, and the design, selection, and arrangement thereof) are owned by Brilliant AI or its licensors and are protected by United States and international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "7. Disclaimer of Warranties",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'The Service is provided on an "as is" and "as available" basis, without any warranties of any kind, either express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, or non-infringement. Brilliant AI does not warrant that the Service will be uninterrupted or error-free, that defects will be corrected, or that the Service or the server that makes it available are free of viruses or other harmful components.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "8. Limitation of Liability",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'In no event shall Brilliant AI or its affiliates, licensors, service providers, employees, agents, officers, directors, or shareholders be liable for any direct, indirect, incidental, special, consequential, or exemplary damages, including but not limited to damages for loss of profits, goodwill, use, data, or other intangible',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Container(height: height / 50),
          ],
        ).marginOnly(left: 30, right: 30),
      ),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: AppColor.backGroundColor),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: height / 50),
            const Text(
              "Privacy Policy for the Brilliant AI LLC Mobile App:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'At Brilliant AI LLC ("Brilliant AI", "we", "us", "our"), we are committed to protecting your privacy. This Privacy Policy ("Policy") describes how we collect, use, and share information about you when you use the Brilliant AI LLC Mobile App ("App"), including all related features, content, and services (collectively, the "Service"). By using the Service, you consent to the collection and use of your information as described in this Policy. If you do not agree to this Policy, please do not use the Service.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "1. Information We Collect",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'We may collect the following types of information when you use the App: •  Personal Information: We may collect personal information such as your name, email address, and payment information when you sign up for a subscription.  • User Content: We may collect any content that you upload, post, or transmit through the App, such as messages, photos, and videos.  • Usage Information: We may collect information about how you use the App, including the frequency and duration of your use, the pages you visit, and the searches you conduct.  •  Device Information: We may collect information about the device you use to access the App, including the type of device, operating system, and mobile network information.  • Location Information: We may collect your device location information when you use the App, if you have allowed the App to access your device location settings.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "2. How We Use Your Information",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'We may use the information we collect for the following purposes:  • To provide and maintain the Service, including to fulfill your subscription and payment requests.  •  To communicate with you about the Service, including to send you updates and promotional messages.  • To analyze how users interact with the Service, and to improve and personalize the Service.  •  To comply with legal obligations and enforce our policies.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "3. How We Share Your Information",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'We may share your information with the following types of third parties:  •  Service Providers: We may share your information with third-party service providers who help us provide and improve the Service.  • Business Transfers: We may share your information in connection with a merger, acquisition, or sale of all or a portion of our assets.  • Legal Obligations: We may share your information to comply with legal obligations, such as in response to a subpoena or court order.  • Protection of Rights: We may share your information to protect our rights or the rights of others, including to prevent fraud or other illegal activity.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "4. Your Choices",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'You may have certain choices about how we use and share your information. For example, you can:  • Opt-out of promotional emails by clicking the "unsubscribe" link in the email.  • Change your device location settings to control the collection of your location information.  • Delete your account and all associated information by contacting us.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "5. Security",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'We take reasonable measures to protect the information we collect, including using encryption and other security measures to prevent unauthorized access, disclosure, or modification of your information. However, we cannot guarantee the security of your information.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "6. Children's Privacy",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'The Service is not intended for children under the age of 13. We do not knowingly collect or solicit personal information from children under 13.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "7. Changes to this Policy",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'We may update this Policy from time to time. If we make material changes to this Policy, we will notify you by email or by posting a notice on the App. Your continued use of the Service after any such changes constitutes your acceptance of the updated Policy.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            10.0.addHSpace(),
            const Text(
              "8. Contact Us",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            10.0.addHSpace(),
            const Text(
              'If you have any questions or concerns about this Policy or our practices related to the Service, please contact us at privacy@brilliantai.com.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Container(height: height / 50),
          ],
        ).marginOnly(left: 30, right: 30),
      ),
    );
  }
}
