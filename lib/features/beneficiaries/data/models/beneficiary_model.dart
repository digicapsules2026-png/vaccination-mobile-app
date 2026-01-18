import 'package:freezed_annotation/freezed_annotation.dart';

part 'beneficiary_model.freezed.dart';
part 'beneficiary_model.g.dart';

@freezed
class BeneficiaryModel with _$BeneficiaryModel {
  const factory BeneficiaryModel({
    required int id,
    @JsonKey(name: 'account_id') required int accountId,
    required String type, // 'ADULT' or 'CHILD'
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'middle_name') String? middleName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'date_of_birth') required DateTime dateOfBirth,
    required String gender,
    @JsonKey(name: 'abha_id') String? abhaId,
    @JsonKey(name: 'abha_address') String? abhaAddress,
    @JsonKey(name: 'abha_linked') @Default(false) bool abhaLinked,
    @JsonKey(name: 'qr_code_url') String? qrCodeUrl,
    @JsonKey(name: 'qr_code_token') String? qrCodeToken,
    @JsonKey(name: 'legacy_child_profile_id') int? legacyChildProfileId,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _BeneficiaryModel;

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) =>
      _$BeneficiaryModelFromJson(json);
}

