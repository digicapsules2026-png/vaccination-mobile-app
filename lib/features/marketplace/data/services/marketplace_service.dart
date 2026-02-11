import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/marketplace_models.dart';
import '../models/paginated_response.dart';

class MarketplaceService {
  final ApiClient _apiClient;

  MarketplaceService(this._apiClient);

  // Helper to get v2 API base URL
  String get _v2BaseUrl => '/api/v2/marketplace';

  // ========== LISTINGS ==========

  /// Search listings with filters
  Future<PaginatedResponse<MarketplaceListingModel>> searchListings({
    String? location,
    int? vaccineId,
    double? priceMin,
    double? priceMax,
    String? facilityType,
    String? availabilityDate,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (location != null) 'location': location,
      if (vaccineId != null) 'vaccine_id': vaccineId,
      if (priceMin != null) 'price_min': priceMin,
      if (priceMax != null) 'price_max': priceMax,
      if (facilityType != null) 'facility_type': facilityType,
      if (availabilityDate != null) 'availability_date': availabilityDate,
    };

    final response = await _apiClient.dio.get(
      '$_v2BaseUrl/listings',
      queryParameters: params,
    );

    return PaginatedResponse.fromJson(
      response.data,
      (json) => MarketplaceListingModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get listing by ID
  Future<MarketplaceListingModel> getListing(int id) async {
    final response = await _apiClient.dio.get('$_v2BaseUrl/listings/$id');
    return MarketplaceListingModel.fromJson(response.data);
  }

  /// Create new listing (Provider)
  Future<MarketplaceListingModel> createListing(Map<String, dynamic> data) async {
    final response = await _apiClient.dio.post(
      '$_v2BaseUrl/listings',
      data: data,
    );
    return MarketplaceListingModel.fromJson(response.data);
  }

  /// Update listing (Provider)
  Future<MarketplaceListingModel> updateListing(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.dio.put(
      '$_v2BaseUrl/listings/$id',
      data: data,
    );
    return MarketplaceListingModel.fromJson(response.data);
  }

  /// Delete listing (Provider)
  Future<void> deleteListing(int id) async {
    await _apiClient.dio.delete('$_v2BaseUrl/listings/$id');
  }

  /// Get user's listings (Provider)
  Future<List<MarketplaceListingModel>> getUserListings() async {
    final response = await _apiClient.dio.get('$_v2BaseUrl/listings/user/listings');
    return (response.data as List)
        .map((json) => MarketplaceListingModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Approve or reject listing (Super Admin)
  Future<MarketplaceListingModel> approveListing({
    required int id,
    required bool approved,
    String? rejectionReason,
  }) async {
    final response = await _apiClient.dio.put(
      '$_v2BaseUrl/listings/$id/approve',
      data: {
        'approved': approved,
        if (rejectionReason != null) 'rejection_reason': rejectionReason,
      },
    );
    return MarketplaceListingModel.fromJson(response.data);
  }

  // ========== BOOKINGS ==========

  /// Search bookings with filters
  Future<PaginatedResponse<MarketplaceBookingModel>> searchBookings({
    String? status,
    int? beneficiaryId,
    int? listingId,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int pageSize = 50,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (status != null) 'status': status,
      if (beneficiaryId != null) 'beneficiary_id': beneficiaryId,
      if (listingId != null) 'listing_id': listingId,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
    };

    final response = await _apiClient.dio.get(
      '$_v2BaseUrl/bookings',
      queryParameters: params,
    );

    return PaginatedResponse.fromJson(
      response.data,
      (json) => MarketplaceBookingModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get booking by ID
  Future<MarketplaceBookingModel> getBooking(int id) async {
    final response = await _apiClient.dio.get('$_v2BaseUrl/bookings/$id');
    return MarketplaceBookingModel.fromJson(response.data);
  }

  /// Create booking (Parent)
  Future<MarketplaceBookingModel> createBooking(Map<String, dynamic> data) async {
    final response = await _apiClient.dio.post(
      '$_v2BaseUrl/bookings',
      data: data,
    );
    return MarketplaceBookingModel.fromJson(response.data);
  }

  /// Update booking
  Future<MarketplaceBookingModel> updateBooking(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.dio.put(
      '$_v2BaseUrl/bookings/$id',
      data: data,
    );
    return MarketplaceBookingModel.fromJson(response.data);
  }

  /// Confirm booking (Provider)
  Future<MarketplaceBookingModel> confirmBooking(int id) async {
    final response = await _apiClient.dio.put('$_v2BaseUrl/bookings/$id/confirm');
    return MarketplaceBookingModel.fromJson(response.data);
  }

  /// Complete booking (Provider)
  Future<MarketplaceBookingModel> completeBooking(int id, {int? vaccinationId}) async {
    final response = await _apiClient.dio.put(
      '$_v2BaseUrl/bookings/$id/complete',
      data: vaccinationId != null ? {'vaccination_id': vaccinationId} : null,
    );
    return MarketplaceBookingModel.fromJson(response.data);
  }

  /// Cancel booking
  Future<MarketplaceBookingModel> cancelBooking(int id, String reason) async {
    final response = await _apiClient.dio.put(
      '$_v2BaseUrl/bookings/$id/cancel',
      data: {'reason': reason},
    );
    return MarketplaceBookingModel.fromJson(response.data);
  }

  // ========== PAYMENTS ==========

  /// Initiate payment
  Future<Map<String, dynamic>> initiatePayment({
    required int bookingId,
    required double amount,
    String currency = 'INR',
  }) async {
    final response = await _apiClient.dio.post(
      '$_v2BaseUrl/payments/initiate',
      data: {
        'booking_id': bookingId,
        'amount': amount,
        'currency': currency,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Get payment by ID
  Future<MarketplacePaymentModel> getPayment(int id) async {
    final response = await _apiClient.dio.get('$_v2BaseUrl/payments/$id');
    return MarketplacePaymentModel.fromJson(response.data);
  }

  /// Search payments
  Future<PaginatedResponse<MarketplacePaymentModel>> searchPayments({
    int? bookingId,
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (bookingId != null) 'booking_id': bookingId,
      if (status != null) 'status': status,
    };

    final response = await _apiClient.dio.get(
      '$_v2BaseUrl/payments',
      queryParameters: params,
    );

    return PaginatedResponse.fromJson(
      response.data,
      (json) => MarketplacePaymentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // ========== AVAILABILITY ==========

  /// Get availability calendar for a listing
  Future<Map<String, dynamic>> getAvailabilityCalendar({
    required int listingId,
    required String dateFrom,
    required String dateTo,
  }) async {
    final response = await _apiClient.dio.get(
      '$_v2BaseUrl/listings/$listingId/availability',
      queryParameters: {
        'date_from': dateFrom,
        'date_to': dateTo,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Create availability slot (Provider)
  Future<MarketplaceAvailabilityModel> createAvailability({
    required int listingId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _apiClient.dio.post(
      '$_v2BaseUrl/listings/$listingId/availability',
      data: data,
    );
    return MarketplaceAvailabilityModel.fromJson(response.data);
  }

  /// Update availability slot (Provider)
  Future<MarketplaceAvailabilityModel> updateAvailability(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.dio.put(
      '$_v2BaseUrl/availability/$id',
      data: data,
    );
    return MarketplaceAvailabilityModel.fromJson(response.data);
  }

  // ========== REVIEWS ==========

  /// Get reviews for a listing
  Future<Map<String, dynamic>> getListingReviews({
    required int listingId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.dio.get(
      '$_v2BaseUrl/listings/$listingId/reviews',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Create review
  Future<MarketplaceReviewModel> createReview(Map<String, dynamic> data) async {
    final response = await _apiClient.dio.post(
      '$_v2BaseUrl/reviews',
      data: data,
    );
    return MarketplaceReviewModel.fromJson(response.data);
  }

  /// Get review by ID
  Future<MarketplaceReviewModel> getReview(int id) async {
    final response = await _apiClient.dio.get('$_v2BaseUrl/reviews/$id');
    return MarketplaceReviewModel.fromJson(response.data);
  }

  /// Update review
  Future<MarketplaceReviewModel> updateReview(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.dio.put(
      '$_v2BaseUrl/reviews/$id',
      data: data,
    );
    return MarketplaceReviewModel.fromJson(response.data);
  }

  /// Delete review
  Future<void> deleteReview(int id) async {
    await _apiClient.dio.delete('$_v2BaseUrl/reviews/$id');
  }
}

