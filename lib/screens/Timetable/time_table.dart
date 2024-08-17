import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskschedular/bloc/subject_bloc/subject_bloc.dart';
import 'package:taskschedular/screens/timetable/subject_page.dart';
import 'package:taskschedular/widgets/create_button.dart';

class TimeTablePage extends StatelessWidget {
  const TimeTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            BlocConsumer<SubjectBloc, SubjectState>(
              bloc: SubjectBloc()
                ..add(FetchSubjectsBasedOnDayEvent(dayOfWeek: 'Monday')),
              listener: (context, state) {},
              builder: (context, state) {
                if (state is SubjectDataFetchedState) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.selectedDayData.selectedTimings.length,
                    itemBuilder: (context, index) {
                      final time = state.selectedDayData.selectedTimings[index];
                      return ListTile(
                        title: Text(time.subjectName),
                        subtitle: Text(time.timing),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubjectPage(
                                subjectId: time.subjectId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return const Text("No Data Found");
              },
            ),
          ],
        ),
      ),
    );
  }
}
