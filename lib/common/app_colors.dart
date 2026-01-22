import 'package:flutter/material.dart';

class AppColors {
  // Category colors
  static const List<Color> availableCategoryColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  static const Color defaultHomeCategory = Colors.teal;
  static const Color defaultUniversityCategory = Color.fromARGB(
    255,
    161,
    114,
    39,
  );

  // Common UI
  static const Color fabBackground = Color.fromARGB(255, 106, 106, 106);
  static const Color deleteSwipeBackground = Colors.red;
  static const Color deleteIcon = Colors.white;
  static const Color iconPickerUnselectedBackground = Color.fromARGB(
    255,
    157,
    157,
    157,
  );
  static const Color iconPickerUnselectedIcon = Color.fromARGB(255, 0, 0, 0);

  // Checklist screen
  static const Color deleteModeAppBar = Colors.red;
  static const Color deleteModeBannerBackground = Color(0xFFFFEBEE);
  static const Color deleteModeBannerText = Colors.red;

  static const Color speedDialAdd = Colors.blue;
  static const Color speedDialReset = Colors.red;
  static const Color speedDialForeground = Colors.white;

  // Packing list item
  static const Color deleteSelection = Colors.red;
  static const Color checkedText = Colors.grey;

  // Theme colors
  static const Color seedColor = Color.fromARGB(255, 73, 187, 138);
  static const Color lightScaffoldBackground = Color(0xFFF5F5F5);
  static const Color lightAppBarBackground = Color.fromARGB(255, 106, 106, 106);
  static const Color darkScaffoldBackground = Color(0xFF121212);
  static const Color darkAppBarBackground = Color(0xFF1F1F1F);
  static const Color darkCard = Color(0xFF2C2C2C);
}
