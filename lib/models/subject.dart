import 'package:flutter/material.dart';

enum SubjectIcon {
  code,
  book,
  math,
  chemistry,
  literature,
  history,
  cooking,
  target,
  music,
  globe,
  chip,
  star,
  link,
}

class Subject {
  final String id;
  String name;
  SubjectIcon icon;
  Color color;

  Subject({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'icon': icon.name,
      'color': color.value,
    };
  }

  factory Subject.fromFirestore(String id, Map<String, dynamic> data) {
    return Subject(
      id: id,
      name: data['name'] ?? '',
      icon: SubjectIcon.values.byName(data['icon'] ?? 'code'),
      color: Color(data['color'] ?? 0xFF4D8073),
    );
  }
}
