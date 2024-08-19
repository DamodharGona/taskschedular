import 'package:flutter/material.dart';

import 'package:taskschedular/models/subject_model.dart';
import 'package:taskschedular/widgets/time_selection_bottomsheet.dart';

class DayContainer extends StatefulWidget {
  final List<DaysInWeek> daysInWeekList;
  final Function(List<TimeInDay> selectedTimings, String day)? onSelectTiming;
  final Function(String day, bool isChecked)? onSelectDay;

  const DayContainer({
    super.key,
    this.onSelectTiming,
    this.onSelectDay,
    this.daysInWeekList = const [],
  });

  @override
  State<DayContainer> createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> {
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
            day: widget.daysInWeekList[index],
            onSaveBottomSheet: (List<TimeInDay> selectedTimings) =>
                widget.onSelectTiming?.call(
              selectedTimings,
              widget.daysInWeekList[index].day,
            ),
            //  (List<TimeInDay> selectedTimings) {
            //   daysInWeek[index] =
            //       daysInWeek[index].copyWith(timings: selectedTimings);

            //   widget.subjectsDaysData?.call(daysInWeek);

            //   setState(() {});

            //   Navigator.pop(context);
            // },
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
        itemCount: widget.daysInWeekList.length,
        itemBuilder: (context, index) {
          DaysInWeek dayInWeek = widget.daysInWeekList[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: dayInWeek.isChecked,
                  onChanged: (value) =>
                      widget.onSelectDay?.call(dayInWeek.day, value!),
                  /* Write a return fn */

                  // setState(() {
                  //     widget.daysInWeekList.map((item) {
                  //     if (item.day == dayInWeek.day) {
                  //       return item.copyWith(isChecked: value);
                  //     }
                  //     return item;
                  //   }).toList();
                  // });

                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(dayInWeek.day),
                      Text(
                        dayInWeek.timings
                                .where((time) => time.isSelected)
                                .isEmpty
                            ? 'No timings selected'
                            : dayInWeek.timings
                                .where((time) => time.isSelected)
                                .map((time) => time.time)
                                .join(',\n'),
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: dayInWeek.isChecked,
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
