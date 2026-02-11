import '../../../core/network/api_client.dart';
import '../models/vaccine_model.dart';

class VaccinesService {
  final ApiClient _apiClient;

  VaccinesService(this._apiClient);

  /// Get all vaccines
  Future<List<VaccineModel>> getVaccines() async {
    final response = await _apiClient.dio.get('/vaccines');
    return (response.data as List)
        .map((json) => VaccineModel.fromJson(json))
        .toList();
  }

  /// Get vaccine by ID
  Future<VaccineModel> getVaccineById(int id) async {
    final response = await _apiClient.dio.get('/vaccines/$id');
    return VaccineModel.fromJson(response.data);
  }
}












