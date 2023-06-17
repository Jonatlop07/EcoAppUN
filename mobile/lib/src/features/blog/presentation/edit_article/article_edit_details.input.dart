class ArticleEditDetailsInput {
  final String id;
  final String authorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String content;
  final List<String> categories;

  ArticleEditDetailsInput({
    required this.id,
    required this.authorId,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.content,
    required this.categories,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'title': title,
      'content': content,
      'categories': categories,
    };
  }
}
