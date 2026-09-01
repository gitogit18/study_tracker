import 'package:flutter/foundation.dart';
import '../repositories/study_repository.dart';
import '../models/subject.dart';

class SubjectViewModel extends ChangeNotifier {
  SubjectViewModel(this.repository);
  final StudyRepository repository;

  List<Subject> subjects = [];
  String _searchQuery = '';

  void load() {
    subjects = repository.subjects;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Subject> get filteredSubjects {
    if (_searchQuery.isEmpty) return subjects;
    return subjects
        .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void addSubject(Subject subject) {
    repository.addSubject(subject);
    load();
  }

  void updateSubject(Subject subject) {
    repository.updateSubject(subject);
    load();
  }

  void deleteSubject(String id) {
    repository.deleteSubject(id);
    load();
  }
}
