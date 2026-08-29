import 'package:flutter/material.dart';

import 'package:study_tracker/models/study_session.dart';
import 'package:study_tracker/models/subject.dart';

class StudyRepository {
  static final StudyRepository instance = StudyRepository();

  StudyRepository();

  final List<Subject> _subjects = [];
  final List<StudySession> _sessions = [];

  StudyRepository.seeded() {
    _subjects.addAll([
      Subject(
        id: 'mobile',
        name: 'Mobile Development',
        icon: SubjectIcon.code,
        color: const Color(0xFF5A8F82),
      ),
      Subject(
        id: 'db',
        name: 'Database Systems',
        icon: SubjectIcon.book,
        color: const Color(0xFF7E6BA8),
      ),
      Subject(
        id: 'math',
        name: 'Discrete Mathematics',
        icon: SubjectIcon.math,
        color: const Color(0xFFC77B45),
      ),
      Subject(
        id: 'chem',
        name: 'Organic Chemistry',
        icon: SubjectIcon.chemistry,
        color: const Color(0xFF5277AD),
      ),
      Subject(
        id: 'english',
        name: 'English Literature',
        icon: SubjectIcon.literature,
        color: const Color(0xFFB45E58),
      ),
      Subject(
        id: 'history-science',
        name: 'History of Science',
        icon: SubjectIcon.history,
        color: const Color(0xFFC77B45),
      ),
      Subject(
        id: 'cooking',
        name: 'Cooking',
        icon: SubjectIcon.cooking,
        color: const Color(0xFF986B59),
      ),
    ]);

    final now = DateTime.now();

    _sessions.addAll([
      StudySession(
        id: '1',
        subjectId: 'cooking',
        startedAt: DateTime(
          now.year,
          now.month,
          now.day,
          16,
          5,
        ),
        duration: const Duration(minutes: 1),
      ),
      StudySession(
        id: '2',
        subjectId: 'mobile',
        startedAt: DateTime(
          now.year,
          now.month,
          now.day,
          14,
          15,
        ),
        duration: const Duration(
          hours: 1,
          minutes: 34,
        ),
        note: 'Finished Jetpack Compose navigation',
      ),
      StudySession(
        id: '3',
        subjectId: 'db',
        startedAt: DateTime(
          now.year,
          now.month,
          now.day,
          10,
        ),
        duration: const Duration(minutes: 52),
      ),
      StudySession(
        id: '4',
        subjectId: 'mobile',
        startedAt: now.subtract(
          const Duration(
            days: 1,
            hours: 8,
            minutes: 10,
          ),
        ),
        duration: const Duration(
          hours: 1,
          minutes: 11,
        ),
        note: 'Room DB + LiveData patterns',
      ),
      StudySession(
        id: '5',
        subjectId: 'chem',
        startedAt: now.subtract(
          const Duration(
            days: 1,
            hours: 14,
          ),
        ),
        duration: const Duration(minutes: 48),
      ),
      StudySession(
        id: '6',
        subjectId: 'mobile',
        startedAt: now.subtract(
          const Duration(days: 2),
        ),
        duration: const Duration(
          hours: 1,
          minutes: 5,
        ),
      ),
      StudySession(
        id: '7',
        subjectId: 'db',
        startedAt: now.subtract(
          const Duration(
            days: 2,
            hours: 4,
          ),
        ),
        duration: const Duration(minutes: 54),
      ),
      StudySession(
        id: '8',
        subjectId: 'math',
        startedAt: now.subtract(
          const Duration(days: 3),
        ),
        duration: const Duration(
          hours: 1,
          minutes: 20,
        ),
      ),
      StudySession(
        id: '9',
        subjectId: 'history-science',
        startedAt: now.subtract(
          const Duration(
            days: 3,
            hours: 3,
          ),
        ),
        duration: const Duration(minutes: 42),
      ),
      StudySession(
        id: '10',
        subjectId: 'mobile',
        startedAt: now.subtract(
          const Duration(days: 4),
        ),
        duration: const Duration(
          hours: 1,
          minutes: 30,
        ),
      ),
      StudySession(
        id: '11',
        subjectId: 'chem',
        startedAt: now.subtract(
          const Duration(
            days: 4,
            hours: 5,
          ),
        ),
        duration: const Duration(minutes: 55),
      ),
      StudySession(
        id: '12',
        subjectId: 'english',
        startedAt: now.subtract(
          const Duration(days: 5),
        ),
        duration: const Duration(
          hours: 1,
          minutes: 5,
        ),
      ),
      StudySession(
        id: '13',
        subjectId: 'math',
        startedAt: now.subtract(
          const Duration(days: 6),
        ),
        duration: const Duration(
          hours: 1,
          minutes: 9,
        ),
      ),
    ]);
  }

  List<Subject> get subjects =>
      List.unmodifiable(_subjects);

  List<StudySession> get sessions =>
      List.unmodifiable(_sessions);

  Subject? subjectById(String id) {
    for (final subject in _subjects) {
      if (subject.id == id) {
        return subject;
      }
    }

    return null;
  }

  void addSubject(Subject subject) {
    _subjects.add(subject);
  }

  void updateSubject(Subject updated) {
    final index = _subjects.indexWhere(
          (subject) => subject.id == updated.id,
    );

    if (index != -1) {
      _subjects[index] = updated;
    }
  }

  void deleteSubject(String id) {
    _subjects.removeWhere(
          (subject) => subject.id == id,
    );
  }

  void addSession(StudySession session) {
    _sessions.insert(0, session);
  }

  void dispose() {}
}