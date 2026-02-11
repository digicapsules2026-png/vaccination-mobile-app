import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/services_provider.dart';
import '../../data/models/marketplace_models.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final int bookingId;

  const PaymentPage({
    super.key,
    required this.bookingId,
  });

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  MarketplaceBookingModel? _booking;
  Map<String, dynamic>? _paymentData;
  bool _isLoading = true;
  bool _isProcessing = false;
  bool _paymentSuccess = false;

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  Future<void> _loadBooking() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(marketplaceServiceProvider);
      final booking = await service.getBooking(widget.bookingId);

      if (booking.status == 'pending_payment' && booking.pricePaid != null) {
        final paymentResponse = await service.initiatePayment(
          bookingId: widget.bookingId,
          amount: booking.pricePaid!,
          currency: booking.currency ?? 'INR',
        );
        setState(() {
          _paymentData = paymentResponse;
        });
      } else if (booking.status == 'confirmed') {
        setState(() {
          _paymentSuccess = true;
        });
      }

      setState(() {
        _booking = booking;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading booking: $e')),
        );
      }
    }
  }

  Future<void> _processPayment() async {
    if (_paymentData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment gateway not ready')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // TODO: Integrate Razorpay Flutter SDK here
      // For now, show a placeholder
      await Future.delayed(const Duration(seconds: 2));

      // Simulate payment success
      if (mounted) {
        setState(() {
          _paymentSuccess = true;
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to booking details after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.pushReplacement('/marketplace/booking/${widget.bookingId}');
          }
        });
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _booking == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_paymentSuccess) {
      return Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Payment Successful!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your booking has been confirmed.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    context.pushReplacement('/marketplace/booking/${widget.bookingId}');
                  },
                  child: const Text('View Booking Details'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Details
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Booking Reference', _booking!.bookingReference),
                      _buildDetailRow('Facility', _booking!.facilityName ?? 'Unknown'),
                      _buildDetailRow('Beneficiary', _booking!.beneficiaryName ?? 'Unknown'),
                      _buildDetailRow(
                        'Appointment Date',
                        dateFormat.format(_booking!.appointmentDate),
                      ),
                      _buildDetailRow('Appointment Time', _formatTime(_booking!.appointmentTime)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Payment Amount
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currencyFormat.format(_booking!.pricePaid ?? 0),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Pay Button
              if (_paymentData != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                    ),
                    child: _isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Pay Now'),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.yellow[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.yellow[800]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Payment gateway not configured. Please contact support.',
                          style: TextStyle(color: Colors.yellow[800]),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Secure payment powered by Razorpay',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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

