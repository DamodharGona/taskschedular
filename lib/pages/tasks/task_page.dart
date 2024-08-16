import 'package:flutter/material.dart';
import 'package:taskschedular/components/button.dart';
import 'package:taskschedular/components/create_button.dart';
import 'package:taskschedular/components/my_textfield.dart';
import 'package:taskschedular/components/time_data_components.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  List<Map<String, String>> _tasks = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasks',
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
              nameOfButton: 'Create Task',
              description: 'you can create new task here',
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
                                    _tasks.add({
                                      'time': _timeController.text,
                                      'title': _titleController.text,
                                      'description':
                                          _descriptionController.text,
                                    });
                                  });
                                  _titleController.clear();
                                  _descriptionController.clear();
                                  _timeController.clear();
                                  Navigator.pop(context);
                                },
                                border: Border.all(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Create Task',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            controller: _titleController,
                            hintText: 'Enter Title',
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TimeDataComponents(
                                icon: Icons.calendar_month_sharp,
                                title: 'DueDate',
                              ),
                              TimeDataComponents(
                                icon: Icons.alarm,
                                title: 'DueTime',
                                controller: _timeController,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            controller: _descriptionController,
                            hintText: 'Enter description',
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Today',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                task['time']!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 13.0),
                                width: 2.0, // Width of the vertical line
                                height: 30.0, // Height of the vertical line
                                color:
                                    Colors.black, // Color of the vertical line
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task['title']!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    task['description']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
