import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeline_model.freezed.dart';
part 'timeline_model.g.dart';

@freezed
class TimelineItem with _$TimelineItem {
  const factory TimelineItem({
    required int vaccineId,
    @JsonKey(name: 'vaccine_name') required String vaccineName,
    @JsonKey(name: 'vaccine_code') String? vaccineCode,
    @JsonKey(name: 'dose_number') required int doseNumber,
    @JsonKey(name: 'dose_label') String? doseLabel,
    required String status, // 'COMPLETED', 'UPCOMING', 'DUE_NEXT'
    @JsonKey(name: 'due_date') required String dueDate,
    @JsonKey(name: 'date_range_start') String? dateRangeStart,
    @JsonKey(name: 'date_range_end') String? dateRangeEnd,
    @JsonKey(name: 'vaccination_date') String? vaccinationDate,
    @JsonKey(name: 'recommended_age') String? recommendedAge,
    @JsonKey(name: 'is_birth_dose') @Default(false) bool isBirthDose,
  }) = _TimelineItem;

  factory TimelineItem.fromJson(Map<String, dynamic> json) =>
      _$TimelineItemFromJson(json);
}

@freezed
class VaccinationTimelineResponse with _$VaccinationTimelineResponse {
  const factory VaccinationTimelineResponse({
    required int beneficiaryId,
    required List<TimelineItem> timeline,
    @JsonKey(name: 'upcoming_reminders') List<ReminderItem>? upcomingReminders,
  }) = _VaccinationTimelineResponse;

  factory VaccinationTimelineResponse.fromJson(Map<String, dynamic> json) =>
      _$VaccinationTimelineResponseFromJson(json);
}

@freezed
class ReminderItem with _$ReminderItem {
  const factory ReminderItem({
    required String vaccineName,
    @JsonKey(name: 'due_date') required String dueDate,
    @JsonKey(name: 'days_until') int? daysUntil,
  }) = _ReminderItem;

  factory ReminderItem.fromJson(Map<String, dynamic> json) =>
      _$ReminderItemFromJson(json);
}

