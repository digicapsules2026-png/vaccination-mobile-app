import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketplace_availability_model.freezed.dart';
part 'marketplace_availability_model.g.dart';

@freezed
class MarketplaceAvailabilityModel with _$MarketplaceAvailabilityModel {
  const factory MarketplaceAvailabilityModel({
    required int id,
    @JsonKey(name: 'listing_id') required int listingId,
    required DateTime date,
    @JsonKey(name: 'time_slot') required String timeSlot,
    required String status, // 'available' | 'booked' | 'blocked'
    @JsonKey(name: 'booking_id') int? bookingId,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _MarketplaceAvailabilityModel;

  factory MarketplaceAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceAvailabilityModelFromJson(json);
}

