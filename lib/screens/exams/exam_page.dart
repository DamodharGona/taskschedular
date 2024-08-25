import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart';
import 'package:taskschedular/core/services/exam_firestore.dart';
import 'package:taskschedular/cubit/exam/cubit/exam_cubit.dart';
import 'package:taskschedular/models/exam_model.dart';
import 'package:taskschedular/widgets/button.dart';
import 'package:taskschedular/widgets/create_button.dart';
import 'package:taskschedular/widgets/my_textfield.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final ExamFirestore examFirestoreServices = ExamFirestore();
  final TextEditingController titleController = TextEditingController();
  ExamModel? editingExam;
  List<ExamModel> examList = [];
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ExamCubit>(context).fetchExams();
  }

  void pickDueDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void pickStartTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        selectedStartTime = time;
      });
    }
  }

  void pickEndTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        selectedEndTime = time;
      });
    }
  }

  // Convert TimeOfDay to string
  String timeOfDayToString(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    final DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(dateTime);
  }

  // Convert string to TimeOfDay
  TimeOfDay parseTimeOfDay(String timeString) {
    final DateFormat format = DateFormat('h:mm a');
    final DateTime dateTime = format.parse(timeString);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  // Create or update the exam
  // Create or update the exam
  Future<void> saveExam() async {
    if (selectedDate == null) {
      // Show an error message if the date is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    final exam = ExamModel(
      title: titleController.text,
      date: selectedDate!,
      startTime: selectedStartTime != null
          ? timeOfDayToString(selectedStartTime!)
          : 'No start time set',
      endTime: selectedEndTime != null
          ? timeOfDayToString(selectedEndTime!)
          : 'No end time set',
    );

    if (editingExam != null) {
      await BlocProvider.of<ExamCubit>(context)
          .updateExam(editingExam!.docID!, exam);
    } else {
      await BlocProvider.of<ExamCubit>(context).createExam(exam);
    }

    if (mounted) {
      Navigator.pop(context);
    }
    titleController.clear();
    setState(() {
      selectedDate = null;
      selectedStartTime = null;
      selectedEndTime = null;
      editingExam = null;
    });

    // Refresh the exam list
    if (mounted) {
      BlocProvider.of<ExamCubit>(context).fetchExams();
    }
  }

  // delete the exam
  Future<void> deleteExams(String docID) async {
    await BlocProvider.of<ExamCubit>(context).deleteExam(docID);
    if (mounted) {
      BlocProvider.of<ExamCubit>(context).fetchExams();
    }
  }

  void showCustomModalBottomSheet(BuildContext context, [ExamModel? exam]) {
    if (exam != null) {
      titleController.text = exam.title;
      selectedDate = exam.date;
      selectedStartTime = exam.startTime != 'No start time set'
          ? parseTimeOfDay(exam.startTime)
          : null;
      selectedEndTime = exam.endTime != 'No end time set'
          ? parseTimeOfDay(exam.endTime)
          : null;
      editingExam = exam;
    } else {
      titleController.clear();
      selectedDate = null;
      selectedStartTime = null;
      selectedEndTime = null;
      editingExam = null;
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
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
                      saveExam();
                    },
                    border: Border.all(),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Create Exam',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              MyTextfield(
                hintext: 'Enter the title',
                controller: titleController,
                color: Colors.grey,
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: pickDueDate,
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 16),
                    Text(selectedDate == null
                        ? 'Select Date'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: pickStartTime,
                      child: Row(
                        children: [
                          const Icon(Icons.alarm),
                          const SizedBox(width: 8),
                          Text(selectedStartTime == null
                              ? 'Select Time'
                              : timeOfDayToString(selectedStartTime!)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: pickEndTime,
                      child: Row(
                        children: [
                          const Icon(Icons.alarm),
                          const SizedBox(width: 8),
                          Text(
                            selectedEndTime == null
                                ? 'Select Time'
                                : timeOfDayToString(selectedEndTime!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget customListViewBuilder(List examList) {
    return ListView.builder(
      itemCount: examList.length,
      itemBuilder: (context, index) {
        final exam = examList[index];
        return Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  showCustomModalBottomSheet(context, exam);
                },
                backgroundColor: Colors.grey,
                icon: Icons.edit,
              ),
              SlidableAction(
                onPressed: (context) async {
                  await BlocProvider.of<ExamCubit>(context)
                      .deleteExam(exam.docID!);
                  // Refresh the exam list
                },
                backgroundColor: Colors.red,
                icon: Icons.delete,
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue.shade100,
                border: Border.all(
                  color: Colors.blue,
                  width: 0.1,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text('${exam.startTime} - ${exam.endTime}'),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Page'),
        centerTitle: true,
      ),
      body: BlocBuilder<ExamCubit, ExamState>(
        builder: (context, state) {
          if (State is ExamLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExamLoaded) {
            DateTime today = DateTime.now();
            examList = state.exams.where((exam) {
              return exam.date != null &&
                  exam.date!.year == today.year &&
                  exam.date!.month == today.month &&
                  exam.date!.day == today.day;
            }).toList();
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CreateButton(
                    nameOfButton: 'Create Exam',
                    description: 'You can create your exam here',
                    onPressed: () {
                      showCustomModalBottomSheet(context);
                    },
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Exams Today',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: customListViewBuilder(examList),
                  ),
                ],
              ),
            );
          } else if (state is ExamError) {
            return Center(child: Text(state.error));
          } else {
            return const Center(
              child: Text('No exams present'),
            );
          }
        },
      ),
    );
  }
}
