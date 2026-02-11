import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/marketplace_models.dart';
import 'rating_stars.dart';

class ReviewCard extends StatelessWidget {
  final MarketplaceReviewModel review;

  const ReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      review.userName ?? 'Anonymous',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  dateFormat.format(review.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Rating
            RatingStars(
              rating: review.rating.toDouble(),
              size: 16,
              showValue: false,
            ),
            const SizedBox(height: 8),

            // Review text
            if (review.reviewText != null && review.reviewText!.isNotEmpty)
              Text(
                review.reviewText!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

