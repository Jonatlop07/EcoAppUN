import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/features/ecorecovery/presentation/common/ecorecovery_workshop_details.dart';
import 'package:mobile/src/features/ecorecovery/presentation/edit_ecorecovery_workshop/ecorecovery_workshop_edit_details.input.dart';
import '../domain/ecorecovery.dart';

class EcorecoveryService {
  static const String baseUrl = 'http://localhost:8083';
  final Dio dio = Dio();

  Future<String> createWorkshop(EcorecoveryWorkshopDetails workshopDetails) async {
    try {
      final response = await dio.post(
        '$baseUrl/ecorecovery-workshops',
        data: workshopDetails.toJson(),
      );
      return response.data['ecorecovery_workshop_id'];
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

  Future<String> updateWorkshop(EcorecoveryWorkshopEditDetailsInput ecorecoveryWorkshop) async {
    try {
      final response = await dio.patch(
        '$baseUrl/ecorecovery-workshops/${ecorecoveryWorkshop.id}',
        data: ecorecoveryWorkshop.toJson(),
      );
      return response.data['ecorecovery_workshop_id'];
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

final ecorecoveryServiceProvider = Provider<EcorecoveryService>((ref) {
  return EcorecoveryService();
});

final getAllEcorecoveryWorkshopsProvider = FutureProvider<List<EcorecoveryWorkshop>>((ref) {
  return ref.read(ecorecoveryServiceProvider).getAllWorkshops();
});
