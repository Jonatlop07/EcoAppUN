import 'package:mobile/src/features/denouncement/data/denouncement_details.dart';
import 'package:mobile/src/features/denouncement/presentation/common/multimedia_edit_details.input.dart';

class DenouncementDetailsInput {
  final String title;
  final String description;
  final List<MultimediaEditDetailsInput> multimediaElements;

  DenouncementDetailsInput({
    required this.title,
    required this.description,
    required this.multimediaElements,
  });
}
