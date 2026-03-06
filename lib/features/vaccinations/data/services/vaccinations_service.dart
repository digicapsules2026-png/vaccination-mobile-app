import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/vaccination_model.dart';

class VaccinationsService {
  final ApiClient _apiClient;

  VaccinationsService(this._apiClient);

  /// Get all vaccinations
  Future<List<VaccinationModel>> getAllVaccinations({
    int? childId,
    int? beneficiaryId,
    String? status,
  }) async {
    final params = <String, dynamic>{};
    if (childId != null) params['child_id'] = childId;
    if (beneficiaryId != null) params['beneficiary_id'] = beneficiaryId;
    if (status != null) params['status'] = status;

    final response = await _apiClient.dio.get('/vaccinations', queryParameters: params);
    return (response.data as List)
        .map((json) => VaccinationModel.fromJson(json))
        .toList();
  }

  /// Get vaccination by ID
  Future<VaccinationModel> getVaccinationById(int id) async {
    final response = await _apiClient.dio.get('/vaccinations/$id');
    return VaccinationModel.fromJson(response.data);
  }

  /// Create vaccination record
  Future<VaccinationModel> createVaccination(Map<String, dynamic> data) async {
    final response = await _apiClient.dio.post('/vaccinations', data: data);
    return VaccinationModel.fromJson(response.data);
  }

  /// Update vaccination record
  Future<VaccinationModel> updateVaccination(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.dio.put('/vaccinations/$id', data: data);
    return VaccinationModel.fromJson(response.data);
  }

  /// Delete vaccination record
  Future<void> deleteVaccination(int id) async {
    await _apiClient.dio.delete('/vaccinations/$id');
  }
}


















