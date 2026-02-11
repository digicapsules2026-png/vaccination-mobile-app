import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/services_provider.dart';
import '../../data/models/marketplace_models.dart';

class ProviderDashboardPage extends ConsumerStatefulWidget {
  const ProviderDashboardPage({super.key});

  @override
  ConsumerState<ProviderDashboardPage> createState() => _ProviderDashboardPageState();
}

class _ProviderDashboardPageState extends ConsumerState<ProviderDashboardPage> {
  List<MarketplaceListingModel> _listings = [];
  List<MarketplaceBookingModel> _bookings = [];
  bool _isLoading = true;

  int _totalListings = 0;
  int _activeListings = 0;
  int _totalBookings = 0;
  int _pendingBookings = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(marketplaceServiceProvider);
      final [listings, bookingsResponse] = await Future.wait([
        service.getUserListings(),
        service.searchBookings(page: 1, pageSize: 10),
      ]);

      setState(() {
        _listings = listings;
        _bookings = bookingsResponse.items;
        _totalListings = listings.length;
        _activeListings = listings.where((l) => l.status == 'active').length;
        _totalBookings = bookingsResponse.total;
        _pendingBookings = bookingsResponse.items
            .where((b) => b.status == 'pending_payment' || b.status == 'confirmed')
            .length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Dashboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Total Listings',
                          value: _totalListings.toString(),
                          icon: Icons.list,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Active Listings',
                          value: _activeListings.toString(),
                          icon: Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Total Bookings',
                          value: _totalBookings.toString(),
                          icon: Icons.event,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Pending',
                          value: _pendingBookings.toString(),
                          icon: Icons.pending,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Quick Actions
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.add,
                          title: 'Create Listing',
                          onTap: () => context.push('/marketplace/provider/listings'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.event,
                          title: 'Manage Bookings',
                          onTap: () => context.push('/marketplace/provider/bookings'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.calendar_today,
                          title: 'Availability',
                          onTap: () => context.push('/marketplace/provider/availability'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Recent Listings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Listings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => context.push('/marketplace/provider/listings'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _listings.isEmpty
                      ? const Card(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(
                              child: Text('No listings yet'),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _listings.take(3).length,
                          itemBuilder: (context, index) {
                            final listing = _listings[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(listing.facilityName ?? 'Unknown'),
                                subtitle: Text('₹${listing.price}'),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400],
                                ),
                                onTap: () => context.push('/marketplace/provider/listings'),
                              ),
                            );
                          },
                        ),

                  const SizedBox(height: 24),

                  // Recent Bookings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Bookings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => context.push('/marketplace/provider/bookings'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _bookings.isEmpty
                      ? const Card(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(
                              child: Text('No bookings yet'),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _bookings.take(3).length,
                          itemBuilder: (context, index) {
                            final booking = _bookings[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text('Booking #${booking.bookingReference}'),
                                subtitle: Text(booking.beneficiaryName ?? 'Unknown'),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400],
                                ),
                                onTap: () => context.push('/marketplace/provider/bookings'),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

