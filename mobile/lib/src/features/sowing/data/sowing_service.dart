import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/features/sowing/data/sowing_workshop_details.dart';
import '../domain/sowing.dart';

class SowingService {
  final String baseUrl = 'https://api.example.com'; // Reemplaza con la URL correcta de la API
  final Dio _dio = Dio();

  Future<List<SowingWorkshop>> getSowingWorkshops() async {
    try {
      final response = await _dio.get('$baseUrl/sowing-workshops');
      final data = response.data as List<dynamic>;
      final workshops = data.map((json) => SowingWorkshop.fromJson(json)).toList();
      return workshops;
    } catch (e) {
      throw Exception('Failed to retrieve sowing workshops: $e');
    }
  }

  Future<SowingWorkshop> getSowingWorkshopById(String id) async {
    try {
      final response = await _dio.get('$baseUrl/sowing-workshops/$id');
      final data = response.data as Map<String, dynamic>;
      final workshop = SowingWorkshop.fromJson(data);
      return workshop;
    } catch (e) {
      throw Exception('Failed to retrieve sowing workshop with id $id: $e');
    }
  }

  Future<String> createSowingWorkshop(SowingWorkshopDetails workshop) async {
    try {
      final response = await _dio.post('$baseUrl/sowing-workshops', data: workshop.toJson());
      return response.data['sowing_workshop_id'];
    } catch (e) {
      throw Exception('Failed to create sowing workshop: $e');
    }
  }

  Future<void> updateSowingWorkshop(String id, SowingWorkshop workshop) async {
    try {
      final response = await _dio.put('$baseUrl/sowing-workshops/$id', data: workshop.toJson());
    } catch (e) {
      throw Exception('Failed to update sowing workshop with id $id: $e');
    }
  }

  Future<void> deleteSowingWorkshop(String id) async {
    try {
      final response = await _dio.delete('$baseUrl/sowing-workshops/$id');
    } catch (e) {
      throw Exception('Failed to delete sowing workshop with id $id: $e');
    }
  }

  Future<void> addAttendee(String workshopId, String userId) async {
    try {
      final response = await _dio.patch('$baseUrl/sowing-workshops/$workshopId/attendees/$userId');
    } catch (e) {
      throw Exception('Failed to add attendee to sowing workshop with id $workshopId: $e');
    }
  }

  Future<void> removeAttendee(String workshopId, String userId) async {
    try {
      final response = await _dio.delete('$baseUrl/sowing-workshops/$workshopId/attendees/$userId');
    } catch (e) {
      throw Exception('Failed to remove attendee from sowing workshop with id $workshopId: $e');
    }
  }

  Future<void> updateObjectives(String workshopId, List<String> objectives) async {
    try {
      final response = await _dio.put('$baseUrl/sowing-workshops/$workshopId/objectives',
          data: {'objectives': objectives});
    } catch (e) {
      throw Exception('Failed to update objectives for sowing workshop with id $workshopId: $e');
    }
  }
}

final sowingServiceProvider = Provider<SowingService>((ref) {
  return SowingService();
});
