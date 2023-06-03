import '../common/image_edit_details.input.dart';

class CatalogRecordEditDetailsInput {
  final String id;
  final String authorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String commonName;
  final String scientificName;
  final String description;
  final List<String> locations;
  final List<ImageEditDetailsInput> images;

  CatalogRecordEditDetailsInput({
    required this.id,
    required this.authorId,
    required this.createdAt,
    required this.updatedAt,
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.locations,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'common_name': commonName,
      'scientific_name': scientificName,
      'description': description,
      'locations': locations,
      'images': images.map((image) => image.toJson()).toList(),
    };
  }
}
