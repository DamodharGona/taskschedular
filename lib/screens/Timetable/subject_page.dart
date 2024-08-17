// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:taskschedular/bloc/subject_bloc/subject_bloc.dart';
// import 'package:taskschedular/core/utils/utils.dart';
// import 'package:taskschedular/models/day_model_class.dart';
// import 'package:taskschedular/screens/timetable/day_container.dart';
// import 'package:taskschedular/widgets/button.dart';
// import 'package:taskschedular/widgets/my_textfield.dart';

// class SubjectPage extends StatefulWidget {
//   final String subjectId;

//   const SubjectPage({super.key, this.subjectId = ''});

//   @override
//   State<SubjectPage> createState() => _SubjectPageState();
// }

// class _SubjectPageState extends State<SubjectPage> {
//   List<DayModelClass> subjectDaysList = [];

//   Subject subject = const Subject();
//   final nameController = TextEditingController();

//   @override
//   void initState() {
//     if (widget.subjectId.isNotEmpty) {
//       context.read<SubjectBloc>().add(FetchSubjectDataEvent(
//             subjectId: widget.subjectId,
//           ));
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     subjectDaysList.clear();
//     nameController.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<SubjectBloc, SubjectState>(
//       listener: (context, state) {
//         if (state is SubjectDataUploadedState) {
//           showCustomSnackbar(context, message: 'Subject Added Successfully');
//           Navigator.pop(context);
//         }

//         if (state is IndividualSubjectDataFetched) {
//           subject = subject.copyWith(
//             days: state.subject.days,
//             name: state.subject.name,
//             id: state.subject.id,
//           );

//           nameController.text = subject.name;

//           // Debugging statement
//           print("Fetched Days: ${subject.days}");

//           setState(() {});
//         }

//         if (state is SubjectDataLoadingState) {
//           print("Loading.......");
//         }

//         if (state is SubjectFailure) {
//           print("error: ${state.message}");
//         }
//       },
//       builder: (context, state) {
//         if (state is SubjectDataLoadingState) {
//           return const CircularProgressIndicator();
//         }

//         if (state != SubjectDataLoadingState) {
//           return Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               backgroundColor: Colors.white,
//               title: const Text(
//                 'Create Subject',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               actions: [
//                 if (state is SubjectDataUploadingState)
//                   const CircularProgressIndicator(),
//                 if (state != SubjectDataUploadingState)
//                   Buttons(
//                     title: 'save',
//                     border: Border.all(),
//                     onTap: () {
//                       final hasTimeForDays = subjectDaysList
//                           .map((day) => day.selectedTimings
//                               .map((time) => time.isChecked)
//                               .toList())
//                           .toList();

//                       final hasDaysForSubject =
//                           subjectDaysList.map((day) => day.isChecked).toList();

//                       if (nameController.text.trim().isNotEmpty &&
//                           hasDaysForSubject.isNotEmpty &&
//                           hasTimeForDays.isNotEmpty) {
//                         context.read<SubjectBloc>().add(
//                               CreateSubjectEvent(
//                                 subject: Subject(
//                                   name: nameController.text.toString(),
//                                   days: subjectDaysList,
//                                 ),
//                               ),
//                             );
//                       } else {
//                         showCustomSnackbar(
//                           context,
//                           message: 'Please Fill Details',
//                           showCloseIcon: true,
//                         );
//                       }
//                     },
//                   ),
//                 const SizedBox(width: 20),
//               ],
//             ),
//             body: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   MyTextField(
//                     hintText: 'Enter Subject Name',
//                     controller: nameController,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Select days of the week',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 20),
//                   DayContainer(
//                     exsistingDays: subject.days,
//                     subjectsDaysData: (subjectDays) {
//                       setState(() => subjectDaysList = subjectDays);
//                     },
//                   )
//                 ],
//               ),
//             ),
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskschedular/bloc/subject_bloc/subject_bloc.dart';
import 'package:taskschedular/core/utils/utils.dart';
import 'package:taskschedular/models/day_model_class.dart';
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
  List<DayModelClass> subjectDaysList = [];
  Subject subject = const Subject();
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
          subject = subject.copyWith(
            days: state.subject.days,
            name: state.subject.name,
            id: state.subject.id,
          );

          nameController.text = subject.name;

          // Debugging statement
          print("Fetched Days: ${subject.days}");

          setState(() {
            subjectDaysList = subject.days; // Update the list with fetched days
          });
        }

        if (state is SubjectFailure) {
          print("error: ${state.message}");
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
              title: const Text(
                'Create Subject',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  title: 'Save',
                  border: Border.all(),
                  onTap: () {
                    final hasTimeForDays = subjectDaysList
                        .map((day) => day.selectedTimings
                            .map((time) => time.isChecked)
                            .toList())
                        .toList();

                    final hasDaysForSubject =
                        subjectDaysList.map((day) => day.isChecked).toList();

                    if (nameController.text.trim().isNotEmpty &&
                        hasDaysForSubject.isNotEmpty &&
                        hasTimeForDays.isNotEmpty) {
                      context.read<SubjectBloc>().add(
                            CreateSubjectEvent(
                              subject: Subject(
                                name: nameController.text.toString(),
                                days: subjectDaysList,
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
                if (subjectDaysList.isNotEmpty)
                  DayContainer(
                    exsistingDays: subjectDaysList,
                    subjectsDaysData: (subjectDays) {
                      setState(() => subjectDaysList = subjectDays);
                    },
                  )
                else
                  const Center(child: Text('No days available')),
              ],
            ),
          ),
        );
      },
    );
  }
}
