import 'package:flutter/material.dart';

enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final TaskPriority priority;
  final String? subjectId;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.subjectId,
  });

  Color get priorityColor {
    switch (priority) {
      case TaskPriority.high:
        return const Color(0xFFFF5C5C);
      case TaskPriority.medium:
        return const Color(0xFFFFB84D);
      case TaskPriority.low:
        return const Color(0xFF00D9A5);
    }
  }
}