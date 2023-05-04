class BlogFilter {
  String id;
  List<String> categories;
  DateTime createdAt;
  String title;

  BlogFilter({
    required this.id,
    required this.categories,
    required this.createdAt,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'categories': categories,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
