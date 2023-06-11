import 'package:flutter/material.dart';

class EcotourDetails {
  final String authorId;
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String description;
  final String meetupPoint;
  final List<String> organizers;
  final List<String> instructions;

  EcotourDetails({
    required this.authorId,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.meetupPoint,
    required this.organizers,
    required this.instructions,
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
      'author_id': authorId,
      'title': title,
      'date': date.toIso8601String(),
      'start_time': startDate.toIso8601String(),
      'end_time': endDate.toIso8601String(),
      'description': description,
      'meetup_point': meetupPoint,
      'organizers': organizers,
      'instructions': instructions,
    };
  }
}
