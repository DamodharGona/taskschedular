import 'package:flutter/material.dart';

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
