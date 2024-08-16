import 'package:flutter/material.dart';

class MyElvatedButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  const MyElvatedButton({
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(23),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purple],
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 19),
        ),
      ),
    );
  }
}
