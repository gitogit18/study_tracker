import 'package:flutter/foundation.dart';
import '../repositories/study_repository.dart';

class StatsViewModel extends ChangeNotifier {
  StatsViewModel(this.repository);
  final StudyRepository repository;

  void load() {
    notifyListeners();
  }
}
