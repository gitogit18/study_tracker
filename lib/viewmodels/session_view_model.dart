import 'package:flutter/foundation.dart';
import '../repositories/study_repository.dart';
import '../models/study_session.dart';

class SessionViewModel extends ChangeNotifier {
  SessionViewModel(this.repository);
  final StudyRepository repository;

  String? selectedSubjectId;

  void selectSubject(String id) {
    selectedSubjectId = id;
    notifyListeners();
  }

  void saveSession({
    required String subjectId,
    required DateTime startedAt,
    required Duration duration,
    String? note,
  }) {
    final session = StudySession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subjectId: subjectId,
      startedAt: startedAt,
      duration: duration,
      note: note,
    );
    repository.addSession(session);
    notifyListeners();
  }
}
