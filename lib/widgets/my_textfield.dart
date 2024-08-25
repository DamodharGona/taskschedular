import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintext;
  final TextEditingController? controller;
  final Color color;
  const MyTextfield({
    super.key,
    required this.hintext,
    required this.controller,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(

        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8)),
        hintText: hintext,
        hintStyle:  TextStyle(color: color),
      ),
    );
  }
}
