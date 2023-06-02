class CatalogRecord {
  final String id;
  final String authorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String commonName;
  final String scientificName;
  final String description;
  final List<String> locations;
  final List<CatalogRecordImage> images;

  CatalogRecord({
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

  factory CatalogRecord.fromJson(Map<String, dynamic> json) {
    return CatalogRecord(
      id: json['id'],
      authorId: json['author_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      commonName: json['common_name'],
      scientificName: json['scientific_name'],
      description: json['description'],
      locations: List<String>.from(json['locations']),
      images: List<CatalogRecordImage>.from(
          json['images'].map((image) => CatalogRecordImage.fromJson(image))),
    );
  }

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

class CatalogRecordImage {
  final String id;
  final String authorId;
  final String authorName;
  final String description;
  final DateTime submittedAt;
  final String url;

  CatalogRecordImage({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.description,
    required this.submittedAt,
    required this.url,
  });

  factory CatalogRecordImage.fromJson(Map<String, dynamic> json) {
    return CatalogRecordImage(
      id: json['id'],
      authorId: json['author_id'],
      authorName: json['author_name'],
      description: json['description'],
      submittedAt: DateTime.parse(json['submitted_at']),
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'author_name': authorName,
      'description': description,
      'submitted_at': submittedAt.toIso8601String(),
      'url': url,
    };
  }
}
