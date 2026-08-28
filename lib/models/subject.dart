import 'package:flutter/material.dart';

enum SubjectIcon{
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
}