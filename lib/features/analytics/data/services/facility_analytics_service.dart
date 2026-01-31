import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/facility_analytics_model.dart';

class FacilityAnalyticsService {
  final ApiClient _apiClient;

  FacilityAnalyticsService(this._apiClient);

  /// Get facility analytics
  Future<FacilityAnalyticsModel> getFacilityAnalytics(int facilityId) async {
    final response = await _apiClient.dio.get('/analytics/facility/$facilityId');
    return FacilityAnalyticsModel.fromJson(response.data);
  }

  /// Get daily trends for a facility
  Future<List<DailyTrendItem>> getDailyTrends(
    int facilityId, {
    String? startDate,
    String? endDate,
  }) async {
    final params = <String, dynamic>{};
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;

    final response = await _apiClient.dio.get(
      '/analytics/facility/$facilityId/daily',
      queryParameters: params,
    );
    return (response.data['trends'] as List)
        .map((json) => DailyTrendItem.fromJson(json))
        .toList();
  }

  /// Get vaccine distribution for a facility
  Future<List<VaccineDistributionItem>> getVaccineDistribution(
    int facilityId, {
    String? startDate,
    String? endDate,
  }) async {
    final params = <String, dynamic>{};
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;

    final response = await _apiClient.dio.get(
      '/analytics/facility/$facilityId/vaccine-distribution',
      queryParameters: params,
    );
    return (response.data['distribution'] as List)
        .map((json) => VaccineDistributionItem.fromJson(json))
        .toList();
  }
}

