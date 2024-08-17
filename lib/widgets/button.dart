import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final BoxBorder? border;
  const Buttons({
    super.key,
    required this.title,
    required this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: border,
        ),
        child: Text(title),
      ),
    );
  }
}
