import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketplace_payment_model.freezed.dart';
part 'marketplace_payment_model.g.dart';

@freezed
class MarketplacePaymentModel with _$MarketplacePaymentModel {
  const factory MarketplacePaymentModel({
    required int id,
    @JsonKey(name: 'payment_reference') required String paymentReference,
    @JsonKey(name: 'booking_id') required int bookingId,
    @JsonKey(name: 'user_id') int? userId,
    required double amount,
    required String currency,
    required String status, // 'pending' | 'processing' | 'completed' | 'failed' | 'refunded' | 'partially_refunded'
    @JsonKey(name: 'payment_gateway') String? paymentGateway, // 'razorpay' | 'stripe'
    @JsonKey(name: 'gateway_order_id') String? gatewayOrderId,
    @JsonKey(name: 'gateway_payment_id') String? gatewayPaymentId,
    @JsonKey(name: 'gateway_signature') String? gatewaySignature,
    @JsonKey(name: 'payment_method') String? paymentMethod, // 'card' | 'upi' | 'netbanking' | 'wallet' | 'other'
    @JsonKey(name: 'failure_reason') String? failureReason,
    @JsonKey(name: 'refund_amount') @Default(0.0) double refundAmount,
    @JsonKey(name: 'refund_reason') String? refundReason,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _MarketplacePaymentModel;

  factory MarketplacePaymentModel.fromJson(Map<String, dynamic> json) =>
      _$MarketplacePaymentModelFromJson(json);
}

