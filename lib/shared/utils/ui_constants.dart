import 'package:flutter/material.dart';

class UiConstants {
  // Text styles
  static const TextStyle headerStyle = TextStyle(
    color: Colors.black,
    fontSize: 34,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subHeaderStyle = TextStyle(
    color: Colors.black,
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle hintTextStyle = TextStyle(
    color: Colors.grey[600],
    fontSize: 12,
  );

  // Common paddings
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets timePickerPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  // Button styling
  static const double buttonBorderRadius = 8.0;
  static const Color buttonColor = Colors.black;
  static const double buttonHeight = 50.0;

  // Colors
  static Color timePickerBgColor = Colors.grey[200]!;
  static const Color activeToggleColor = Colors.green;
  static Color dividerColor = Colors.grey[300]!;
}
