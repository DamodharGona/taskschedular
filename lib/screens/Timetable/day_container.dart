import 'package:flutter/material.dart';

import 'package:taskschedular/models/day_model_class.dart';
import 'package:taskschedular/models/timing_model_class.dart';
import 'package:taskschedular/screens/timetable/data.dart';
import 'package:taskschedular/widgets/time_selection_bottomsheet.dart';

class DayContainer extends StatefulWidget {
  final List<DayModelClass> exsistingDays;
  final Function(List<DayModelClass> subjectDays)? subjectsDaysData;

  const DayContainer({
    super.key,
    this.subjectsDaysData,
    this.exsistingDays = const [],
  });

  @override
  State<DayContainer> createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> {
  List<DayModelClass> dayData = [];

  @override
  void initState() {
    super.initState();
    dayData = days;
    setState(() {});
  }

  void selectTimings(int index) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.95,
          child: TimeSelectionBottomsheet(
            day: days[index],
            onSaveBottomSheet: (List<TimingModelClass> selectedTimings) {
              // Create a new list of selected timings with only checked items
              List<TimingModelClass> updatedTimings = selectedTimings
                  .where((time) => time.isChecked)
                  .map((time) => time)
                  .toList();

              final dayModel = dayData[index];

              // Create an updated DayModelClass instance
              final updatedDayModel = dayModel.copyWith(
                selectedTimings: updatedTimings,
              );

              // Update the dayData list with the new DayModelClass instance
              setState(() {
                final index =
                    dayData.indexWhere((day) => day.id == dayModel.id);
                if (index != -1) {
                  dayData[index] = updatedDayModel;
                }
              });

              widget.subjectsDaysData?.call(dayData);

              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: dayData.length,
        itemBuilder: (context, index) {
          DayModelClass dayModel = dayData[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: dayModel.isChecked,
                  onChanged: (value) {
                    setState(() {
                      dayData = dayData.map((item) {
                        if (item.id == dayModel.id) {
                          return item.copyWith(isChecked: value);
                        }
                        return item;
                      }).toList();
                    });
                  },
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(dayModel.day),
                      Text(
                        dayModel.selectedTimings.isEmpty
                            ? 'No timings selected'
                            : dayModel.selectedTimings
                                .map((time) => time.timing)
                                .join(',\n'),
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: dayModel.isChecked,
                  child: IconButton(
                    onPressed: () => selectTimings(index),
                    icon: const Icon(Icons.add_circle_outline_sharp),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
