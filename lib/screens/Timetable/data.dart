import 'package:taskschedular/models/subject_model.dart';

List<TimeInDay> dayTimings = const [
  TimeInDay(
    time: '9:00 AM - 10:00 AM',
    isSelected: false,
  ),
  TimeInDay(
    time: '10:00 AM - 11:00 AM',
    isSelected: false,
  ),
  TimeInDay(
    time: '11:00 AM - 12:00 PM',
    isSelected: false,
  ),
  TimeInDay(
    time: '12:00 PM - 1:00 PM',
    isSelected: false,
  ),
  TimeInDay(
    time: '1:00 PM - 2:00 PM',
    isSelected: false,
  ),
  TimeInDay(
    time: '2:00 PM - 3:00 PM',
    isSelected: false,
  ),
  TimeInDay(
    time: '3:00 PM - 4:00 PM',
    isSelected: false,
  ),
  TimeInDay(
    time: '4:00 PM - 5:00 PM',
    isSelected: false,
  ),
];

List<DaysInWeek> daysInWeekData = [
  DaysInWeek(
    day: 'Monday',
    isChecked: false,
    timings: dayTimings,
  ),
  DaysInWeek(
    day: 'Tuesday',
    isChecked: false,
    timings: dayTimings,
  ),
  DaysInWeek(
    day: 'Wednesday',
    isChecked: false,
    timings: dayTimings,
  ),
  DaysInWeek(
    day: 'Thursday',
    isChecked: false,
    timings: dayTimings,
  ),
  DaysInWeek(
    day: 'Friday',
    isChecked: false,
    timings: dayTimings,
  ),
  DaysInWeek(
    day: 'Saturday',
    isChecked: false,
    timings: dayTimings,
  ),
];
