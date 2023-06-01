import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/catalog.dart';
import 'catalog_details.dart';

class CatalogService {
  final String baseUrl = 'http://localhost:8083'; // Reemplaza con la URL correcta de la API
  final Dio _dio = Dio();

  Future<String> createCatalogRecord(CatalogRecordDetails catalogRecordDetails) async {
    try {
      final response =
          await _dio.post('$baseUrl/catalog-records', data: catalogRecordDetails.toJson());
      return response.data['catalog_record_id'];
      // Handle response as needed
    } catch (e) {
      throw Exception('Failed to create catalog record. Error: $e');
    }
  }

  Future<CatalogRecord> getCatalogRecordByID(String id) async {
    try {
      final response = await _dio.get('$baseUrl/catalog-records/$id');
      return CatalogRecord.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get catalog record by id. Error: $e');
    }
  }

  Future<List<CatalogRecord>> getAllCatalogRecords() async {
    try {
      final response = await _dio.get('$baseUrl/catalog-records');
      return List<CatalogRecord>.from(
        response.data['records'].map(
          (record) => CatalogRecord.fromJson(record),
        ),
      );
    } catch (e) {
      throw Exception('Failed to get all catalog records. Error: $e');
    }
  }

  Future<void> updateCatalogRecord(CatalogRecord catalogRecord) async {
    try {
      final response = await _dio.put(
        '$baseUrl/catalog-records/${catalogRecord.id}',
        data: catalogRecord.toJson(),
      );
      // Handle response as needed
    } catch (e) {
      throw Exception('Failed to update catalog record. Error: $e');
    }
  }

  Future<void> deleteCatalogRecord(String id) async {
    try {
      final response = await _dio.delete('$baseUrl/catalog-records/$id');
      // Handle response as needed
    } catch (e) {
      throw Exception('Failed to delete catalog record. Error: $e');
    }
  }

  Future<void> addSpeciesImageToCatalogRecord(CatalogRecordImage image) async {
    try {
      final response = await _dio.patch(
        '$baseUrl/catalog-records/${image.catalogRecordId}/images',
        data: image.toJson(),
      );
      // Handle response as needed
    } catch (e) {
      throw Exception('Failed to add species image to catalog record. Error: $e');
    }
  }
}

final catalogServiceProvider = Provider<CatalogService>((ref) {
  return CatalogService();
});

final getAllCatalogRecordsProvider = FutureProvider<List<CatalogRecord>>((ref) {
  return ref.read(catalogServiceProvider).getAllCatalogRecords();
});
