import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final Color color;
  final IconData icon;
  final int totalChapters;
  final int completedChapters;

  Subject({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    this.totalChapters = 0,
    this.completedChapters = 0,
  });

  double get progress => totalChapters == 0 ? 0 : completedChapters / totalChapters;
}