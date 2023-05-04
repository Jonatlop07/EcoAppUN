import 'package:dio/dio.dart';
import '../domain/catalog.dart';

class CatalogService {
  final String baseUrl = 'https://api.example.com'; // Reemplaza con la URL correcta de la API
  final Dio _dio = Dio();

  Future<void> createCatalogRecord(CatalogRecord catalogRecord) async {
    try {
      final response = await _dio.post('$baseUrl/catalog-records', data: catalogRecord.toJson());
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
        (response.data as List).map((json) => CatalogRecord.fromJson(json)),
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

  Future<void> addSpeciesImageToCatalogRecord(Image image) async {
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
