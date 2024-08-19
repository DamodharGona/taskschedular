import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskschedular/bloc/subject_bloc/subject_bloc.dart';
import 'package:taskschedular/core/utils/utils.dart';
import 'package:taskschedular/models/subject_model.dart';
import 'package:taskschedular/screens/timetable/data.dart';
import 'package:taskschedular/screens/timetable/day_container.dart';
import 'package:taskschedular/widgets/button.dart';
import 'package:taskschedular/widgets/my_textfield.dart';

class SubjectPage extends StatefulWidget {
  final String subjectId;

  const SubjectPage({super.key, this.subjectId = ''});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  SubjectModel subjectModel = SubjectModel(timeTable: daysInWeekData);
  SubjectModel subjectModelCopy = SubjectModel(timeTable: daysInWeekData);

  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.subjectId.isNotEmpty) {
      context
          .read<SubjectBloc>()
          .add(FetchSubjectDataEvent(subjectId: widget.subjectId));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubjectBloc, SubjectState>(
      listener: (context, state) {
        if (state is SubjectDataUploadedState) {
          showCustomSnackbar(context, message: 'Subject Added Successfully');
          Navigator.pop(context);
        }

        if (state is IndividualSubjectDataFetched) {
          subjectModel = state.subject;
          subjectModelCopy = subjectModel;

          nameController.text = subjectModel.subjectName;

          setState(() {});
        }

        if (state is SubjectFailure) {
          showCustomSnackbar(context,
              message: 'Error fetching subject data', showCloseIcon: true);
        }
      },
      builder: (context, state) {
        if (state is SubjectDataLoadingState) {
          // Display a loading indicator while data is being fetched
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                '${widget.subjectId.isEmpty ? 'Create ' : 'Edit '}  Subject',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Create Subject',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            actions: [
              if (state is SubjectDataUploadingState)
                const CircularProgressIndicator(),
              if (state is! SubjectDataUploadingState)
                Buttons(
                  title: 'Cancel',
                  border: Border.all(),
                  onTap: () {
                    subjectModel = subjectModelCopy;
                    setState(() {});
                  },
                ),
              const SizedBox(width: 10),
              if (state is! SubjectDataUploadingState)
                Buttons(
                  title: 'Save',
                  border: Border.all(),
                  onTap: () {
                    final hasTimeForDays = subjectModel.timeTable
                        .map((day) =>
                            day.timings.map((time) => time.isSelected).toList())
                        .toList();

                    final hasDaysForSubject = subjectModel.timeTable
                        .map((day) => day.isChecked)
                        .toList();

                    if (nameController.text.trim().isNotEmpty &&
                        hasDaysForSubject.isNotEmpty &&
                        hasTimeForDays.isNotEmpty) {
                      context.read<SubjectBloc>().add(
                            CreateSubjectEvent(
                              subject: SubjectModel(
                                subjectName: nameController.text.toString(),
                                timeTable: subjectModel.timeTable,
                              ),
                            ),
                          );
                    } else {
                      showCustomSnackbar(
                        context,
                        message: 'Please Fill Details',
                        showCloseIcon: true,
                      );
                    }
                  },
                ),
              const SizedBox(width: 20),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextField(
                  hintText: 'Enter Subject Name',
                  controller: nameController,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Select days of the week',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                DayContainer(
                  daysInWeekList: subjectModel.timeTable,
                  onSelectTiming:
                      (List<TimeInDay> selectedTimings, String day) {
                    final updatedTimeTable = subjectModel.timeTable.map((e) {
                      if (e.day == day) {
                        return e.copyWith(timings: selectedTimings);
                      }
                      return e; // Keep other days unchanged
                    }).toList();

                    subjectModel = subjectModel.copyWith(
                      timeTable: updatedTimeTable,
                    );

                    Navigator.pop(context);

                    setState(() {});
                  },
                  onSelectDay: (String day, bool isChecked) {
                    final updatedTimeTable = subjectModel.timeTable.map((e) {
                      if (e.day == day) {
                        return e.copyWith(isChecked: isChecked);
                      }
                      return e; // Keep other days unchanged
                    }).toList();

                    subjectModel = subjectModel.copyWith(
                      timeTable: updatedTimeTable,
                    );

                    setState(() {});
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
