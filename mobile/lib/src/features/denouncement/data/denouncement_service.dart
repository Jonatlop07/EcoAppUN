import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/features/denouncement/data/denouncement_details.dart';
import 'package:mobile/src/features/denouncement/presentation/edit_catalog_record/denouncement_edit_details.input.dart';
import '../domain/denouncement.dart';

class DenouncementService {
  final String baseUrl = 'http://localhost:8083'; // Reemplaza con la URL correcta de la API
  final Dio _dio = Dio();

  Future<List<Denouncement>> getDenouncements() async {
    try {
      final response = await _dio.get('$baseUrl/denouncements');
      return List<Denouncement>.from(
        response.data['denouncements'].map(
          (denouncement) => Denouncement.fromJson(denouncement),
        ),
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

  Future<String> createDenouncement(DenouncementDetails denouncement) async {
    try {
      final response = await _dio.post('$baseUrl/denouncements', data: denouncement.toJson());
      return response.data['denouncement_id'];
    } catch (e) {
      throw Exception('Failed to create denouncement. Error: $e');
    }
  }

  Future<String> updateDenouncement(DenouncementEditDetailsInput denouncement) async {
    try {
      final response = await _dio.put(
        '$baseUrl/denouncements/${denouncement.id}',
        data: denouncement.toJson(),
      );
      return response.data['denouncement_id'].toString();
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

final denouncementServiceProvider = Provider<DenouncementService>((ref) {
  return DenouncementService();
});

final getAllDenouncementsProvider = FutureProvider<List<Denouncement>>((ref) {
  return ref.read(denouncementServiceProvider).getDenouncements();
});
