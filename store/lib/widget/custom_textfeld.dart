// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintext;
  final String labeltext;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  const CustomTextField({
    super.key,
    required this.hintext,
    required this.labeltext,
    required this.obscureText,
    this.onChanged,
    this.suffixIcon,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labeltext,
        hintText: hintext,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
