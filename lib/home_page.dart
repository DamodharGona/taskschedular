import 'package:flutter/material.dart';
import 'package:taskschedular/components/elevated_button.dart';
import 'package:taskschedular/pages/Timetable/time_table.dart';
import 'package:taskschedular/pages/exams/exam_page.dart';
import 'package:taskschedular/pages/tasks/task_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GOOD MORNING',
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              'Gona Damodhar Reddy',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            MyElvatedButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TimeTablePage(),
                  ),
                );
              },
              title: 'TimeTable',
            ),
            const SizedBox(height: 20),
            MyElvatedButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskPage(),
                  ),
                );
              },
              title: 'Tasks',
            ),
            const SizedBox(height: 20),
            MyElvatedButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExamPage(),
                  ),
                );
              },
              title: 'Exams',
            ),
          ],
        ),
      ),
    );
  }
}
