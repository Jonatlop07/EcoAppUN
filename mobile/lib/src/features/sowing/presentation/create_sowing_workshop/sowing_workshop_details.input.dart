import 'package:flutter/material.dart';

import '../../common/seed_edit_details.input.dart';

class SowingWorkshopDetailsInput {
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String description;
  final String meetupPoint;
  final List<String> organizers;
  final List<String> instructions;
  final List<String> objectives;
  final List<SeedEditDetailsInput> seeds;

  SowingWorkshopDetailsInput({
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
}
