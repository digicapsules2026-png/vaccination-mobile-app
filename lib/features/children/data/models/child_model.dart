import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_model.freezed.dart';
part 'child_model.g.dart';

@freezed
class ChildModel with _$ChildModel {
  const factory ChildModel({
    required int id,
    @JsonKey(name: 'parent_id') required int parentId,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'middle_name') String? middleName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'date_of_birth') required DateTime dateOfBirth,
    required String gender,
    @JsonKey(name: 'blood_group') required String bloodGroup,
    @JsonKey(name: 'birth_weight') String? birthWeight,
    @JsonKey(name: 'birth_height') String? birthHeight,
    @JsonKey(name: 'place_of_birth') String? placeOfBirth,
    String? address,
    String? city,
    String? state,
    String? pincode,
    String? allergies,
    @JsonKey(name: 'medical_conditions') String? medicalConditions,
    @JsonKey(name: 'qr_code_url') String? qrCodeUrl,
    @JsonKey(name: 'qr_code_token') String? qrCodeToken,
    @JsonKey(name: 'abha_number') String? abhaNumber,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ChildModel;

  factory ChildModel.fromJson(Map<String, dynamic> json) =>
      _$ChildModelFromJson(json);
}





