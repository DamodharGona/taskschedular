import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskschedular/bloc/subject_bloc/subject_bloc.dart';
import 'package:taskschedular/models/subject_model.dart';
import 'package:taskschedular/widgets/button.dart';
import 'package:taskschedular/widgets/dotted_boder.dart';

class TimeSelectionBottomsheet extends StatefulWidget {
  final DaysInWeek day;

  final Function(List<TimeInDay> selectedTimings)? onSaveBottomSheet;

  const TimeSelectionBottomsheet({
    super.key,
    this.day = const DaysInWeek(),
    this.onSaveBottomSheet,
  });

  @override
  State<TimeSelectionBottomsheet> createState() =>
      _TimeSelectionBottomsheetState();
}

class _TimeSelectionBottomsheetState extends State<TimeSelectionBottomsheet> {
  List<TimeInDay> timingsData = [];

  @override
  void initState() {
    super.initState();

    // Initialize `timingsData` with `timings` and update based on `selectedTimings`
    timingsData = List<TimeInDay>.from(widget.day.timings);

    // // Fetch subjects based on the selected day
    context
        .read<SubjectBloc>()
        .add(FetchAllSubjectsTimingsBasedOnDay(dayOfWeek: widget.day.day));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubjectBloc, SubjectState>(
      listener: (context, state) {
        if (state is TimesOfDayDataFetchedState &&
            state.timesOfDay.isNotEmpty) {
          for (var fetchedTime in state.timesOfDay) {
            final index =
                timingsData.indexWhere((t) => t.time == fetchedTime.time);
            if (index != -1) {
              timingsData[index] = timingsData[index].copyWith(
                valueX: fetchedTime.valueX,
                isBlocked: fetchedTime.isBlocked,
              );
            }
          }
          setState(() {});
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Buttons(
                    title: 'cancel',
                    onTap: () => Navigator.pop(context),
                    border: Border.all(),
                  ),
                  Buttons(
                    title: 'save',
                    onTap: () => widget.onSaveBottomSheet?.call(timingsData),
                    border: Border.all(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Pick your subject timings',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const Text(
                'Select timing of subject, you can select more than one',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              if (state is SubjectDataLoadingState)
                const Center(child: CircularProgressIndicator()),
              // if (state is SubjectDataFetchedState)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: timingsData.length,
                itemBuilder: (context, index) {
                  final time = timingsData[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: time.isBlocked
                          ? null
                          : () {
                              setState(() {
                                timingsData[index] = time.copyWith(
                                  isSelected: !time.isSelected,
                                );
                              });
                            },
                      child: DottedBoder(
                        timings: time.isBlocked
                            ? '${time.valueX} - ${time.time}'
                            : time.time,
                        isSelected: time.isSelected,
                        isBlocked: time.isBlocked,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
