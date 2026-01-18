import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/document_model.dart';

class DocumentsService {
  final ApiClient _apiClient;

  DocumentsService(this._apiClient);

  /// Get all documents for a child
  Future<List<DocumentModel>> getChildDocuments(int childId) async {
    final response = await _apiClient.dio.get('/documents/child/$childId');
    return (response.data as List)
        .map((json) => DocumentModel.fromJson(json))
        .toList();
  }

  /// Get document by ID
  Future<DocumentModel> getDocumentById(int id) async {
    final response = await _apiClient.dio.get('/documents/$id');
    return DocumentModel.fromJson(response.data);
  }

  /// Upload document
  Future<DocumentModel> uploadDocument({
    required int childId,
    required String documentType,
    required String title,
    required String filePath,
    String? description,
  }) async {
    final formData = FormData.fromMap({
      'child_id': childId,
      'document_type': documentType,
      'title': title,
      if (description != null) 'description': description,
      'file': await MultipartFile.fromFile(filePath),
    });

    final response = await _apiClient.dio.post('/documents/upload', data: formData);
    return DocumentModel.fromJson(response.data);
  }

  /// Get download URL for document
  Future<Map<String, dynamic>> getDownloadUrl(int documentId) async {
    final response = await _apiClient.dio.get('/documents/$documentId/download');
    return response.data;
  }

  /// Delete document
  Future<void> deleteDocument(int id) async {
    await _apiClient.dio.delete('/documents/$id');
  }
}

