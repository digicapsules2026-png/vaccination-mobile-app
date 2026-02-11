import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/marketplace_models.dart';

class BookingCard extends StatelessWidget {
  final MarketplaceBookingModel booking;
  final VoidCallback? onTap;
  final VoidCallback? onPayment;
  final VoidCallback? onCancel;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.onPayment,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with reference and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking #${booking.bookingReference}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (booking.facilityName != null)
                          Text(
                            booking.facilityName!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(booking.status),
                ],
              ),
              const SizedBox(height: 12),

              // Appointment details
              _buildInfoRow(
                Icons.calendar_today,
                dateFormat.format(booking.appointmentDate),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.access_time,
                _formatTime(booking.appointmentTime),
              ),
              if (booking.vaccineName != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.vaccines,
                  booking.vaccineName!,
                ),
              ],
              if (booking.facilityAddress != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.location_on,
                  booking.facilityAddress!,
                ),
              ],
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.attach_money,
                currencyFormat.format(booking.pricePaid ?? 0),
                isPrice: true,
              ),

              // Actions
              if (onPayment != null || onCancel != null) ...[
                const Divider(height: 24),
                Row(
                  children: [
                    if (onTap != null)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onTap,
                          child: const Text('View Details'),
                        ),
                      ),
                    if (onPayment != null && booking.status == 'pending_payment') ...[
                      if (onTap != null) const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Pay Now'),
                        ),
                      ),
                    ],
                    if (onCancel != null &&
                        (booking.status == 'confirmed' || booking.status == 'pending_payment')) ...[
                      if (onTap != null || onPayment != null) const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCancel,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isPrice = false}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isPrice ? Colors.green : Colors.grey[800],
              fontWeight: isPrice ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'pending_payment':
        color = Colors.orange;
        label = 'Pending Payment';
        icon = Icons.payment;
        break;
      case 'confirmed':
        color = Colors.green;
        label = 'Confirmed';
        icon = Icons.check_circle;
        break;
      case 'completed':
        color = Colors.blue;
        label = 'Completed';
        icon = Icons.check_circle;
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Cancelled';
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        label = status;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String timeString) {
    try {
      // Handle "HH:MM:SS" or "HH:MM" format
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

