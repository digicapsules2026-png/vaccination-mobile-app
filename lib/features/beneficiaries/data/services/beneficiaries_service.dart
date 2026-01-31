import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/beneficiary_model.dart';
import '../models/timeline_model.dart';

class BeneficiariesService {
  final ApiClient _apiClient;

  BeneficiariesService(this._apiClient);

  /// Get parent profile with vaccinations
  Future<ParentProfile> getParentProfile() async {
    final response = await _apiClient.dio.get('/beneficiaries/parent/profile');
    return ParentProfile.fromJson(response.data);
  }

  /// Get all beneficiaries for current user
  Future<List<BeneficiaryModel>> getBeneficiaries({String? type}) async {
    final params = type != null ? {'type': type} : null;
    final response = await _apiClient.dio.get('/beneficiaries', queryParameters: params);
    return (response.data as List)
        .map((json) => BeneficiaryModel.fromJson(json))
        .toList();
  }

  /// Get all child beneficiaries
  Future<List<BeneficiaryModel>> getChildren() async {
    final response = await _apiClient.dio.get('/beneficiaries/children');
    return (response.data as List)
        .map((json) => BeneficiaryModel.fromJson(json))
        .toList();
  }

  /// Get beneficiary by ID
  Future<BeneficiaryModel> getBeneficiaryById(int id) async {
    final response = await _apiClient.dio.get('/beneficiaries/$id');
    return BeneficiaryModel.fromJson(response.data);
  }

  /// Update beneficiary
  Future<BeneficiaryModel> updateBeneficiary(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.dio.put('/beneficiaries/$id', data: data);
    return BeneficiaryModel.fromJson(response.data);
  }

  /// Get vaccination timeline for beneficiary
  Future<VaccinationTimelineResponse> getVaccinationTimeline(int beneficiaryId) async {
    final response = await _apiClient.dio.get('/beneficiaries/$beneficiaryId/vaccination-timeline');
    return VaccinationTimelineResponse.fromJson(response.data);
  }
}

// Helper class for parent profile response
class ParentProfile {
  final BeneficiaryModel beneficiary;
  final List<dynamic> vaccinations;

  ParentProfile({required this.beneficiary, required this.vaccinations});

  factory ParentProfile.fromJson(Map<String, dynamic> json) {
    return ParentProfile(
      beneficiary: BeneficiaryModel.fromJson(json['beneficiary']),
      vaccinations: json['vaccinations'] as List<dynamic>,
    );
  }
}







