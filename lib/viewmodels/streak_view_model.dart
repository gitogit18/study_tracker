import 'package:flutter/foundation.dart';
import '../models/study_session.dart';
import '../repositories/study_repository.dart';

enum StreakStatus {
  completed,
  freezeUsed,
  missed,
  noData,
  future,
}

class StreakViewModel extends ChangeNotifier {
  StreakViewModel(this.repository);
  final StudyRepository repository;

  int currentStreak = 0;
  int longestStreak = 0;
  int freezesAvailable = 0;
  int successfulDaysCount = 0;
  Map<DateTime, StreakStatus> dailyStatus = {};

  void load() {
    _calculateStreak();
    notifyListeners();
  }

  void _calculateStreak() {
    final sessions = repository.sessions;
    if (sessions.isEmpty) {
      currentStreak = 0;
      longestStreak = repository.settings['longestStreak'] ?? 0;
      freezesAvailable = repository.settings['freezesAvailable'] ?? 0;
      successfulDaysCount = repository.settings['successfulDaysCount'] ?? 0;
      dailyStatus = {};
      return;
    }

    final minutesVal = repository.settings['dailyGoalMinutes'];
    int dailyGoalMinutes = 60;
    if (minutesVal is num) {
      dailyGoalMinutes = minutesVal.toInt();
    } else if (minutesVal is String) {
      dailyGoalMinutes = int.tryParse(minutesVal) ?? 60;
    }
    final dailyGoal = Duration(minutes: dailyGoalMinutes);

    // Group sessions by date
    final sessionsByDate = <DateTime, List<StudySession>>{};
    for (final session in sessions) {
      final date = DateTime(
        session.startedAt.year,
        session.startedAt.month,
        session.startedAt.day,
      );
      sessionsByDate.putIfAbsent(date, () => []).add(session);
    }

    final dates = sessionsByDate.keys.toList()..sort();
    final firstDate = dates.first;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int tempStreak = 0;
    int tempLongest = repository.settings['longestStreak'] ?? 0;
    int tempFreezes = 0; // Start from 0 and reconstruct or use persisted? 
    // The rules say "award 2 Streak Freezes when reaches 2 successful days". 
    // To be safe and follow "derive", we reconstruct.
    int tempSuccessfulDays = 0;
    final tempDailyStatus = <DateTime, StreakStatus>{};

    DateTime current = firstDate;
    while (!current.isAfter(today)) {
      final sessionsForDay = sessionsByDate[current] ?? [];
      final totalTime = sessionsForDay.fold(
        Duration.zero,
        (sum, s) => sum + s.duration,
      );

      if (totalTime >= dailyGoal) {
        tempStreak++;
        tempSuccessfulDays++;
        if (tempSuccessfulDays >= 2) {
          tempFreezes = 2; 
          tempSuccessfulDays = 0;
        }
        tempDailyStatus[current] = StreakStatus.completed;
      } else {
        // Did not reach goal
        if (current == today) {
          // It's today, we don't consume freeze yet unless the day is over?
          // But the streak should reflect current state.
          // If they haven't reached it YET today, it's just NO_DATA until the day ends?
          // "The streak is based on completing the daily focus target, not simply opening or logging into the app."
          tempDailyStatus[current] = StreakStatus.noData;
        } else {
          if (tempFreezes > 0) {
            tempFreezes--;
            tempDailyStatus[current] = StreakStatus.freezeUsed;
          } else {
            tempStreak = 0;
            tempSuccessfulDays = 0;
            tempDailyStatus[current] = StreakStatus.missed;
          }
        }
      }

      if (tempStreak > tempLongest) {
        tempLongest = tempStreak;
      }

      current = DateTime(current.year, current.month, current.day + 1);
    }

    currentStreak = tempStreak;
    longestStreak = tempLongest;
    freezesAvailable = tempFreezes;
    successfulDaysCount = tempSuccessfulDays;
    dailyStatus = tempDailyStatus;

    // Persist if changed
    if (currentStreak != repository.settings['currentStreak'] ||
        longestStreak != repository.settings['longestStreak'] ||
        freezesAvailable != repository.settings['freezesAvailable'] ||
        successfulDaysCount != repository.settings['successfulDaysCount']) {
      repository.updateStreakData(
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        freezesAvailable: freezesAvailable,
        successfulDaysCount: successfulDaysCount,
        freezeUsageDates: dailyStatus.entries
            .where((e) => e.value == StreakStatus.freezeUsed)
            .map((e) => e.key.toIso8601String())
            .toList(),
      );
    }
  }

  StreakStatus getStatusForDate(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (day.isAfter(today)) {
      return StreakStatus.future;
    }
    
    return dailyStatus[day] ?? StreakStatus.noData;
  }
}
