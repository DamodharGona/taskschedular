import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskschedular/bloc/subject_bloc/subject_bloc.dart';
import 'package:taskschedular/core/utils/utils.dart';
import 'package:taskschedular/screens/timetable/data.dart';
import 'package:taskschedular/screens/timetable/subject_page.dart';
import 'package:taskschedular/widgets/create_button.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key});

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  String selectedDay = dayName;

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
                ..add(FetchSubjectsBasedOnDayEvent(dayOfWeek: selectedDay)),
              listener: (context, state) {},
              builder: (context, state) {
                if (state is SubjectDataFetchedState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: daysInWeekData.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final day = daysInWeekData[index];

                            final isSelected = day.day == selectedDay;

                            return FilterChip(
                              label: Text(day.day),
                              selected: isSelected,
                              backgroundColor: Colors.white,
                              selectedColor: Colors.indigoAccent,
                              onSelected: (isSelected) {
                                if (isSelected) {
                                  selectedDay = day.day;
                                } else {
                                  selectedDay = dayName;
                                }
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.selectedDayData.length,
                        itemBuilder: (context, index) {
                          final data = state.selectedDayData[index];

                          return ListTile(
                            title: Text(data.subjectName),
                            subtitle: Text(data.time),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubjectPage(
                                    subjectId: data.subjectId,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    ],
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
