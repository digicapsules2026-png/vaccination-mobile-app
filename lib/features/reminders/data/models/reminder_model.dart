import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_model.freezed.dart';
part 'reminder_model.g.dart';

@freezed
class VaccinationReminder with _$VaccinationReminder {
  const factory VaccinationReminder({
    required int id,
    @JsonKey(name: 'beneficiary_id') required int beneficiaryId,
    @JsonKey(name: 'vaccine_id') required int vaccineId,
    @JsonKey(name: 'vaccine_name') required String vaccineName,
    @JsonKey(name: 'dose_number') required int doseNumber,
    @JsonKey(name: 'scheduled_date') required DateTime scheduledDate,
    @JsonKey(name: 'vaccination_due_date') required DateTime vaccinationDueDate,
    @JsonKey(name: 'reminder_type') required String reminderType,
    required String status, // 'scheduled', 'sent', 'cancelled'
    required String title,
    required String message,
    required List<String> channels,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _VaccinationReminder;

  factory VaccinationReminder.fromJson(Map<String, dynamic> json) =>
      _$VaccinationReminderFromJson(json);
}

@freezed
class NotificationPreference with _$NotificationPreference {
  const factory NotificationPreference({
    required int id,
    @JsonKey(name: 'beneficiary_id') required int beneficiaryId,
    @JsonKey(name: 'vaccine_id') required int vaccineId,
    @Default(true) bool enabled,
    @JsonKey(name: 'preferred_channels') List<String>? preferredChannels,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _NotificationPreference;

  factory NotificationPreference.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferenceFromJson(json);
}
















