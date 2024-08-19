import 'package:taskschedular/models/day_model_class.dart';
import 'package:taskschedular/models/subject_model.dart';
import 'package:taskschedular/models/timing_model_class.dart';

List<TimingModelClass> timings = [
  const TimingModelClass(
    id: '1',
    timing: '9:00 AM - 10:00 AM',
    isChecked: false,
  ),
  const TimingModelClass(
    id: '2',
    timing: '10:00 AM - 11:00 AM',
    isChecked: false,
  ),
  const TimingModelClass(
    id: '3',
    timing: '11:00 AM - 12:00 PM',
    isChecked: false,
  ),
  const TimingModelClass(
    id: '4',
    timing: '12:00 PM - 1:00 PM',
    isChecked: false,
  ),
  const TimingModelClass(
    id: '5',
    timing: '1:00 PM - 2:00 PM',
    isChecked: false,
  ),
  const TimingModelClass(
    id: '6',
    timing: '2:00 PM - 3:00 PM',
    isChecked: false,
  ),
  const TimingModelClass(
    id: '7',
    timing: '3:00 PM - 4:00 PM',
    isChecked: false,
  ),
  const TimingModelClass(
    id: '8',
    timing: '4:00 PM - 5:00 PM',
    isChecked: false,
  ),
];

List<DayModelClass> days = [
  const DayModelClass(id: '1', day: 'Monday', isChecked: false),
  const DayModelClass(id: '2', day: 'Tuesday', isChecked: false),
  const DayModelClass(id: '3', day: 'Wednesday', isChecked: false),
  const DayModelClass(id: '4', day: 'Thursday', isChecked: false),
  const DayModelClass(id: '5', day: 'Friday', isChecked: false),
  const DayModelClass(id: '6', day: 'Saturday', isChecked: false),
  const DayModelClass(id: '7', day: 'Sunday', isChecked: false),
];

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
