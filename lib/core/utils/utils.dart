import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

void showCustomSnackbar(
  BuildContext context, {
  required String message,
  Color backgroundColor = Colors.black87,
  Color textColor = Colors.white,
  Duration duration = const Duration(seconds: 3),
  SnackBarAction? action,
  bool showCloseIcon = false,
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: textColor),
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    action: action,
    closeIconColor: Colors.white,
    showCloseIcon: showCloseIcon,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String get dayName {
  DateTime now = DateTime.now();
  int dayOfWeek = now.weekday;

  switch (dayOfWeek) {
    case DateTime.monday:
      return "Monday";
    case DateTime.tuesday:
      return "Tuesday";
    case DateTime.wednesday:
      return "Wednesday";
    case DateTime.thursday:
      return "Thursday";
    case DateTime.friday:
      return "Friday";
    case DateTime.saturday:
      return "Saturday";
    case DateTime.sunday:
      return "Sunday";
    default:
      return "Unknown";
  }
}

DateTime parseTime(String time) {
  try {
    final timeParts = time.split(' - ');
    final startTime = DateFormat('h:mm a').parse(timeParts[0]);
    return startTime;
  } catch (e) {
    // Handle parsing errors if any
    return DateTime.now();
  }
}
