import 'package:mobile/src/features/denouncement/presentation/common/multimedia_edit_details.input.dart';

class DenouncementDetailsInput {
  final String title;
  final String description;
  final DateTime initialDate;
  final DateTime finalDate;
  final List<MultimediaEditDetailsInput> multimediaElements;

  DenouncementDetailsInput({
    required this.title,
    required this.description,
    required this.initialDate,
    required this.finalDate,
    required this.multimediaElements,
  });
}
