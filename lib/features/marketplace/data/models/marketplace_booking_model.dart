import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketplace_booking_model.freezed.dart';
part 'marketplace_booking_model.g.dart';

@freezed
class MarketplaceBookingModel with _$MarketplaceBookingModel {
  const factory MarketplaceBookingModel({
    required int id,
    @JsonKey(name: 'booking_reference') required String bookingReference,
    @JsonKey(name: 'listing_id') required int listingId,
    @JsonKey(name: 'beneficiary_id') required int beneficiaryId,
    @JsonKey(name: 'vaccine_id') int? vaccineId,
    @JsonKey(name: 'appointment_date') required DateTime appointmentDate,
    @JsonKey(name: 'appointment_time') required String appointmentTime,
    required String status, // 'pending_payment' | 'confirmed' | 'completed' | 'cancelled'
    @JsonKey(name: 'price_paid') double? pricePaid,
    @JsonKey(name: 'payment_id') int? paymentId,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'vaccination_id') int? vaccinationId,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Populated fields
    @JsonKey(name: 'listing_price') double? listingPrice,
    @JsonKey(name: 'listing_description') String? listingDescription,
    @JsonKey(name: 'beneficiary_name') String? beneficiaryName,
    @JsonKey(name: 'beneficiary_type') String? beneficiaryType,
    @JsonKey(name: 'facility_name') String? facilityName,
    @JsonKey(name: 'facility_address') String? facilityAddress,
    @JsonKey(name: 'vaccine_name') String? vaccineName,
    String? currency,
  }) = _MarketplaceBookingModel;

  factory MarketplaceBookingModel.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceBookingModelFromJson(json);
}

