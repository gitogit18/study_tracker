import 'package:flutter/foundation.dart';

import '../models/study_session.dart';
import '../repositories/study_repository.dart';

class StatsViewModel extends ChangeNotifier {
  StatsViewModel(this.repository);

  final StudyRepository repository;

  List<StudySession> get sessions => repository.sessions;

  int get totalSessions => sessions.length;

  Duration get totalStudyTime {
    return sessions.fold(
      Duration.zero,
          (total, session) => total + session.duration,
    );
  }

  int get averageDurationMinutes {
    if (sessions.isEmpty) {
      return 0;
    }

    return totalStudyTime.inMinutes ~/ sessions.length;
  }

  double get totalStudyHours {
    return totalStudyTime.inMinutes / 60;
  }

  /// Returns total study minutes for each day of the
  /// current Monday-Sunday week.
  List<int> get weeklyStudyMinutes {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final monday = today.subtract(
      Duration(days: today.weekday - 1),
    );

    return List.generate(7, (index) {
      final day = monday.add(
        Duration(days: index),
      );

      return sessions
          .where(
            (session) =>
            _sameDay(session.startedAt, day),
      )
          .fold(
        0,
            (total, session) =>
        total + session.duration.inMinutes,
      );
    });
  }

  /// Total study time grouped by subject.
  Map<String, Duration> get subjectBreakdown {
    final result = <String, Duration>{};

    for (final session in sessions) {
      final subject = repository.subjectById(
        session.subjectId,
      );

      if (subject == null) {
        continue;
      }

      result.update(
        subject.name,
            (existing) =>
        existing + session.duration,
        ifAbsent: () => session.duration,
      );
    }

    return result;
  }

  DateTime get weekStart {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    return today.subtract(
      Duration(days: today.weekday - 1),
    );
  }

  DateTime get weekEnd {
    return weekStart.add(
      const Duration(days: 6),
    );
  }

  bool _sameDay(
      DateTime a,
      DateTime b,
      ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  void load() {
    notifyListeners();
  }
}