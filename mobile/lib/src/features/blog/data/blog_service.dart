import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/features/blog/data/article_details.dart';
import 'package:mobile/src/features/blog/data/blog_filter.dart';

import '../domain/blog.dart';
import '../presentation/edit_article/article_edit_details.input.dart';

class BlogService {
  final Dio _dio;
  final String _baseUrl = 'http://localhost:8083';

  BlogService() : _dio = Dio();

  Future<String> createArticle(ArticleDetails articleDetails) async {
    try {
      final response = await _dio.post('$_baseUrl/articles', data: articleDetails.toJson());
      return response.data['article_id'];
    } catch (e) {
      throw Exception('Failed to create article. Error: $e');
    }
  }

  Future<Article> getArticleById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/articles/$id');
      final article = Article.fromJson(response.data);
      return article;
    } catch (e) {
      // Handle error
      throw Exception('Failed to get article by id. Error: $e');
    }
  }

  Future<List<Article>> getAllArticles(BlogFilter? filter) async {
    try {
      final params = filter != null ? filter.toJson() : <String, dynamic>{};
      final response = await _dio.get('$_baseUrl/articles', queryParameters: params);
      return List<Article>.from(
        response.data['articles'].map(
          (article) => Article.fromJson(article),
        ),
      );
    } catch (e) {
      throw Exception('Failed to get articles by filter. Error: $e');
    }
  }

  Future<String> updateArticle(ArticleEditDetailsInput article) async {
    try {
      final response = await _dio.put('$_baseUrl/articles/${article.id}', data: article.toJson());
      return response.data['article_id'];
      // Handle response as needed
    } catch (e) {
      throw Exception('Failed to update article. Error: $e');
    }
  }

  Future<void> deleteArticle(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/articles/$id');
      // Handle response as needed
    } catch (e) {
      throw Exception('Failed to delete article. Error: $e');
    }
  }

  Future<void> addReactionToArticle(ArticleReaction reaction) async {
    try {
      final response = await _dio.patch(
        '$_baseUrl/articles/${reaction.articleId}/reactions',
        data: reaction.toJson(),
      );
      // Handle response as needed
    } catch (e) {
      throw Exception('Failed to add reaction to article. Error: $e');
    }
  }

  Future<void> removeReactionFromArticle(String id, String userId) async {
    try {
      final response = await _dio.delete('$_baseUrl/articles/$id/reactions/$userId');
      // Handle response as needed
    } catch (e) {
      throw Exception('Failed to remove reaction from article. Error: $e');
    }
  }

  Future<void> createArticleComment(Comment comment) async {
    try {
      final response = await _dio.patch(
        '$_baseUrl/articles/${comment.articleId}/comments',
        data: comment.toJson(),
      );
      // Handle response as needed
    } catch (e) {
      throw Exception('Failed to create a comment in the article. Error: $e');
    }
  }

  Future<void> deleteArticleComment(String id, String commentId) async {
    try {
      final response = await _dio.delete('$_baseUrl/articles/$id/comments/$commentId');
      // Handle response as needed
    } catch (e) {
      throw Exception('Failed to delete a comment in the article. Error: $e');
    }
  }

  Future<void> addReactionToComment(CommentReaction reaction) async {
    try {
      final response = await _dio.patch(
        '$_baseUrl/articles/${reaction.articleId}/comments/${reaction.commentId}/reactions',
        data: reaction.toJson(),
      );
      // Handle response as needed
    } catch (e) {
      throw Exception('Failed to add reaction to the comment. Error: $e');
    }
  }

  Future<void> removeReactionFromComment(String id, String commentId, String userId) async {
    try {
      final response =
          await _dio.delete('$_baseUrl/articles/$id/comments/$commentId/reactions/$userId');
      // Handle response as needed
    } catch (e) {
      throw Exception('Failed to remove reaction from the comment. Error: $e');
    }
  }
}

final blogServiceProvider = Provider<BlogService>((ref) {
  return BlogService();
});

final getAllArticlesProvider = FutureProvider<List<Article>>((ref) {
  return ref.read(blogServiceProvider).getAllArticles(null);
});
