import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskschedular/bloc/subject_bloc/subject_bloc.dart';
import 'package:taskschedular/models/day_model_class.dart';
import 'package:taskschedular/models/timing_model_class.dart';
import 'package:taskschedular/screens/timetable/data.dart';
import 'package:taskschedular/widgets/button.dart';
import 'package:taskschedular/widgets/dotted_boder.dart';

class TimeSelectionBottomsheet extends StatefulWidget {
  final DayModelClass day;

  final Function(List<TimingModelClass> selectedTimings)? onSaveBottomSheet;

  const TimeSelectionBottomsheet({
    super.key,
    this.day = const DayModelClass(),
    this.onSaveBottomSheet,
  });

  @override
  State<TimeSelectionBottomsheet> createState() =>
      _TimeSelectionBottomsheetState();
}

class _TimeSelectionBottomsheetState extends State<TimeSelectionBottomsheet> {
  late List<TimingModelClass> timingsData;

  @override
  void initState() {
    super.initState();

    // Initialize `timingsData` with `timings` and update based on `selectedTimings`
    timingsData = timings.map((time) {
      final isChecked =
          widget.day.selectedTimings.any((selected) => selected.id == time.id);
      return time.copyWith(isChecked: isChecked);
    }).toList();

    // Fetch subjects based on the selected day
    context
        .read<SubjectBloc>()
        .add(FetchSubjectsBasedOnDayEvent(dayOfWeek: widget.day.day));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubjectBloc, SubjectState>(
      listener: (context, state) {
        if (state is SubjectDataFetchedState) {
          // Update `timingsData` based on `selectedDayData`
          timingsData = timingsData.map((time) {
            final matchingTiming =
                state.selectedDayData.selectedTimings.firstWhere(
              (selected) => selected.timing == time.timing,
              orElse: () => const TimingModelClass(),
            );

            final isBlocked = matchingTiming.id.isNotEmpty;
            final subjectName = matchingTiming.subjectName;

            return time.copyWith(
              isBlocked: isBlocked,
              subjectName: subjectName,
            );
          }).toList();

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
              if (state is SubjectDataFetchedState)
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
                                  timingsData[index] =
                                      time.copyWith(isChecked: !time.isChecked);
                                });
                              },
                        child: DottedBoder(
                          timings: time.isBlocked
                              ? '${time.subjectName} - ${time.timing}'
                              : time.timing,
                          isSelected: time.isChecked,
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
