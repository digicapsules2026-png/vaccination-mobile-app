import 'package:freezed_annotation/freezed_annotation.dart';

part 'vaccination_model.freezed.dart';
part 'vaccination_model.g.dart';

@freezed
class VaccinationModel with _$VaccinationModel {
  const factory VaccinationModel({
    required int id,
    @JsonKey(name: 'child_id') int? childId,
    @JsonKey(name: 'beneficiary_id') int? beneficiaryId,
    @JsonKey(name: 'vaccine_id') required int vaccineId,
    @JsonKey(name: 'vaccine_name') required String vaccineName,
    @JsonKey(name: 'dose_number') required int doseNumber,
    @JsonKey(name: 'vaccination_date') required DateTime vaccinationDate,
    required String status, // 'scheduled', 'completed', 'missed'
    @JsonKey(name: 'hospital_id') int? hospitalId,
    @JsonKey(name: 'administered_by') String? administeredBy,
    @JsonKey(name: 'batch_number') String? batchNumber,
    String? manufacturer,
    @JsonKey(name: 'adverse_reaction') @Default(false) bool adverseReaction,
    @JsonKey(name: 'reaction_details') String? reactionDetails,
    String? notes,
    // Vitals at vaccination
    String? temperature,
    @JsonKey(name: 'temperature_unit') String? temperatureUnit,
    String? weight,
    @JsonKey(name: 'height_length') String? heightLength,
    @JsonKey(name: 'pulse_rate') int? pulseRate,
    @JsonKey(name: 'oxygen_saturation') String? oxygenSaturation,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _VaccinationModel;

  factory VaccinationModel.fromJson(Map<String, dynamic> json) =>
      _$VaccinationModelFromJson(json);
}


















