import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../core/utils/subject_icons.dart';

class SubjectIconTile extends StatelessWidget {
  const SubjectIconTile({
    super.key,
    required this.subject,
    this.size = 48,
  });

  final Subject subject;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: subject.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(size * 0.4),
      ),
      child: Center(
        child: Icon(
          getIconForSubject(subject.icon),
          color: subject.color,
          size: size * 0.5,
        ),
      ),
    );
  }
}
