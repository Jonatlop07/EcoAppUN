import 'package:flutter/material.dart';

class EcorecoveryWorkshop {
  final String id;
  final String authorId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String meetupPoint;
  final String description;
  final List<String> organizers;
  final List<String> attendees;
  final List<String> instructions;
  final List<Objective> objectives;

  EcorecoveryWorkshop({
    required this.id,
    required this.authorId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.meetupPoint,
    required this.description,
    required this.organizers,
    required this.attendees,
    required this.instructions,
    required this.objectives,
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
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'date': date.toIso8601String(),
      'start_time': startDate.toIso8601String(),
      'end_time': endDate.toIso8601String(),
      'meetup_point': meetupPoint,
      'description': description,
      'organizers': organizers,
      'attendees': attendees,
      'instructions': instructions,
      'objectives': objectives.map((objective) => objective.toJson()).toList(),
    };
  }

  factory EcorecoveryWorkshop.fromJson(Map<String, dynamic> json) {
    return EcorecoveryWorkshop(
      id: json['id'],
      authorId: json['author_id'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      date: DateTime.parse(json['date']),
      startTime: TimeOfDay.fromDateTime(DateTime.parse(json['start_time'])),
      endTime: TimeOfDay.fromDateTime(DateTime.parse(json['end_time'])),
      meetupPoint: json['meetup_point'],
      description: json['description'],
      organizers: List<String>.from(json['organizers']),
      attendees: List<String>.from(json['attendees']),
      instructions: List<String>.from(json['instructions']),
      objectives: List<Objective>.from(
        json['objectives'].map((objective) => Objective.fromJson(objective)),
      ),
    );
  }
}

class Objective {
  final String description;
  final bool isAchieved;

  Objective({
    required this.description,
    required this.isAchieved,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'is_achieved': isAchieved,
    };
  }

  factory Objective.fromJson(Map<String, dynamic> json) {
    return Objective(
      description: json['description'],
      isAchieved: json['is_achieved'],
    );
  }
}
