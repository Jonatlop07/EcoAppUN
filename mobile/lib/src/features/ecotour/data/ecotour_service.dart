import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/features/ecotour/presentation/common/ecotour_details.dart';
import 'package:mobile/src/features/ecotour/presentation/edit_ecotour/ecotour_edit_details.input.dart';

import '../domain/ecotour.dart';

class EcotourService {
  static const String _baseUrl = 'http://localhost:8083';
  final Dio _dio = Dio();

  Future<String> createEcotour(EcotourDetails ecotourDetails) async {
    try {
      final response = await _dio.post('$_baseUrl/ecotours', data: ecotourDetails.toJson());
      return response.data['ecotour_id'];
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

  Future<String> updateEcotour(EcotourEditDetailsInput ecotourEditDetailsInput) async {
    try {
      final response = await _dio.patch(
        '$_baseUrl/ecotours/${ecotourEditDetailsInput.id}',
        data: ecotourEditDetailsInput.toJson(),
      );
      return response.data['ecotour_id'];
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

final ecotourServiceProvider = Provider<EcotourService>((ref) {
  return EcotourService();
});

final getAllEcotoursProvider = FutureProvider<List<Ecotour>>((ref) {
  return ref.read(ecotourServiceProvider).getAllEcotours();
});
