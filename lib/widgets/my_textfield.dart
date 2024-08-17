import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final Color color;
  const MyTextField({
    super.key,
    required this.hintText,
    required this.color,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: color,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
