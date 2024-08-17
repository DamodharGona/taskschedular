import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';

class DottedBoder extends StatelessWidget {
  final String timings;
  final bool isSelected;
  final bool isBlocked;

  const DottedBoder({
    super.key,
    required this.timings,
    this.isSelected = false,
    this.isBlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: isBlocked ? Colors.red.withOpacity(0.1) : Colors.white,
        width: double.infinity,
        child: DottedBorder(
          color: isBlocked
              ? Colors.red
              : isSelected
                  ? Colors.blue
                  : Colors.grey,
          dashPattern: const [10, 3],
          strokeWidth: isSelected ? 2 : 1,
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
