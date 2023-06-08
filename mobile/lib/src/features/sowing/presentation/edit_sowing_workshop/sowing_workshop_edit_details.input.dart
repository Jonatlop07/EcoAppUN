import '../../common/seed_edit_details.input.dart';
import '../../domain/sowing.dart';

class SowingWorkshopEditDetailsInput {
  final String id;
  final String authorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
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
    return {
      'id': id,
      'author_id': authorId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'title': title,
      'start_time': startTime,
      'end_time': endTime,
      'description': description,
      'meetup_point': meetupPoint,
      'organizers': organizers,
      'instructions': instructions,
      'objectives': objectives.map((objective) => objective.toJson()).toList(),
      'seeds': seeds.map((seed) => seed.toJson()).toList(),
    };
  }
}
