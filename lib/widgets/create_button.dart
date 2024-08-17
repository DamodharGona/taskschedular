import 'package:flutter/material.dart';

class CreateButton extends StatelessWidget {
  final String nameOfButton;
  final String description;
  final Function()? onPressed;
  const CreateButton({
    super.key,
    required this.nameOfButton,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nameOfButton,
                style: const TextStyle(fontSize: 19),
              ),
              Text(
                description,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.add_circle,
              color: Colors.deepPurple,
              size: 60,
            ),
          ),
        ],
      ),
    );
  }
}
