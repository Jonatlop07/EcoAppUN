import 'package:dio/dio.dart';
import '../domain/denouncement.dart';

class DenouncementService {
  final String baseUrl = 'https://api.example.com'; // Reemplaza con la URL correcta de la API
  final Dio _dio = Dio();

  Future<List<Denouncement>> getDenouncements() async {
    try {
      final response = await _dio.get('$baseUrl/denouncements');
      return List<Denouncement>.from(
        (response.data as List).map((denouncement) => Denouncement.fromJson(denouncement)),
      );
    } catch (e) {
      throw Exception('Failed to get denouncements. Error: $e');
    }
  }

  Future<Denouncement> getDenouncementById(String id) async {
    try {
      final response = await _dio.get('$baseUrl/denouncements/$id');
      return Denouncement.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get denouncement by id. Error: $e');
    }
  }

  Future<Denouncement> createDenouncement(Denouncement denouncement) async {
    try {
      final response = await _dio.post('$baseUrl/denouncements', data: denouncement.toJson());
      return Denouncement.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create denouncement. Error: $e');
    }
  }

  Future<Denouncement> updateDenouncement(String id, Denouncement denouncement) async {
    try {
      final response = await _dio.put('$baseUrl/denouncements/$id', data: denouncement.toJson());
      return Denouncement.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update denouncement. Error: $e');
    }
  }

  Future<void> deleteDenouncement(String id) async {
    try {
      await _dio.delete('$baseUrl/denouncements/$id');
    } catch (e) {
      throw Exception('Failed to delete denouncement. Error: $e');
    }
  }

  Future<Comment> createComment(Comment comment) async {
    try {
      final response = await _dio.patch(
        '$baseUrl/denouncements/${comment.denouncementId}/comments',
        data: comment.toJson(),
      );
      return Comment.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create comment. Error: $e');
    }
  }

  Future<void> deleteComment(String denouncementId, String commentId) async {
    try {
      await _dio.delete('$baseUrl/denouncements/$denouncementId/comments/$commentId');
    } catch (e) {
      throw Exception('Failed to delete comment. Error: $e');
    }
  }

  Future<CommentResponse> createCommentResponse(CommentResponse commentResponse) async {
    try {
      final response = await _dio.patch(
          '$baseUrl/denouncements/${commentResponse.denouncementId}/comments/${commentResponse.commentId}/responses',
          data: commentResponse.toJson());
      return CommentResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create comment response. Error: $e');
    }
  }

  Future<void> deleteCommentResponse(
      String denouncementId, String commentId, String responseId) async {
    try {
      await _dio.delete(
        '$baseUrl/denouncements/$denouncementId/comments/$commentId/responses/$responseId',
      );
    } catch (e) {
      throw Exception('Failed to delete comment response. Error: $e');
    }
  }

  Future<void> createCommentReaction(CommentReaction reaction) async {
    try {
      await _dio.patch(
        '$baseUrl/denouncements/${reaction.denouncementId}/comments/${reaction.commentId}/reactions',
        data: reaction.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to create comment reaction. Error: $e');
    }
  }

  Future<void> deleteCommentReaction(String denouncementId, String commentId, String userId) async {
    try {
      await _dio.delete(
        '$baseUrl/denouncements/$denouncementId/comments/$commentId/reactions/$userId',
      );
    } catch (e) {
      throw Exception('Failed to delete comment reaction. Error: $e');
    }
  }

  Future<void> createCommentResponseReaction(ResponseReaction reaction) async {
    try {
      await _dio.patch(
        '$baseUrl/denouncements/${reaction.denouncementId}/comments/${reaction.commentId}/responses/${reaction.responseId}/reactions',
        data: reaction.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to create comment response reaction. Error: $e');
    }
  }

  Future<void> deleteCommentResponseReaction(
    String denouncementId,
    String commentId,
    String responseId,
    String userId,
  ) async {
    try {
      await _dio.delete(
        '$baseUrl/denouncements/$denouncementId/comments/$commentId/responses/$responseId/reactions/$userId',
      );
    } catch (e) {
      throw Exception('Failed to delete comment response reaction. Error: $e');
    }
  }
}
