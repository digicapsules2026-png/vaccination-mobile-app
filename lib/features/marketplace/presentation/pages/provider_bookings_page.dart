import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/services_provider.dart';
import '../../data/models/marketplace_models.dart';
import '../widgets/booking_card.dart';

class ProviderBookingsPage extends ConsumerStatefulWidget {
  const ProviderBookingsPage({super.key});

  @override
  ConsumerState<ProviderBookingsPage> createState() => _ProviderBookingsPageState();
}

class _ProviderBookingsPageState extends ConsumerState<ProviderBookingsPage> {
  String? _selectedStatus;
  bool _isLoading = true;
  List<MarketplaceBookingModel> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(marketplaceServiceProvider);
      final response = await service.searchBookings(
        status: _selectedStatus,
        page: 1,
        pageSize: 50,
      );

      setState(() {
        _bookings = response.items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading bookings: $e')),
        );
      }
    }
  }

  Future<void> _confirmBooking(int id) async {
    try {
      final service = ref.read(marketplaceServiceProvider);
      await service.confirmBooking(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking confirmed')),
        );
        _loadBookings();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error confirming booking: $e')),
        );
      }
    }
  }

  Future<void> _completeBooking(int id) async {
    try {
      final service = ref.read(marketplaceServiceProvider);
      await service.completeBooking(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking marked as completed')),
        );
        _loadBookings();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error completing booking: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bookings'),
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('All', null),
                const SizedBox(width: 8),
                _buildFilterChip('Pending Payment', 'pending_payment'),
                const SizedBox(width: 8),
                _buildFilterChip('Confirmed', 'confirmed'),
                const SizedBox(width: 8),
                _buildFilterChip('Completed', 'completed'),
              ],
            ),
          ),
          const Divider(),

          // Bookings list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _bookings.isEmpty
                    ? Center(
                        child: Text(
                          'No bookings found',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadBookings,
                        child: ListView.builder(
                          itemCount: _bookings.length,
                          itemBuilder: (context, index) {
                            final booking = _bookings[index];
                            return BookingCard(
                              booking: booking,
                              onTap: () {
                                context.push('/marketplace/booking/${booking.id}');
                              },
                              onPayment: null,
                              onCancel: null,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: _bookings.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                // Show action sheet for bulk actions
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.check_circle),
                          title: const Text('Confirm Selected'),
                          onTap: () {
                            // TODO: Implement bulk confirm
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.complete),
                          title: const Text('Complete Selected'),
                          onTap: () {
                            // TODO: Implement bulk complete
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.more_vert),
              label: const Text('Actions'),
            )
          : null,
    );
  }

  Widget _buildFilterChip(String label, String? status) {
    final isSelected = _selectedStatus == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? status : null;
        });
        _loadBookings();
      },
    );
  }
}

