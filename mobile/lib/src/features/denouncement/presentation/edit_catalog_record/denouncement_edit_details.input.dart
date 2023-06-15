import '../common/multimedia_edit_details.input.dart';

class DenouncementEditDetailsInput {
  final String id;
  final String denouncerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String description;
  final List<MultimediaEditDetailsInput> multimediaElements;

  DenouncementEditDetailsInput({
    required this.id,
    required this.denouncerId,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.multimediaElements,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': denouncerId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'title': title,
      'description': description,
      'multimedia_elements':
          multimediaElements.map((multimediaElement) => multimediaElement.toJson()).toList(),
    };
  }
}
