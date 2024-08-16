import 'package:flutter/material.dart';
import 'package:taskschedular/components/create_button.dart';
import 'package:taskschedular/pages/Timetable/subject_page.dart';

class TimeTablePage extends StatelessWidget {
  const TimeTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeTable'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreateButton(
              nameOfButton: 'Create subject',
              description: 'you can create your subject timetable here',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubjectPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Today',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}

