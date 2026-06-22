import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/attraction.dart';
import '../providers/favorites_provider.dart';
import '../widgets/star_rating.dart';
import '../widgets/rating_dialog.dart';

class DetailScreen extends StatefulWidget {
  final Attraction attraction;
  const DetailScreen({super.key, required this.attraction});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? _distance;
  bool _loadingLocation = false;

  Color _categoryColor(String category) {
    switch (category) {
      case 'Hotels': return Colors.orange;
      case 'Nature': return Colors.green;
      case 'Historical': return Colors.purple;
      default: return Colors.teal;
    }
  }

Future<void> _calculateDistance() async {
  setState(() => _loadingLocation = true);
  try {
    // Check if location service is on
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnack(' Please turn on Location in your phone Settings');
      setState(() => _loadingLocation = false);
      return;
    }

    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnack(' Location permission denied. Please allow in Settings.');
        setState(() => _loadingLocation = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnack(' Location permanently denied. Enable in App Settings.');
      setState(() => _loadingLocation = false);
      return;
    }

    // Get position
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final distM = Geolocator.distanceBetween(
        pos.latitude, pos.longitude,
        widget.attraction.latitude, widget.attraction.longitude);

    setState(() {
      _distance = ' ${(distM / 1000).toStringAsFixed(1)} km from your location';
      _loadingLocation = false;
    });
  } catch (e) {
    _showSnack(' Could not get location. Try again.');
    setState(() => _loadingLocation = false);
  }
}

  Future<void> _openMaps() async {
    final a = widget.attraction;

    // Try Google Maps app first
    final googleMapsApp = Uri.parse(
        'google.navigation:q=${a.latitude},${a.longitude}&mode=d');

    // Fallback to browser
    final googleMapsBrowser = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${a.latitude},${a.longitude}&travelmode=driving');

    if (await canLaunchUrl(googleMapsApp)) {
      await launchUrl(googleMapsApp);
    } else if (await canLaunchUrl(googleMapsBrowser)) {
      await launchUrl(googleMapsBrowser,
          mode: LaunchMode.externalApplication);
    } else {
      _showSnack('Could not open Google Maps');
    }
  }

  Future<void> _showRatingDialog(double currentRating) async {
    final result = await showDialog<double>(
      context: context,
      builder: (_) => RatingDialog(
        currentRating: currentRating,
        attractionName: widget.attraction.name,
      ),
    );
    if (result != null && mounted) {
      await context.read<FavoritesProvider>().setRating(
            widget.attraction.id, result);
      _showSnack('Rating saved! ⭐ ${result.toInt()}/5');
    }
  }

  void _showSnack(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final a = widget.attraction;
    final provider = context.watch<FavoritesProvider>();
    final isFav = provider.isFavorite(a.id);
    final rating = provider.getRating(a.id);
    final catColor = _categoryColor(a.category);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(a.name,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.black54, blurRadius: 4)
                      ])),
              background: Image.network(
                a.imageUrl,
                fit: BoxFit.cover,
                headers: const {'Accept': 'image/*'},
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                        child: CircularProgressIndicator(color: Colors.teal)),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.landscape, size: 80, color: Colors.grey),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red),
                onPressed: () =>
                    context.read<FavoritesProvider>().toggleFavorite(a),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + Rating row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: catColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(a.category,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ),
                      const Spacer(),
                      // Rating display
                      GestureDetector(
                        onTap: () => _showRatingDialog(rating),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: Row(
                            children: [
                              StarRating(rating: rating, size: 18, showLabel: false),
                              const SizedBox(width: 6),
                              Text(
                                rating > 0 ? rating.toStringAsFixed(1) : 'Rate',
                                style: TextStyle(
                                    color: Colors.amber[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // About
                  Text('About',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(a.description,
                      style: const TextStyle(
                          height: 1.7, fontSize: 15, color: Colors.black87)),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Address
                  Row(children: [
                    const Icon(Icons.location_on, color: Colors.teal, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(a.address,
                            style: const TextStyle(fontSize: 14))),
                  ]),

                  // Rate this place
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => _showRatingDialog(rating),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Column(
                        children: [
                          StarRating(rating: rating, size: 32, showLabel: true),
                          const SizedBox(height: 8),
                          Text(
                            rating > 0
                                ? 'Tap to update your rating'
                                : 'Tap to rate this attraction',
                            style: TextStyle(
                                color: Colors.amber[700], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Distance result
                  if (_distance != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(children: [
                        const Icon(Icons.straighten, color: Colors.blue),
                        const SizedBox(width: 10),
                        Text(_distance!,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // Action buttons
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: _loadingLocation
                            ? const SizedBox(
                                width: 16, height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.my_location),
                        label: const Text('My Distance'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.teal),
                          foregroundColor: Colors.teal,
                        ),
                        onPressed: _loadingLocation ? null : _calculateDistance,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.navigation),
                        label: const Text('Navigate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _openMaps,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}