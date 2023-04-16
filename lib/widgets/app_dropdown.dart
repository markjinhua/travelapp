import 'package:flutter/material.dart';

class AppDropdown extends StatelessWidget {
  String value;
  List<DropdownMenuItem>? items;
  ValueChanged onChanged;
  AppDropdown({Key? key,required this.value,this.items,required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  DropdownButtonHideUnderline(
      child: DropdownButton(
        value: value,
        isExpanded: true,
        items: items,
        onChanged: onChanged,
        dropdownColor: Colors.white,
        iconDisabledColor: Colors.black,
        iconEnabledColor: Colors.black,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
