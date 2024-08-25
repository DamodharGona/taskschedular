import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:taskschedular/core/services/task_firestore.dart';
import 'package:taskschedular/cubit/task_cubit/task_cubit.dart';
import 'package:taskschedular/models/task_model.dart';
import 'package:taskschedular/widgets/button.dart';
import 'package:taskschedular/widgets/create_button.dart';
import 'package:taskschedular/widgets/my_textfield.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<TaskModel> _taskList = [];
  TaskModel? editingTask; // Track the task being edited

  final TaskFirestore taskFirestoreservices = TaskFirestore();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskCubit>(context).fetchTasks();
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

  void pickDueTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  // Format TimeOfDay to a string with AM/PM
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    final DateFormat formatter =
        DateFormat('h:mm a'); // 12-hour format with AM/PM
    return formatter.format(dateTime);
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

  // Create or update a task and store it in Firestore
  Future<void> saveTask() async {
    final task = TaskModel(
      title: titleController.text,
      description: descriptionController.text,
      dueDate: selectedDate,
      dueTime: selectedTime != null
          ? timeOfDayToString(selectedTime!) // Format TimeOfDay to string
          : 'No Time Set',
      docID: editingTask?.docID, // Use existing docID if updating
    );

    if (editingTask != null) {
      await BlocProvider.of<TaskCubit>(context)
          .updateTask(editingTask!.docID!, task);
    } else {
      await BlocProvider.of<TaskCubit>(context).createTask(task);
    }

    if (mounted) {
      Navigator.pop(context);
    }
    titleController.clear();
    descriptionController.clear();
    setState(() {
      selectedDate = null;
      selectedTime = null;
      editingTask = null; // Reset after saving
    });

    if (mounted) {
      BlocProvider.of<TaskCubit>(context).fetchTasks();
    } // Refresh the task list
  }

  // Fetch tasks from Firestore and filter to show only tasks for today
  Future<void> fetchTasks() async {
    final tasks = await taskFirestoreservices.fetchAllTasks();
    DateTime today = DateTime.now();
    setState(() {
      _taskList = tasks.where((task) {
        return task.dueDate != null &&
            task.dueDate!.year == today.year &&
            task.dueDate!.month == today.month &&
            task.dueDate!.day == today.day;
      }).toList();
    });
  }

  // Delete the task
  Future<void> deleteTask(String docID) async {
    await BlocProvider.of<TaskCubit>(context).deleteTasks(docID);
    if (mounted) {
      BlocProvider.of<TaskCubit>(context).fetchTasks();
    }
    // Refresh the task list
  }

  // Show the bottom sheet for creating or editing a task
  void showCustomModalBottomSheet(BuildContext context, [TaskModel? task]) {
    if (task != null) {
      // Populate fields with existing task data if editing
      titleController.text = task.title;
      descriptionController.text = task.description;
      selectedDate = task.dueDate;
      selectedTime =
          task.dueTime != 'No Time Set' ? parseTimeOfDay(task.dueTime) : null;
      editingTask = task;
    } else {
      // Clear fields if creating a new task
      titleController.clear();
      descriptionController.clear();
      selectedDate = null;
      selectedTime = null;
      editingTask = null;
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
                    onTap: saveTask,
                    border: Border.all(),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Create Task',
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
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: pickDueDate,
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_sharp),
                          const SizedBox(width: 8),
                          Text(selectedDate == null
                              ? 'Select Date'
                              : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: pickDueTime,
                      child: Row(
                        children: [
                          const Icon(Icons.alarm),
                          const SizedBox(width: 8),
                          Text(
                            selectedTime == null
                                ? 'Select Time'
                                : formatTimeOfDay(
                                    selectedTime!), // Display formatted time
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              MyTextfield(
                hintext: 'Enter the description',
                controller: descriptionController,
                color: Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }

  // Build the list view for displaying tasks
  Widget customListViewBuilder(List taskList) {
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        final task = taskList[index];

        return Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  showCustomModalBottomSheet(context, task);
                },
                backgroundColor: Colors.grey,
                icon: Icons.edit,
              ),
              SlidableAction(
                onPressed: (context) {
                  deleteTask(task.docID!);
                },
                backgroundColor: Colors.red,
                icon: Icons.delete,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
            ),
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title),
                  Text('goal: ${task.description}'),
                  Text('dueTime: ${task.dueTime}'), // Handle null case
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        title: const Text('Task Page'),
        centerTitle: true,
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            DateTime today = DateTime.now();
            final taskList = state.tasks.where((task) {
              return task.dueDate != null &&
                  task.dueDate!.year == today.year &&
                  task.dueDate!.month == today.month &&
                  task.dueDate!.day == today.day;
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CreateButton(
                    nameOfButton: 'Create Task',
                    description: 'you can create your own task here',
                    onPressed: () {
                      showCustomModalBottomSheet(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tasks to complete',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: customListViewBuilder(taskList),
                  ),
                ],
              ),
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text('No tasks found'));
          }
        },
      ),
    );
  }
}
