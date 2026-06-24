import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/attraction.dart';
import '../providers/favorites_provider.dart';
import '../screens/detail_screen.dart';
import '../widgets/star_rating.dart';

class AttractionCard extends StatelessWidget {
  final Attraction attraction;
  final bool isGrid;
  const AttractionCard({super.key, required this.attraction, required this.isGrid});

  Color _categoryColor(String category) {
    switch (category) {
      case 'Hotels': return Colors.orange;
      case 'Nature': return Colors.green;
      case 'Historical': return Colors.purple;
      default: return Colors.teal;
    }
  }

 @override
Widget build(BuildContext context) {
  final isFav = context.watch<FavoritesProvider>().isFavorite(attraction.id);

  return GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(attraction: attraction)),
    ),
    child: Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed height image container — no Expanded needed
          SizedBox(
            height: 140,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  attraction.imageUrl,
                  fit: BoxFit.cover,
                  headers: const {'Accept': 'image/*'},
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey[100],
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.teal, strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (_, _, _) => Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.landscape, size: 40, color: Colors.grey[400]),
                        const SizedBox(height: 4),
                        Text('No image',
                            style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                // Category badge
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.65),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _categoryColor(attraction.category),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        attraction.category,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 6, right: 6,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16,
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red, size: 16,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () => context
                          .read<FavoritesProvider>()
                          .toggleFavorite(attraction),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Name text
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attraction.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                StarRating(
                  rating: context.watch<FavoritesProvider>().getRating(attraction.id),
                  size: 14,
                  showLabel: false,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}