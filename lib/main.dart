import 'package:flutter/material.dart';

import 'core/themes/app_theme.dart';
import 'views/main_shell.dart';

void main() {
  runApp(const StudyTrackerApp());
}

class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Tracker',

      theme: AppTheme.lightTheme,

      home: const MainShell(),
    );
  }
}