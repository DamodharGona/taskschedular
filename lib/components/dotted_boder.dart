import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DottedBoder extends StatelessWidget {
  final String timings;
  final Color color;
  final Color containerColors;
  const DottedBoder({
    super.key,
    required this.timings,
    required this.color,
    required this.containerColors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: containerColors,
        width: double.infinity,
        child: DottedBorder(
          color: color,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Center(
            child: Text(
              timings,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
