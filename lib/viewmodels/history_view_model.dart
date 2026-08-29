import 'package:flutter/foundation.dart';
import '../repositories/study_repository.dart';
import '../models/study_session.dart';

class HistoryViewModel extends ChangeNotifier {
  HistoryViewModel(this.repository);
  final StudyRepository repository;

  List<StudySession> sessions = [];

  void load() {
    sessions = repository.sessions;
    notifyListeners();
  }
}
