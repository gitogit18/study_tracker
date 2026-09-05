import 'package:flutter_test/flutter_test.dart';
import 'package:study_tracker/models/study_session.dart';
import 'package:study_tracker/repositories/study_repository.dart';
import 'package:study_tracker/viewmodels/streak_view_model.dart';

class MockStudyRepository extends StudyRepository {
  MockStudyRepository() : super('test_uid');

  List<StudySession> _mockSessions = [];
  Map<String, dynamic> _mockSettings = {};

  void setSessions(List<StudySession> sessions) {
    _mockSessions = sessions;
  }

  void setSettings(Map<String, dynamic> settings) {
    _mockSettings = settings;
  }

  @override
  List<StudySession> get sessions => _mockSessions;

  @override
  Map<String, dynamic> get settings => _mockSettings;

  @override
  void _init() {} // Do nothing

  @override
  Future<void> updateStreakData({
    required int currentStreak,
    required int longestStreak,
    required int freezesAvailable,
    required int successfulDaysCount,
    required List<String> freezeUsageDates,
  }) async {
    _mockSettings['currentStreak'] = currentStreak;
    _mockSettings['longestStreak'] = longestStreak;
    _mockSettings['freezesAvailable'] = freezesAvailable;
    _mockSettings['successfulDaysCount'] = successfulDaysCount;
  }
}

void main() {
  group('Streak Logic Tests', () {
    late MockStudyRepository repository;
    late StreakViewModel viewModel;

    setUp(() {
      repository = MockStudyRepository();
      viewModel = StreakViewModel(repository);
    });

    test('Streak increases on successful days', () {
      final today = DateTime.now();
      repository.setSessions([
        StudySession(
          id: '1',
          subjectId: 'math',
          startedAt: today.subtract(const Duration(days: 1)),
          duration: const Duration(minutes: 60),
        ),
      ]);
      repository.setSettings({'dailyGoalMinutes': 60});

      viewModel.load();

      expect(viewModel.currentStreak, 1);
      expect(viewModel.dailyStatus[DateTime(today.year, today.month, today.day - 1)], StreakStatus.completed);
    });

    test('Freeze is used on missed day', () {
      final today = DateTime.now();
      // Earned a freeze previously
      repository.setSessions([
        StudySession(
          id: '1',
          subjectId: 'math',
          startedAt: today.subtract(const Duration(days: 3)),
          duration: const Duration(minutes: 60),
        ),
        StudySession(
          id: '2',
          subjectId: 'math',
          startedAt: today.subtract(const Duration(days: 2)),
          duration: const Duration(minutes: 60),
        ),
        // Missed day 1
      ]);
      repository.setSettings({'dailyGoalMinutes': 60});

      viewModel.load();

      // After 2 successful days (day -3, day -2), freezes should be 2.
      // Day -1 was missed, so 1 freeze should be used.
      expect(viewModel.freezesAvailable, 1);
      expect(viewModel.currentStreak, 2);
      expect(viewModel.dailyStatus[DateTime(today.year, today.month, today.day - 1)], StreakStatus.freezeUsed);
    });

    test('Streak resets when no freezes available', () {
      final today = DateTime.now();
      repository.setSessions([
        StudySession(
          id: '1',
          subjectId: 'math',
          startedAt: today.subtract(const Duration(days: 2)),
          duration: const Duration(minutes: 60),
        ),
        // Day -1 missed, no freezes earned yet (only 1 successful day)
      ]);
      repository.setSettings({'dailyGoalMinutes': 60});

      viewModel.load();

      expect(viewModel.currentStreak, 0);
      expect(viewModel.dailyStatus[DateTime(today.year, today.month, today.day - 1)], StreakStatus.missed);
    });

    test('Freeze rewards are given every 2 successful days', () {
      final today = DateTime.now();
      repository.setSessions([
        StudySession(id: '1', subjectId: 's', startedAt: today.subtract(const Duration(days: 2)), duration: const Duration(minutes: 60)),
        StudySession(id: '2', subjectId: 's', startedAt: today.subtract(const Duration(days: 1)), duration: const Duration(minutes: 60)),
      ]);
      repository.setSettings({'dailyGoalMinutes': 60});

      viewModel.load();

      expect(viewModel.freezesAvailable, 2);
      expect(viewModel.currentStreak, 2);
    });
  });
}
