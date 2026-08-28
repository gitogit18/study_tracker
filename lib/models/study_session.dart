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
    required this.note,
});
}