import '../common/image_edit_details.input.dart';

class CatalogRecordDetailsInput {
  final String commonName;
  final String scientificName;
  final String description;
  final List<String> locations;
  final List<ImageEditDetailsInput> images;

  CatalogRecordDetailsInput({
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.locations,
    required this.images,
  });
}
