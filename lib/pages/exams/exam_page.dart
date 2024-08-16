import 'package:flutter/material.dart';
import 'package:taskschedular/components/button.dart';
import 'package:taskschedular/components/create_button.dart';
import 'package:taskschedular/components/my_textfield.dart';
import 'package:taskschedular/components/time_data_components.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  List<Map<String, String>> _exams = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exams',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreateButton(
              nameOfButton: 'Create Exam',
              description: 'you can create new exam here',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Buttons(
                                title: 'cancel',
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                border: Border.all(),
                              ),
                              Buttons(
                                title: 'save',
                                onTap: () {
                                  setState(() {
                                    _exams.add({
                                      'startTime': _startTimeController.text,
                                      'endTime': _endTimeController.text,
                                      'title': _titleController.text,
                                    });
                                  });
                                  _startTimeController.clear();
                                  _endTimeController.clear();
                                  _titleController.clear();
                                  Navigator.pop(context);
                                },
                                border: Border.all(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Create Exam',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            hintText: 'Enter Title',
                            controller: _titleController,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 20),
                          const TimeDataComponents(
                            icon: Icons.calendar_month_rounded,
                            title: 'Date',
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TimeDataComponents(
                                icon: Icons.alarm,
                                title: 'StartTime',
                                controller: _startTimeController,
                              ),
                              TimeDataComponents(
                                icon: Icons.alarm,
                                title: 'EndTime',
                                controller: _endTimeController,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 35),
            const Text(
              'Today',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _exams.length,
                itemBuilder: (context, index) {
                  final exam = _exams[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.circle,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${exam['startTime']} - ${exam['endTime']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${exam['title']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
