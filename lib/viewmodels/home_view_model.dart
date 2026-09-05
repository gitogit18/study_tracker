import 'package:flutter/foundation.dart';

import '../models/study_session.dart';
import '../models/subject.dart';
import '../repositories/study_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this.repository);

  final StudyRepository repository;

  List<StudySession> recentSessions = [];

  Duration todayTotal = Duration.zero;

  Duration get dailyGoal {
    final minutesVal = repository.settings['dailyGoalMinutes'];
    int minutes = 60;
    if (minutesVal is num) {
      minutes = minutesVal.toInt();
    } else if (minutesVal is String) {
      minutes = int.tryParse(minutesVal) ?? 60;
    }
    return Duration(minutes: minutes);
  }

  bool get shouldPromptForGoal {
    final now = DateTime.now();
    final today = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final lastSetDate = repository.settings['lastGoalSetDate'] as String?;
    return lastSetDate != today;
  }

  int streak = 0;

  void load() {
    final now = DateTime.now();
    
    // ... logic for recentSessions and todayTotal remains the same
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

  Future<void> setDailyGoal(Duration duration) async {
    await repository.updateDailyGoal(duration.inMinutes);
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