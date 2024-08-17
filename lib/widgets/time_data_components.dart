import 'package:flutter/material.dart';

import 'package:taskschedular/widgets/my_textfield.dart';

class TimeDataComponents extends StatelessWidget {
  final IconData icon;
  final String title;
  final TextEditingController? controller;
  const TimeDataComponents({
    super.key,
    required this.icon,
    required this.title,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Icon(
            icon,
            size: 35,
            color: Colors.deepPurple,
          ),
          const SizedBox(width: 15),
          SizedBox(
            width: 110,
            child: MyTextField(
              hintText: title,
              color: Colors.black,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
