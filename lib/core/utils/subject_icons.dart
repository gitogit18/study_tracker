import 'package:flutter/material.dart';
import '../../models/subject.dart';

IconData getIconForSubject(SubjectIcon icon) {
  switch (icon) {
    case SubjectIcon.code:
      return Icons.code_rounded;
    case SubjectIcon.book:
      return Icons.menu_book_rounded;
    case SubjectIcon.math:
      return Icons.calculate_rounded;
    case SubjectIcon.chemistry:
      return Icons.science_rounded;
    case SubjectIcon.literature:
      return Icons.history_edu_rounded;
    case SubjectIcon.history:
      return Icons.auto_stories_rounded;
    case SubjectIcon.cooking:
      return Icons.restaurant_rounded;
    case SubjectIcon.target:
      return Icons.track_changes_rounded;
    case SubjectIcon.music:
      return Icons.music_note_rounded;
    case SubjectIcon.globe:
      return Icons.public_rounded;
    case SubjectIcon.chip:
      return Icons.memory_rounded;
    case SubjectIcon.star:
      return Icons.star_rounded;
    case SubjectIcon.link:
      return Icons.link_rounded;
  }
}
