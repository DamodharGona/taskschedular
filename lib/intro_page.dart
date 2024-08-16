import 'package:flutter/material.dart';
import 'package:taskschedular/home_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Image(image: AssetImage('assets/images/introimage.png')),
            const SizedBox(height: 30),
            const Text(
              'CREATE, NOTIFY, TRACK ,FINISH',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Stay organized with tasks and assignments, receive timely reminders for your timetable and upcoming exams, and never miss a priority task with our intuitive app.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 220),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_circle_right,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const Text(
                      'continue with',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: const SizedBox(
                        height: 60,
                        width: 60,
                        child: Image(
                          image: AssetImage('assets/images/google.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
