import 'package:dio/dio.dart';
import '../domain/ecorecovery.dart';

class ErecoveryService {
  static const String baseUrl = 'https://api.example.com'; // Reemplaza con la URL de tu backend
  final Dio dio = Dio();

  Future<void> createWorkshop(Map<String, dynamic> workshop) async {
    try {
      final response = await dio.post('$baseUrl/ecorecovery-workshops', data: workshop);
    } catch (error) {
      throw Exception('Failed to create workshop: $error');
    }
  }

  Future<EcorecoveryWorkshop> getWorkshopById(String id) async {
    try {
      final response = await dio.get('$baseUrl/ecorecovery-workshops/$id');
      return EcorecoveryWorkshop.fromJson(response.data);
    } catch (error) {
      throw Exception('Failed to get workshop: $error');
    }
  }

  Future<List<EcorecoveryWorkshop>> getAllWorkshops() async {
    try {
      final response = await dio.get('$baseUrl/ecorecovery-workshops');
      return List<EcorecoveryWorkshop>.from(
        (response.data as List).map((workshop) => EcorecoveryWorkshop.fromJson(workshop)),
      );
    } catch (error) {
      throw Exception('Failed to get workshops: $error');
    }
  }

  Future<void> updateWorkshop(String id, Map<String, dynamic> workshop) async {
    try {
      final response = await dio.patch('$baseUrl/ecorecovery-workshops/$id', data: workshop);
    } catch (error) {
      throw Exception('Failed to update workshop: $error');
    }
  }

  Future<void> deleteWorkshop(String id) async {
    try {
      final response = await dio.delete('$baseUrl/ecorecovery-workshops/$id');
    } catch (error) {
      throw Exception('Failed to delete workshop: $error');
    }
  }

  Future<void> addAttendee(String workshopId, String attendeeId) async {
    try {
      final response =
          await dio.patch('$baseUrl/ecorecovery-workshops/$workshopId/attendees/$attendeeId');
    } catch (error) {
      throw Exception('Failed to add attendee: $error');
    }
  }

  Future<void> removeAttendee(String workshopId, String attendeeId) async {
    try {
      final response =
          await dio.delete('$baseUrl/ecorecovery-workshops/$workshopId/attendees/$attendeeId');
    } catch (error) {
      throw Exception('Failed to remove attendee: $error');
    }
  }

  Future<void> updateObjectives(String workshopId, List<Objective> objectives) async {
    try {
      final response = await dio.patch(
        '$baseUrl/ecorecovery-workshops/$workshopId/objectives/',
        data: objectives,
      );
    } catch (error) {
      throw Exception('Failed to update objectives: $error');
    }
  }
}
