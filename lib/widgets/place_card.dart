import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/attraction.dart';
import '../providers/favorites_provider.dart';
import '../screens/detail_screen.dart';

class PlaceCard extends StatelessWidget {
  final Attraction attraction;
  final double width;
  final double height;

  const PlaceCard({
    super.key,
    required this.attraction,
    this.width = 160,
    this.height = 200,
  });

  String _getDefaultRating(String id) {
    final ratings = {'1': '4.9', '2': '4.8', '3': '4.7',
        '4': '4.8', '5': '4.6', '6': '4.7',
        '7': '4.9', '8': '4.5', '9': '4.8'};
    return ratings[id] ?? '4.5';
  }

  @override
  Widget build(BuildContext context) {
    final isFav =
        context.watch<FavoritesProvider>().isFavorite(attraction.id);
    final rating =
        context.watch<FavoritesProvider>().getRating(attraction.id);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => DetailScreen(attraction: attraction)),
      ),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Full background image ──────────────
              Image.network(
                attraction.imageUrl,
                fit: BoxFit.cover,
                headers: const {'Accept': 'image/*'},
                loadingBuilder: (_, child, progress) =>
                    progress == null
                        ? child
                        : Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFF1B4332),
                                  strokeWidth: 2),
                            ),
                          ),
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.landscape,
                      size: 50, color: Colors.grey),
                ),
              ),

              // ── Strong gradient overlay ────────────
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.4, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.82),
                    ],
                  ),
                ),
              ),

              // ── Star rating badge top left ─────────
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A843),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star,
                          color: Colors.white, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        rating > 0
                            ? rating.toStringAsFixed(1)
                            : _getDefaultRating(attraction.id),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Heart button top right ─────────────
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => context
                      .read<FavoritesProvider>()
                      .toggleFavorite(attraction),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),

              // ── Name + location bottom ─────────────
              Positioned(
                bottom: 14,
                left: 14,
                right: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      attraction.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            attraction.address.split(',').first,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}