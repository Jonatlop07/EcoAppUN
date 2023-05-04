import 'package:dio/dio.dart';

import '../domain/ecotour.dart';

class EcotourService {
  final String _baseUrl = 'https://api.example.com'; // Reemplaza con la URL correcta de la API
  final Dio _dio = Dio();

  Future<void> createEcotour(Ecotour ecotour) async {
    try {
      final response = await _dio.post('$_baseUrl/ecotours', data: ecotour.toJson());
    } catch (e) {
      throw Exception('Failed to create ecotour. Error: $e');
    }
  }

  Future<Ecotour> getEcotourById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/ecotours/$id');
      return Ecotour.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get ecotour by ID. Error: $e');
    }
  }

  Future<List<Ecotour>> getAllEcotours() async {
    try {
      final response = await _dio.get('$_baseUrl/ecotours');
      return List<Ecotour>.from((response.data as List).map((e) => Ecotour.fromJson(e)));
    } catch (e) {
      throw Exception('Failed to get all ecotours. Error: $e');
    }
  }

  Future<void> updateEcotour(Ecotour ecotour) async {
    try {
      await _dio.patch('$_baseUrl/ecotours/${ecotour.id}', data: ecotour.toJson());
    } catch (e) {
      throw Exception('Failed to update ecotour. Error: $e');
    }
  }

  Future<void> deleteEcotour(String id) async {
    try {
      await _dio.delete('$_baseUrl/ecoturs/$id');
    } catch (e) {
      throw Exception('Failed to delete ecotour. Error: $e');
    }
  }

  Future<void> addAttendee(String ecotourId, String attendeeId) async {
    try {
      await _dio.patch('$_baseUrl/ecotours/$ecotourId/attendees/$attendeeId');
    } catch (e) {
      throw Exception('Failed to add attendee to ecotour. Error: $e');
    }
  }

  Future<void> removeAttendee(String ecotourId, String attendeeId) async {
    try {
      await _dio.delete('$_baseUrl/ecotours/$ecotourId/attendees/$attendeeId');
    } catch (e) {
      throw Exception('Failed to remove attendee from ecotour. Error: $e');
    }
  }
}
