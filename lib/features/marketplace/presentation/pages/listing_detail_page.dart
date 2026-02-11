import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/services_provider.dart';
import '../../../beneficiaries/data/services/beneficiaries_service.dart';
import '../../../beneficiaries/data/models/beneficiary_model.dart';
import '../../data/models/marketplace_models.dart';
import '../widgets/rating_stars.dart';
import '../widgets/review_card.dart';

class ListingDetailPage extends ConsumerStatefulWidget {
  final int listingId;

  const ListingDetailPage({
    super.key,
    required this.listingId,
  });

  @override
  ConsumerState<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends ConsumerState<ListingDetailPage> {
  MarketplaceListingModel? _listing;
  List<BeneficiaryModel> _beneficiaries = [];
  List<MarketplaceAvailabilityModel> _availability = [];
  bool _isLoading = true;
  bool _isBooking = false;

  int? _selectedBeneficiaryId;
  DateTime? _selectedDate;
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final marketplaceService = ref.read(marketplaceServiceProvider);
      final beneficiariesService = ref.read(beneficiariesServiceProvider);

      final [listing, beneficiaries, availabilityData] = await Future.wait([
        marketplaceService.getListing(widget.listingId),
        beneficiariesService.getBeneficiaries(),
        marketplaceService.getAvailabilityCalendar(
          listingId: widget.listingId,
          dateFrom: DateTime.now().toIso8601String().split('T')[0],
          dateTo: DateTime.now().add(const Duration(days: 7)).toIso8601String().split('T')[0],
        ),
      ]);

      final slots = (availabilityData['slots'] as List?)
              ?.map((json) => MarketplaceAvailabilityModel.fromJson(json as Map<String, dynamic>))
              .where((slot) => slot.status == 'available')
              .toList() ??
          [];

      setState(() {
        _listing = listing;
        _beneficiaries = beneficiaries;
        _availability = slots;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading listing: $e')),
        );
      }
    }
  }

  Future<void> _createBooking() async {
    if (_selectedBeneficiaryId == null || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select beneficiary, date, and time')),
      );
      return;
    }

    setState(() => _isBooking = true);

    try {
      final service = ref.read(marketplaceServiceProvider);
      final booking = await service.createBooking({
        'listing_id': widget.listingId,
        'beneficiary_id': _selectedBeneficiaryId,
        'appointment_date': _selectedDate!.toIso8601String().split('T')[0],
        'appointment_time': _selectedTime,
      });

      if (mounted) {
        Navigator.pushNamed(
          context,
          '/marketplace/booking/${booking.id}/payment',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating booking: $e')),
        );
      }
    } finally {
      setState(() => _isBooking = false);
    }
  }

  List<String> _getAvailableTimes() {
    if (_selectedDate == null) return [];
    final dateStr = _selectedDate!.toIso8601String().split('T')[0];
    return _availability
        .where((slot) => slot.date.toIso8601String().split('T')[0] == dateStr)
        .map((slot) => slot.timeSlot)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _listing == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Listing Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _listing!.facilityName ?? 'Unknown Facility',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_listing!.facilityAddress != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${_listing!.facilityAddress}, ${_listing!.facilityCity ?? ''}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (_listing!.averageRating != null)
                    RatingStars(
                      rating: _listing!.averageRating!,
                      size: 20,
                      showValue: true,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    currencyFormat.format(_listing!.price),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_listing!.description != null) ...[
                    const Text(
                      'Description',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _listing!.description!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),

            const Divider(),

            // Booking Form
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Book Appointment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Beneficiary Selection
                  DropdownButtonFormField<int>(
                    value: _selectedBeneficiaryId,
                    decoration: const InputDecoration(
                      labelText: 'Select Beneficiary',
                      border: OutlineInputBorder(),
                    ),
                    items: _beneficiaries.map((beneficiary) {
                      final name = '${beneficiary.firstName} ${beneficiary.lastName}';
                      return DropdownMenuItem(
                        value: beneficiary.id,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedBeneficiaryId = value),
                  ),
                  const SizedBox(height: 16),

                  // Date Selection
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                          _selectedTime = null; // Reset time when date changes
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Select Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? dateFormat.format(_selectedDate!)
                            : 'Choose date',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Time Selection
                  if (_selectedDate != null)
                    DropdownButtonFormField<String>(
                      value: _selectedTime,
                      decoration: const InputDecoration(
                        labelText: 'Select Time',
                        border: OutlineInputBorder(),
                      ),
                      items: _getAvailableTimes().map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(_formatTime(time)),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedTime = value),
                    ),

                  const SizedBox(height: 24),

                  // Book Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isBooking ? null : _createBooking,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isBooking
                          ? const CircularProgressIndicator()
                          : const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),

            // Reviews Section
            if (_listing!.averageRating != null) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reviews',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    // Reviews would be loaded here
                    Text(
                      'Average Rating: ${_listing!.averageRating!.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(String timeString) {
    try {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour % 12 == 0 ? 12 : hour % 12;
      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timeString;
    }
  }
}

