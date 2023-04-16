import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTextField extends StatelessWidget {
  TextEditingController? controller;
  VoidCallback? onTap;
  Widget? suffixIcon;
  ScrollController? scrollController;
  ValueChanged<String>? onChanged;
  int? maxLines = 1;
      AppTextField({Key? key,this.controller,this.onTap,this.suffixIcon,this.onChanged,this.maxLines,this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollController: scrollController,
      onTap: onTap,
      controller: controller,
      onChanged: onChanged,
      minLines: 1,
      style: const TextStyle(color: Colors.black),
      maxLines: maxLines,
      decoration: InputDecoration(
          hintText: "askSomething".tr,
          hintStyle: const  TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: const BorderSide(color: Colors.white)),
          focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white)),
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white)),
        suffixIcon: suffixIcon
      ),
    );
  }
}
