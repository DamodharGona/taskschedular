import 'package:flutter/material.dart';
import 'package:taskschedular/components/button.dart';
import 'package:taskschedular/components/dotted_boder.dart';
import 'package:taskschedular/models/day_model_class.dart';
import 'package:taskschedular/models/timing_model_class.dart';

class DayContainer extends StatefulWidget {
  const DayContainer({super.key});

  @override
  State<DayContainer> createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> {
  List<TimingModelClass> timings = [
    TimingModelClass(id: '1', timing: '9:00 AM - 10:00 AM', isChecked: false),
    TimingModelClass(id: '2', timing: '10:00 AM - 11:00 AM', isChecked: false),
    TimingModelClass(id: '3', timing: '11:00 AM - 12:00 PM', isChecked: false),
    TimingModelClass(id: '4', timing: '12:00 PM - 1:00 PM', isChecked: false),
    TimingModelClass(id: '5', timing: '1:00 PM - 2:00 PM', isChecked: false),
    TimingModelClass(id: '6', timing: '2:00 PM - 3:00 PM', isChecked: false),
    TimingModelClass(id: '7', timing: '3:00 PM - 4:00 PM', isChecked: false),
    TimingModelClass(id: '8', timing: '4:00 PM - 5:00 PM', isChecked: false),
  ];

  List<DayModelClass> days = [
    DayModelClass(id: '1', day: 'Monday', isChecked: false),
    DayModelClass(id: '2', day: 'Tuesday', isChecked: false),
    DayModelClass(id: '3', day: 'Wednesday', isChecked: false),
    DayModelClass(id: '4', day: 'Thursday', isChecked: false),
    DayModelClass(id: '5', day: 'Friday', isChecked: false),
    DayModelClass(id: '6', day: 'Saturday', isChecked: false),
    DayModelClass(id: '7', day: 'Sunday', isChecked: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final dayModel = days[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Checkbox(
                  value: dayModel.isChecked,
                  onChanged: (value) {
                    setState(() {
                      days = days.map((item) {
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
                    children: [
                      Text(dayModel.day),
                      Text(
                        dayModel.selectedTimings.isEmpty
                            ? 'No timings selected'
                            : dayModel.selectedTimings.join(','),
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            setState(() {
                                              // updating the  timings selected to the selectedTimings

                                              days = days.map((item) {
                                                if (item.id == dayModel.id) {
                                                  return item.copyWith(
                                                    selectedTimings: timings
                                                        .where(
                                                            (t) => t.isChecked)
                                                        .map((t) => t.timing)
                                                        .toList(),
                                                  );
                                                }
                                                return item;
                                              }).toList();
                                              // unselecting all the items
                                              timings = timings.map((item) {
                                                return item.copyWith(
                                                    isChecked: false);
                                              }).toList();
                                            });
                                            Navigator.pop(context);
                                          },
                                          border: Border.all(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Pick your subject timings',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Text(
                                      'Select timing of subject, you can select more than one',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 400,
                                      child: ListView.builder(
                                        itemCount: timings.length,
                                        itemBuilder: (context, index) {
                                          final time = timings[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  timings = timings.map((item) {
                                                    if (item.id == time.id) {
                                                      return item.copyWith(
                                                          isChecked:
                                                              !item.isChecked);
                                                    }
                                                    return item;
                                                  }).toList();
                                                });
                                              },
                                              child: DottedBoder(
                                                timings: time.timing,
                                                color: time.isChecked
                                                    ? Colors.blue
                                                    : Colors.grey,
                                                containerColors: time.isChecked
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline_sharp),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
