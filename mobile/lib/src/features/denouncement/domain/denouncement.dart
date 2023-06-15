class Denouncement {
  final String id;
  final String denouncerId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime initialDate;
  final DateTime finalDate;
  final String description;
  final List<DenouncementMultimedia> multimediaElements;
  final List<Comment> comments;

  Denouncement({
    required this.id,
    required this.denouncerId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.initialDate,
    required this.finalDate,
    required this.description,
    required this.multimediaElements,
    required this.comments,
  });

  factory Denouncement.fromJson(Map<String, dynamic> json) {
    return Denouncement(
      id: json['id'],
      denouncerId: json['denouncer_id'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      initialDate: DateTime.parse(json['initial_date']),
      finalDate: DateTime.parse(json['final_date']),
      description: json['description'],
      multimediaElements: List<DenouncementMultimedia>.from(
        json['multimedia_elements'].map(
          (multimediaElement) => DenouncementMultimedia.fromJson(multimediaElement),
        ),
      ),
      comments: List<Comment>.from(json['comments'].map((comment) => Comment.fromJson(comment))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'denouncer_id': denouncerId,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'initial_date': initialDate.toIso8601String(),
      'final_date': finalDate.toIso8601String(),
      'description': description,
      'multimedia_elements': multimediaElements,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}

class Comment {
  final String id;
  final String denouncementId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final List<CommentReaction> reactions;
  final List<CommentResponse> responses;

  Comment({
    required this.id,
    required this.denouncementId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.reactions,
    required this.responses,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'],
        denouncementId: json['denouncement_id'],
        authorId: json['author_id'],
        content: json['content'],
        createdAt: DateTime.parse(json['created_at']),
        reactions: List<CommentReaction>.from(
            json['reactions'].map((reaction) => CommentReaction.fromJson(reaction))),
        responses: List<CommentResponse>.from(
            json['responses'].map((response) => CommentResponse.fromJson(response))));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'denouncement_id': denouncementId,
      'author_id': authorId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'reactions': reactions.map((reaction) => reaction.toJson()).toList(),
      'responses': responses.map((response) => response.toJson()).toList(),
    };
  }
}

class DenouncementMultimedia {
  final String description;
  final DateTime submittedAt;
  final String uri;

  DenouncementMultimedia({
    required this.description,
    required this.submittedAt,
    required this.uri,
  });

  factory DenouncementMultimedia.fromJson(Map<String, dynamic> json) {
    return DenouncementMultimedia(
      description: json['description'],
      submittedAt: DateTime.parse(json['submitted_at']),
      uri: json['uri'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'submitted_at': submittedAt.toIso8601String(),
      'uri': uri,
    };
  }
}

class CommentReaction {
  final String id;
  final String denouncementId;
  final String commentId;
  final String type;
  final String userId;
  final DateTime createdAt;

  CommentReaction({
    required this.id,
    required this.denouncementId,
    required this.commentId,
    required this.type,
    required this.userId,
    required this.createdAt,
  });

  factory CommentReaction.fromJson(Map<String, dynamic> json) {
    return CommentReaction(
      id: json['id'],
      denouncementId: json['denouncement_id'],
      commentId: json['comment_id'],
      type: json['type'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'denouncement_id': denouncementId,
      'comment_id': commentId,
      'type': type,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class CommentResponse {
  final String id;
  final String denouncementId;
  final String commentId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final List<ResponseReaction> reactions;

  CommentResponse(
      {required this.id,
      required this.denouncementId,
      required this.commentId,
      required this.authorId,
      required this.content,
      required this.createdAt,
      required this.reactions});

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      id: json['id'],
      denouncementId: json['denouncement_id'],
      commentId: json['comment_id'],
      authorId: json['author_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      reactions: List<ResponseReaction>.from(
        json['reactions'].map((reaction) => ResponseReaction.fromJson(reaction)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'denouncement_id': denouncementId,
      'comment_id': commentId,
      'author_id': authorId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'reactions': reactions.map((reaction) => reaction.toJson()).toList(),
    };
  }
}

class ResponseReaction {
  final String id;
  final String denouncementId;
  final String commentId;
  final String responseId;
  final String type;
  final String userId;
  final DateTime createdAt;

  ResponseReaction({
    required this.id,
    required this.denouncementId,
    required this.commentId,
    required this.responseId,
    required this.type,
    required this.userId,
    required this.createdAt,
  });

  factory ResponseReaction.fromJson(Map<String, dynamic> json) {
    return ResponseReaction(
      id: json['id'],
      denouncementId: json['denouncement_id'],
      commentId: json['comment_id'],
      responseId: json['response_id'],
      type: json['type'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'denouncement_id': denouncementId,
      'comment_id': commentId,
      'response_id': responseId,
      'type': type,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
