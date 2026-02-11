import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/marketplace_models.dart';
import '../../../vaccines/data/models/vaccine_model.dart';

class ListingCard extends StatelessWidget {
  final MarketplaceListingModel listing;
  final List<VaccineModel>? vaccines;
  final VoidCallback? onTap;

  const ListingCard({
    super.key,
    required this.listing,
    this.vaccines,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
    );

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
              // Header with name and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      listing.facilityName ?? 'Unknown Facility',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusBadge(listing.status),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              if (listing.description != null) ...[
                Text(
                  listing.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              // Location
              if (listing.facilityAddress != null) ...[
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${listing.facilityAddress}, ${listing.facilityCity ?? ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // Vaccine names
              if (listing.vaccineIds.isNotEmpty && vaccines != null) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: listing.vaccineIds.map((vaccineId) {
                    final vaccine = vaccines?.firstWhere(
                      (v) => v.id == vaccineId,
                      orElse: () => vaccines!.first,
                    );
                    if (vaccine == null) return const SizedBox.shrink();
                    return Chip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.vaccines, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            vaccine.vaccineName,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],

              // Price and Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currencyFormat.format(listing.price),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  if (listing.averageRating != null)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          listing.averageRating!.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (listing.totalReviews != null && listing.totalReviews! > 0)
                          Text(
                            ' (${listing.totalReviews})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'active':
        color = Colors.green;
        label = 'Active';
        break;
      case 'pending_approval':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'inactive':
        color = Colors.grey;
        label = 'Inactive';
        break;
      case 'rejected':
        color = Colors.red;
        label = 'Rejected';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

