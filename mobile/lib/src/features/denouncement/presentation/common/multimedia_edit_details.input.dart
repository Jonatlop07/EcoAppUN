class MultimediaEditDetailsInput {
  final DateTime? submittedAt;
  String description;
  String uri;

  MultimediaEditDetailsInput({
    this.submittedAt,
    required this.description,
    required this.uri,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'submitted_at': submittedAt!.toIso8601String(),
      'uri': uri,
    };
  }
}
