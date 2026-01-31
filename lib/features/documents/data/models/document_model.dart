import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_model.freezed.dart';
part 'document_model.g.dart';

@freezed
class DocumentModel with _$DocumentModel {
  const factory DocumentModel({
    required int id,
    @JsonKey(name: 'child_id') required int childId,
    @JsonKey(name: 'document_type') required String documentType,
    required String title,
    String? description,
    @JsonKey(name: 'file_url') required String fileUrl,
    @JsonKey(name: 'file_size') required int fileSize,
    @JsonKey(name: 'mime_type') String? mimeType,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _DocumentModel;

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);
}

// Document categories for organization
enum DocumentCategory {
  birth,
  vaccination,
  medical,
  identity,
  other,
}

// Document types mapping
class DocumentTypeHelper {
  static DocumentCategory getCategory(String documentType) {
    switch (documentType) {
      case 'birth_certificate':
      case 'discharge_summary':
        return DocumentCategory.birth;
      case 'vaccination_card':
      case 'vaccine_proof':
        return DocumentCategory.vaccination;
      case 'medical_report':
      case 'prescription':
        return DocumentCategory.medical;
      case 'abha_card':
        return DocumentCategory.identity;
      default:
        return DocumentCategory.other;
    }
  }
}







