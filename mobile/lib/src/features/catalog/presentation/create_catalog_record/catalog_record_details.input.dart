class CatalogRecordDetailsInput {
  final String commonName;
  final String scientificName;
  final String description;
  final List<String> locations;
  final List<ImageDetailsInput> images;

  CatalogRecordDetailsInput({
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.locations,
    required this.images,
  });
}

class ImageDetailsInput {
  final String description;
  final String url;

  ImageDetailsInput({
    required this.description,
    required this.url,
  });
}
