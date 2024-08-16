import 'package:flutter/material.dart';
import 'package:taskschedular/components/button.dart';
import 'package:taskschedular/components/day_container.dart';
import 'package:taskschedular/components/my_textfield.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Subject',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Buttons(
            title: 'save',
            border: Border.all(),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              hintText: 'Enter Subject Name',
              color: Colors.grey,
            ),
            Text(
              'Select days of the week',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            DayContainer()
          ],
        ),
      ),
    );
  }
}
