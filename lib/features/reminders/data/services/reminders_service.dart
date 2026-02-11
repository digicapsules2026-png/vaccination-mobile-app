import '../../../core/network/api_client.dart';
import '../models/reminder_model.dart';

class RemindersService {
  final ApiClient _apiClient;

  RemindersService(this._apiClient);

  /// Schedule reminders for a beneficiary
  Future<List<VaccinationReminder>> scheduleReminders(
    int beneficiaryId, {
    bool forceReschedule = false,
  }) async {
    final response = await _apiClient.dio.post(
      '/reminders/beneficiaries/$beneficiaryId/schedule',
      queryParameters: {'force_reschedule': forceReschedule},
    );
    return (response.data as List)
        .map((json) => VaccinationReminder.fromJson(json))
        .toList();
  }

  /// Get upcoming reminders
  Future<List<VaccinationReminder>> getUpcomingReminders(
    int beneficiaryId, {
    int daysInAdvance = 30,
  }) async {
    final response = await _apiClient.dio.get(
      '/reminders/beneficiaries/$beneficiaryId/upcoming',
      queryParameters: {'days_in_advance': daysInAdvance},
    );
    return (response.data as List)
        .map((json) => VaccinationReminder.fromJson(json))
        .toList();
  }

  /// Get next reminder
  Future<VaccinationReminder?> getNextReminder(int beneficiaryId) async {
    final response = await _apiClient.dio.get(
      '/reminders/beneficiaries/$beneficiaryId/next',
    );
    if (response.data == null) return null;
    return VaccinationReminder.fromJson(response.data);
  }

  /// Update notification preference
  Future<NotificationPreference> updateNotificationPreference(
    int beneficiaryId,
    int vaccineId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.dio.put(
      '/reminders/preferences/beneficiaries/$beneficiaryId/vaccines/$vaccineId',
      data: data,
    );
    return NotificationPreference.fromJson(response.data);
  }

  /// Get notification preference
  Future<NotificationPreference?> getNotificationPreference(
    int beneficiaryId,
    int vaccineId,
  ) async {
    final response = await _apiClient.dio.get(
      '/reminders/preferences/beneficiaries/$beneficiaryId/vaccines/$vaccineId',
    );
    if (response.data == null) return null;
    return NotificationPreference.fromJson(response.data);
  }
}












