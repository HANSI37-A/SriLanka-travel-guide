import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;
  final bool showLabel;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 24,
    this.color = Colors.amber,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          if (rating >= i + 1) {
            return Icon(Icons.star_rounded, size: size, color: color);
          } else if (rating >= i + 0.5) {
            return Icon(Icons.star_half_rounded, size: size, color: color);
          } else {
            return Icon(Icons.star_outline_rounded, size: size, color: Colors.grey[300]);
          }
        }),
        if (showLabel && rating > 0) ...[
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.65,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
        if (showLabel && rating == 0) ...[
          const SizedBox(width: 6),
          Text(
            'Not rated yet',
            style: TextStyle(
              fontSize: size * 0.55,
              color: Colors.grey[400],
            ),
          ),
        ],
      ],
    );
  }
}