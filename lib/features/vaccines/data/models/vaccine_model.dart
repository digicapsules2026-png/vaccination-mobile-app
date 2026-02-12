import 'package:freezed_annotation/freezed_annotation.dart';

part 'vaccine_model.freezed.dart';
part 'vaccine_model.g.dart';

@freezed
class VaccineModel with _$VaccineModel {
  const factory VaccineModel({
    required int id,
    @JsonKey(name: 'vaccine_name') required String vaccineName,
    @JsonKey(name: 'vaccine_code') required String vaccineCode,
    String? manufacturer,
    @JsonKey(name: 'route_of_administration') String? routeOfAdministration,
    @JsonKey(name: 'site_of_administration') String? siteOfAdministration,
    String? description,
    @JsonKey(name: 'dosage_schedule') Map<String, dynamic>? dosageSchedule,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _VaccineModel;

  factory VaccineModel.fromJson(Map<String, dynamic> json) =>
      _$VaccineModelFromJson(json);
}
















