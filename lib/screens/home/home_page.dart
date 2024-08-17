import 'package:flutter/material.dart';

import 'package:taskschedular/screens/exams/exam_page.dart';
import 'package:taskschedular/screens/on-boarding/intro_page.dart';
import 'package:taskschedular/screens/tasks/task_page.dart';
import 'package:taskschedular/screens/timetable/time_table.dart';
import 'package:taskschedular/services/auth/auth_service.dart';
import 'package:taskschedular/widgets/elevated_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GOOD MORNING',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        user.displayName.toString(),
                        style: const TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      await AuthService.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IntroPage(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.power_settings_new_outlined,
                      size: 30,
                    ),
                  )
                ],
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
      ),
    );
  }
}
