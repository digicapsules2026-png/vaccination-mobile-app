import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketplace_review_model.freezed.dart';
part 'marketplace_review_model.g.dart';

@freezed
class MarketplaceReviewModel with _$MarketplaceReviewModel {
  const factory MarketplaceReviewModel({
    required int id,
    @JsonKey(name: 'booking_id') required int bookingId,
    @JsonKey(name: 'listing_id') required int listingId,
    @JsonKey(name: 'user_id') int? userId,
    required int rating, // 1-5
    @JsonKey(name: 'review_text') String? reviewText,
    required String status, // 'active' | 'hidden'
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Populated fields
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'booking_reference') String? bookingReference,
  }) = _MarketplaceReviewModel;

  factory MarketplaceReviewModel.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceReviewModelFromJson(json);
}

