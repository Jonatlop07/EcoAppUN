class CatalogRecordDetails {
  final String authorId;
  final String commonName;
  final String scientificName;
  final String description;
  final List<String> locations;
  final List<ImageDetails> images;

  CatalogRecordDetails({
    required this.authorId,
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.locations,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'author_id': authorId,
      'common_name': commonName,
      'scientific_name': scientificName,
      'description': description,
      'locations': locations,
      'images': images.map((image) => image.toJson()).toList(),
    };
  }
}

class ImageDetails {
  final String authorId;
  final String authorName;
  final String description;
  final String url;

  ImageDetails({
    required this.authorId,
    required this.authorName,
    required this.description,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'author_id': authorId,
      'author_name': authorName,
      'description': description,
      'url': url,
    };
  }
}
