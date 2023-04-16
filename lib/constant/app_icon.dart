import 'package:chat_gpt/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'app_assets.dart';

class AppIcon {
  static Widget chatUIcon() {
    return SvgPicture.asset(
      AppAssets.chatUIcon,
    );
  }

  static Widget aiImageIcon(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.aiImageIcon,
      height: 30,
      width: 30,
      color: context.textTheme.headline1!.color,
    );
  }

  static Widget historyIcon(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.historyIcon,
      color: context.textTheme.headline1!.color,
      height: 25,
      width: 25,
    );
  }

  static Widget settingIcon(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.settingIcon,
      color: context.textTheme.headline1!.color,
      height: 20,
      width: 20,
    );
  }

  static Widget diamondIcon() {
    return SvgPicture.asset(
      AppAssets.diamondIcon,
      height: 40,
      width: 40,
    );
  }

  static Widget chatIcon() {
    return SvgPicture.asset(
      AppAssets.chatIcon,
      color: Colors.white,
      height: 15,
      width: 15,
    );
  }

  static Widget copyIcon() {
    return SvgPicture.asset(
      AppAssets.copyIcon,
      color: Colors.white,
      height: 15,
      width: 15,
    );
  }

  static Widget speakerIcon(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.speakerIcon,
      color: context.textTheme.headline1!.color,
      height: 20,
      width: 20,
    );
  }

  static Widget shareIcon(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.shareIcon,
      color: context.textTheme.headline1!.color,
      height: 20,
      width: 20,
    );
  }

  static Widget premiumIcon1() {
    return SvgPicture.asset(
      AppAssets.premiumIcon1,
      height: 20,
      width: 20,
    );
  }

  static Widget robotIcon() {
    return SvgPicture.asset(
      AppAssets.botImage,
      height: 20,
      width: 20,
    );
  }

  static Widget checkBoxIcon() {
    return SvgPicture.asset(
      AppAssets.checkBoxIcon,
      color: const Color(0xff489B7D),
      height: 20,
      width: 20,
    );
  }

  static Widget rateUsIcon() {
    return SvgPicture.asset(
      AppAssets.rateUsIcon,
      color: Colors.white,
      height: 20,
      width: 20,
    );
  }

  static Widget shareFriendIcon() {
    return SvgPicture.asset(
      AppAssets.shareFriendIcon,
      color: Colors.white,
      height: 20,
      width: 20,
    );
  }

  static Widget termsAndConditions() {
    return SvgPicture.asset(
      AppAssets.termsAndConditions,
      color: Colors.white,
      height: 20,
      width: 20,
    );
  }

  static Widget privacyAndPolicyIcon() {
    return SvgPicture.asset(
      AppAssets.privacyAndPolicyIcon,
      color: Colors.white,
      height: 20,
      width: 20,
    );
  }

  static Widget twitterIcon() {
    return SvgPicture.asset(
      AppAssets.twitterIcon,
      color: AppColor.bottomIconColor,
      height: 20,
      width: 20,
    );
  }

  static Widget discordIcon() {
    return SvgPicture.asset(
      AppAssets.discordIcon,
      color: AppColor.bottomIconColor,
      height: 20,
      width: 20,
    );
  }

  static Widget lenguageIcon() {
    return SvgPicture.asset(
      AppAssets.lenguageIcon,
      color: Colors.white,
      height: 20,
      width: 20,
    );
  }

  static Widget yourPlanIcon() {
    return SvgPicture.asset(
      AppAssets.yourPlanIcon,
      color: Colors.white,
      height: 20,
      width: 20,
    );
  }

  static Widget voiceIcon() {
    return SvgPicture.asset(
      AppAssets.voiceIcon,
      color: Colors.white,
      height: 20,
      width: 20,
    );
  }

  static Widget themeIcon() {
    return SvgPicture.asset(
      AppAssets.themeIcon,
      height: 20,
      width: 20,
      color: Colors.white,
    );
  }

  static Widget downloadIcon() {
    return SvgPicture.asset(
      AppAssets.downloadIcon,
      height: 12,
      width: 12,
      color: Colors.white,
    );
  }

  static Widget deleteIcon(BuildContext context, {Color? color}) {
    return SvgPicture.asset(
      AppAssets.deleteIcon,
      color: color ?? context.textTheme.headline1!.color,
      height: 20,
      width: 20,
    );
  }

  static Widget image1() {
    return SvgPicture.asset(
      AppAssets.image1,
    );
  }

  static Widget image2() {
    return SvgPicture.asset(
      AppAssets.image2,
    );
  }

  static Widget image3() {
    return SvgPicture.asset(
      AppAssets.image3,
    );
  }
}
