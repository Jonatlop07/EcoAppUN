import 'dart:convert';
import 'package:dio/dio.dart';
import '../domain/user.dart';

class UserService {
  final Dio _dio;
  final String _baseUrl;

  UserService()
      : _dio = Dio(),
        _baseUrl = 'https://your-api-url.com';

  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get('/users');
      return List<User>.from(
        (response.data as List<dynamic>).map((userJson) => User.fromJson(userJson)),
      );
    } catch (error) {
      throw Exception('Failed to fetch users: $error');
    }
  }

  Future<void> createUser(String username, String password) async {
    try {
      final data = {'username': username, 'password': password};
      final response = await _dio.post('/users', data: jsonEncode(data));
    } catch (error) {
      throw Exception('Failed to create user: $error');
    }
  }

  Future<User> getUserById(String id) async {
    try {
      final response = await _dio.get('/users/$id');
      return User.fromJson(response.data);
    } catch (error) {
      throw Exception('Failed to fetch user: $error');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      final response = await _dio.delete('/users/$id');
    } catch (error) {
      throw Exception('Failed to delete user: $error');
    }
  }
}
