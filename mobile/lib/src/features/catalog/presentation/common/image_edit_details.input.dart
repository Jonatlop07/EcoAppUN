class ImageEditDetailsInput {
  final String? id;
  final String? authorId;
  final String? authorName;
  String description;
  final DateTime? submittedAt;
  String url;

  ImageEditDetailsInput({
    this.id,
    this.authorId,
    this.authorName,
    required this.description,
    this.submittedAt,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'author_name': authorName,
      'description': description,
      'submitted_at': submittedAt!.toIso8601String(),
      'url': url,
    };
  }
}
