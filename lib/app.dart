import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'repositories/study_repository.dart';
import 'viewmodels/history_view_model.dart';
import 'viewmodels/home_view_model.dart';
import 'viewmodels/session_view_model.dart';
import 'viewmodels/stats_view_model.dart';
import 'viewmodels/subject_view_model.dart';
import 'views/main_shell.dart';

class StudyTrackerApp extends StatefulWidget {
  const StudyTrackerApp({super.key});

  @override
  State<StudyTrackerApp> createState() =>
      _StudyTrackerAppState();
}

class _StudyTrackerAppState
    extends State<StudyTrackerApp> {

  late final StudyRepository repository;

  late final HomeViewModel homeViewModel;
  late final SubjectViewModel subjectViewModel;
  late final HistoryViewModel historyViewModel;
  late final StatsViewModel statsViewModel;
  late final SessionViewModel sessionViewModel;

  @override
  void initState() {
    super.initState();

    repository = StudyRepository();

    homeViewModel =
    HomeViewModel(repository)..load();

    subjectViewModel =
    SubjectViewModel(repository)..load();

    historyViewModel =
    HistoryViewModel(repository)..load();

    statsViewModel =
    StatsViewModel(repository)..load();

    sessionViewModel =
        SessionViewModel(repository);
  }

  @override
  void dispose() {
    homeViewModel.dispose();
    subjectViewModel.dispose();
    historyViewModel.dispose();
    statsViewModel.dispose();
    sessionViewModel.dispose();

    repository.dispose();

    super.dispose();
  }

  void refreshAll() {
    homeViewModel.load();
    subjectViewModel.load();
    historyViewModel.load();
    statsViewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Tracker',
      theme: AppTheme.lightTheme,
      home: MainShell(
        homeViewModel: homeViewModel,
        subjectViewModel: subjectViewModel,
        historyViewModel: historyViewModel,
        statsViewModel: statsViewModel,
        sessionViewModel: sessionViewModel,
        onDataChanged: refreshAll,
      ),
    );
  }
}