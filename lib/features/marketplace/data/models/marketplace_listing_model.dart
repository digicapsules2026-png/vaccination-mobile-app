import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketplace_listing_model.freezed.dart';
part 'marketplace_listing_model.g.dart';

@freezed
class MarketplaceListingModel with _$MarketplaceListingModel {
  const factory MarketplaceListingModel({
    required int id,
    @JsonKey(name: 'facility_id') required int facilityId,
    @JsonKey(name: 'vaccine_ids') required List<int> vaccineIds,
    required double price,
    required String currency,
    String? description,
    @JsonKey(name: 'availability_schedule') Map<String, dynamic>? availabilitySchedule,
    required String status, // 'pending_approval' | 'active' | 'inactive' | 'rejected'
    @JsonKey(name: 'created_by') int? createdBy,
    @JsonKey(name: 'approved_by') int? approvedBy,
    @JsonKey(name: 'approved_at') DateTime? approvedAt,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Populated fields
    @JsonKey(name: 'facility_name') String? facilityName,
    @JsonKey(name: 'facility_address') String? facilityAddress,
    @JsonKey(name: 'facility_city') String? facilityCity,
    @JsonKey(name: 'facility_pincode') String? facilityPincode,
    @JsonKey(name: 'average_rating') double? averageRating,
    @JsonKey(name: 'total_reviews') int? totalReviews,
  }) = _MarketplaceListingModel;

  factory MarketplaceListingModel.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceListingModelFromJson(json);
}

