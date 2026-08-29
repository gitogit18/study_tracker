import 'package:flutter/foundation.dart';
import '../repositories/study_repository.dart';

class SessionViewModel extends ChangeNotifier {
  SessionViewModel(this.repository);
  final StudyRepository repository;
}
