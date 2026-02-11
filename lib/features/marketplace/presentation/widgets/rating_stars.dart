import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final bool showValue;
  final bool interactive;
  final ValueChanged<int>? onRatingChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 16.0,
    this.showValue = false,
    this.interactive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(maxRating, (index) {
            final value = index + 1;
            final isFilled = value <= rating.round();
            
            return GestureDetector(
              onTap: interactive && onRatingChanged != null
                  ? () => onRatingChanged!(value)
                  : null,
              child: Icon(
                isFilled ? Icons.star : Icons.star_border,
                size: size,
                color: isFilled ? Colors.amber : Colors.grey[300],
              ),
            );
          }),
        ),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

