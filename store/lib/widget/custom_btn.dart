import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String textbtn;
  final void Function(Map<String, dynamic>) onPressed;
  final bool isEnabled;
  final Map<String, dynamic> data;

  const CustomBtn({
    super.key,
    required this.textbtn,
    required this.onPressed,
    required this.data,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: isEnabled ? () => onPressed(data) : null,
      child: Container(
        width: 400,
        height: 60,
        decoration: BoxDecoration(
          color: isEnabled
              ? const Color.fromARGB(255, 60, 163, 227)
              : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            textbtn,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
