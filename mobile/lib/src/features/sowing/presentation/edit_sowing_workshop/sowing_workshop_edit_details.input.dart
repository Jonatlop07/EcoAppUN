import 'package:flutter/material.dart';

import '../../common/seed_edit_details.input.dart';
import '../../domain/sowing.dart';

class SowingWorkshopEditDetailsInput {
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
  final List<String> instructions;
  final List<Objective> objectives;
  final List<SeedEditDetailsInput> seeds;

  SowingWorkshopEditDetailsInput({
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
    required this.instructions,
    required this.objectives,
    required this.seeds,
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
      'instructions': instructions,
      'objectives': objectives.map((objective) => objective.toJson()).toList(),
      'seeds': seeds.map((seed) => seed.toJson()).toList(),
    };
  }
}
