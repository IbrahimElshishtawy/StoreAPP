// ignore: unnecessary_import
// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  //final TextEditingController controller;
  final String hintext;
  //final String labeltext;
  final bool obscureText;
  final TextInputType Keyboard;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    //required this.controller,
    required this.hintext,
    // required this.labeltext,
    this.obscureText = false,
    this.suffixIcon,
    this.Keyboard = TextInputType.text,
    this.onChanged,
    required TextEditingController controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      //  controller: controller,
      obscureText: obscureText,
      keyboardType: Keyboard,
      decoration: InputDecoration(
        hintText: hintext,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
