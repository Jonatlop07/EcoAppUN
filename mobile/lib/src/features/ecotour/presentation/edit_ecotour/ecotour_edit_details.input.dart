import 'package:flutter/material.dart';

class EcotourEditDetailsInput {
  final String id;
  final String authorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String description;
  final String meetupPoint;
  final List<String> organizers;

  EcotourEditDetailsInput({
    required this.id,
    required this.authorId,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.meetupPoint,
    required this.organizers,
  });

  Map<String, dynamic> toJson() {
    DateTime startDate = DateTime(
      date.year,
      date.month,
      date.day,
      startTime.hour,
      startTime.minute,
    );
    DateTime endDate = DateTime(
      date.year,
      date.month,
      date.day,
      endTime.hour,
      endTime.minute,
    );
    return {
      'id': id,
      'author_id': authorId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'title': title,
      'date': date.toIso8601String(),
      'start_time': startDate.toIso8601String(),
      'end_time': endDate.toIso8601String(),
      'description': description,
      'meetup_point': meetupPoint,
      'organizers': organizers,
    };
  }
}
