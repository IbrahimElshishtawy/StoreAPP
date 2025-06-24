import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String textbtn;
  final Future<void> Function(Map<String, dynamic>) onPressed;
  final Map<String, dynamic> data;

  const CustomBtn({
    super.key,
    required this.textbtn,
    required this.onPressed,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async => await onPressed(data),
        child: Text(
          textbtn,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
