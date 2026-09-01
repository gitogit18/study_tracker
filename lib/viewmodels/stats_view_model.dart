import 'package:flutter/foundation.dart';

import '../models/study_session.dart';
import '../repositories/study_repository.dart';

enum StatPeriod { daily, weekly, monthly }

class StatsViewModel extends ChangeNotifier {
  StatsViewModel(this.repository);

  final StudyRepository repository;

  StatPeriod _selectedPeriod = StatPeriod.weekly;
  StatPeriod get selectedPeriod => _selectedPeriod;

  void setPeriod(StatPeriod period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  List<StudySession> get allSessions => repository.sessions;

  List<StudySession> get filteredSessions {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case StatPeriod.daily:
        return allSessions.where((s) => _sameDay(s.startedAt, now)).toList();
      case StatPeriod.weekly:
        final start = weekStart;
        final end = weekEnd.add(const Duration(days: 1));
        return allSessions
            .where((s) => s.startedAt.isAfter(start) && s.startedAt.isBefore(end))
            .toList();
      case StatPeriod.monthly:
        return allSessions
            .where((s) => s.startedAt.year == now.year && s.startedAt.month == now.month)
            .toList();
    }
  }

  int get totalSessions => filteredSessions.length;

  Duration get totalStudyTime {
    return filteredSessions.fold(
      Duration.zero,
      (total, session) => total + session.duration,
    );
  }

  int get averageDurationMinutes {
    if (filteredSessions.isEmpty) {
      return 0;
    }

    return totalStudyTime.inMinutes ~/ filteredSessions.length;
  }

  double get totalStudyHours {
    return totalStudyTime.inMinutes / 60;
  }

  List<int> get chartData {
    switch (_selectedPeriod) {
      case StatPeriod.daily:
        // For daily, we'll return subject-based minutes for a different visualization
        // or just empty for now to hide it. Let's return 1 bar for today.
        return [totalStudyTime.inMinutes];
      case StatPeriod.weekly:
        return weeklyStudyMinutes;
      case StatPeriod.monthly:
        return monthlyStudyMinutes;
    }
  }

  List<String> get chartLabels {
    switch (_selectedPeriod) {
      case StatPeriod.daily:
        return ['Today'];
      case StatPeriod.weekly:
        return ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
      case StatPeriod.monthly:
        return ['W1', 'W2', 'W3', 'W4', 'W5'];
    }
  }

  List<int> get weeklyStudyMinutes {
    final start = weekStart;
    return List.generate(7, (index) {
      final day = start.add(Duration(days: index));
      return allSessions
          .where((session) => _sameDay(session.startedAt, day))
          .fold(0, (total, session) => total + session.duration.inMinutes);
    });
  }

  List<int> get monthlyStudyMinutes {
    final now = DateTime.now();
    // Group current month sessions into 5 weeks
    final weeks = List.filled(5, 0);
    for (final session in allSessions) {
      if (session.startedAt.year == now.year && session.startedAt.month == now.month) {
        final weekIndex = ((session.startedAt.day - 1) ~/ 7).clamp(0, 4);
        weeks[weekIndex] += session.duration.inMinutes;
      }
    }
    return weeks;
  }

  Map<String, Duration> get subjectBreakdown {
    final result = <String, Duration>{};

    for (final session in filteredSessions) {
      final subject = repository.subjectById(session.subjectId);
      if (subject == null) continue;

      result.update(
        subject.name,
        (existing) => existing + session.duration,
        ifAbsent: () => session.duration,
      );
    }

    return result;
  }

  DateTime get weekStart {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.subtract(Duration(days: today.weekday - 1));
  }

  DateTime get weekEnd {
    return weekStart.add(const Duration(days: 6));
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void load() {
    notifyListeners();
  }
}
