import 'package:flutter/foundation.dart';

import 'package:study_tracker/models/study_session.dart';
import 'package:study_tracker/models/subject.dart';
import 'package:study_tracker/repositories/study_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this.repository);

  final StudyRepository repository;

  List<StudySession> recentSessions = [];

  Duration todayTotal = Duration.zero;

  final Duration dailyGoal =
  const Duration(hours: 4);

  int streak = 0;

  void load() {
    final now = DateTime.now();

    recentSessions = repository.sessions
        .where(
          (session) =>
      session.startedAt.year == now.year &&
          session.startedAt.month == now.month &&
          session.startedAt.day == now.day,
    )
        .toList();

    todayTotal = recentSessions.fold(
      Duration.zero,
          (sum, session) => sum + session.duration,
    );

    notifyListeners();
  }

  Duration get todayStudyTime => todayTotal;

  int get progressPercent {
    return (progress * 100).toInt();
  }

  Duration get remainingTime {
    final remaining = dailyGoal - todayTotal;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Subject? getSubject(String id) {
    return repository.subjectById(id);
  }

  double get progress {
    if (dailyGoal.inSeconds == 0) {
      return 0;
    }

    return (todayTotal.inSeconds /
        dailyGoal.inSeconds)
        .clamp(0.0, 1.0);
  }
}