class Article {
  final String id;
  final String authorId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String content;
  final List<String> categories;
  final List<ArticleReaction> reactions;
  final List<Comment> comments;

  Article({
    required this.id,
    required this.authorId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.content,
    required this.categories,
    required this.reactions,
    required this.comments,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      authorId: json['author_id'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      content: json['content'],
      categories: List<String>.from(json['categories']),
      reactions: List<ArticleReaction>.from(
        json['reactions'].map((reaction) => ArticleReaction.fromJson(reaction)),
      ),
      comments: List<Comment>.from(
        json['comments'].map((comment) => Comment.fromJson(comment)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'content': content,
      'categories': categories,
      'reactions': reactions.map((reaction) => reaction.toJson()).toList(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}

class ArticleReaction {
  final String id;
  final String articleId;
  final String userId;
  final String type;
  final DateTime createdAt;

  ArticleReaction({
    required this.id,
    required this.articleId,
    required this.userId,
    required this.type,
    required this.createdAt,
  });

  factory ArticleReaction.fromJson(Map<String, dynamic> json) {
    return ArticleReaction(
      id: json['id'],
      articleId: json['article_id'],
      userId: json['user_id'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'article_id': articleId,
      'user_id': userId,
      'type': type,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Comment {
  final String id;
  final String articleId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final List<CommentReaction> reactions;

  Comment({
    required this.id,
    required this.articleId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.reactions,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      articleId: json['article_id'],
      authorId: json['author_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      reactions: List<CommentReaction>.from(
        json['reactions'].map((reaction) => CommentReaction.fromJson(reaction)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'article_id': articleId,
      'author_id': authorId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'reactions': reactions.map((reaction) => reaction.toJson()).toList(),
    };
  }
}

class CommentReaction {
  final String id;
  final String articleId;
  final String commentId;
  final String userId;
  final String type;
  final DateTime createdAt;

  CommentReaction({
    required this.id,
    required this.articleId,
    required this.commentId,
    required this.userId,
    required this.type,
    required this.createdAt,
  });

  factory CommentReaction.fromJson(Map<String, dynamic> json) {
    return CommentReaction(
      id: json['id'],
      articleId: json['article_id'],
      commentId: json['comment_id'],
      userId: json['user_id'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'article_id': articleId,
      'comment_id': commentId,
      'user_id': userId,
      'type': type,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
