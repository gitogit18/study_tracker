import 'package:cloud_firestore/cloud_firestore.dart';

class StudySession {
  final String id;
  final String subjectId;
  final DateTime startedAt;
  final Duration duration;
  final String? note;

  StudySession({
    required this.id,
    required this.subjectId,
    required this.startedAt,
    required this.duration,
    this.note,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'subjectId': subjectId,
      'startedAt': Timestamp.fromDate(startedAt),
      'duration': duration.inSeconds,
      'note': note,
    };
  }

  factory StudySession.fromFirestore(String id, Map<String, dynamic> data) {
    return StudySession(
      id: id,
      subjectId: data['subjectId'] ?? '',
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      duration: Duration(seconds: data['duration'] ?? 0),
      note: data['note'],
    );
  }
}
