import 'package:flutter/material.dart';

class EcotourDetailsInput {
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String description;
  final String meetupPoint;
  final List<String> organizers;
  final List<String> instructions;

  EcotourDetailsInput({
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.meetupPoint,
    required this.organizers,
    required this.instructions,
  });
}
