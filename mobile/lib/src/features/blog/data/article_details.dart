class ArticleDetails {
  final String authorId;
  final String title;
  final String content;
  final List<String> categories;

  ArticleDetails({
    required this.authorId,
    required this.title,
    required this.content,
    required this.categories,
  });

  Map<String, dynamic> toJson() {
    return {
      'author_id': authorId,
      'title': title,
      'content': content,
      'categories': categories,
    };
  }
}
