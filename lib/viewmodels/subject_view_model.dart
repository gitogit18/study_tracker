import 'package:flutter/foundation.dart';
import '../repositories/study_repository.dart';
import '../models/subject.dart';

class SubjectViewModel extends ChangeNotifier {
  SubjectViewModel(this.repository);
  final StudyRepository repository;

  List<Subject> subjects = [];

  void load() {
    subjects = repository.subjects;
    notifyListeners();
  }
}
