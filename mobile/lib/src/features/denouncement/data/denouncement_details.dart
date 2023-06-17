class DenouncementDetails {
  final String denouncerId;
  final String title;
  final String description;
  final DateTime initialDate;
  final DateTime finalDate;
  final List<MultimediaDetails> multimediaElements;

  DenouncementDetails({
    required this.denouncerId,
    required this.title,
    required this.description,
    required this.initialDate,
    required this.finalDate,
    required this.multimediaElements,
  });

  Map<String, dynamic> toJson() {
    return {
      'denouncer_id': denouncerId,
      'title': title,
      'description': description,
      'initial_date': initialDate.toIso8601String(),
      'final_date': finalDate.toIso8601String(),
      'multimedia_elements': multimediaElements
          .map(
            (multimediaElement) => multimediaElement.toJson(),
          )
          .toList(),
    };
  }
}

class MultimediaDetails {
  final String description;
  final String uri;

  MultimediaDetails({
    required this.description,
    required this.uri,
  });

  factory MultimediaDetails.fromJson(Map<String, dynamic> json) {
    return MultimediaDetails(
      description: json['description'],
      uri: json['uri'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'uri': uri,
    };
  }
}
