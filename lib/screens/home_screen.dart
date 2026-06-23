import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/attractions_data.dart';
import '../models/attraction.dart';
import '../providers/favorites_provider.dart';
import '../screens/detail_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = ['All', 'Hotels', 'Nature', 'Historical'];

  List<Attraction> get _filtered {
    List<Attraction> list = _selectedCategory == 'All'
        ? sampleAttractions
        : sampleAttractions
            .where((a) => a.category == _selectedCategory)
            .toList();
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((a) =>
              a.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              a.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              a.address
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, provider, _) {
        final userName =
            provider.currentUser?['fullName']?.split(' ').first ??
                'Traveller';

        final imagePath = provider.currentUser?['imagePath'];

        return Scaffold(
          backgroundColor: const Color(0xFFF8F6F0),
          body: SafeArea(
            child: Column(
              children: [
                // ── Top Bar ──────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFF00695C),
                        backgroundImage: imagePath != null
                            ? FileImage(File(imagePath))
                            : null,
                        child: imagePath == null
                            ? const Icon(Icons.person,
                                color: Colors.white, size: 22)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      // Greeting
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 12),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '${_getGreeting()} $userName',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A1A)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text('👋',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Notification bell
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AboutScreen()),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                              Icons.notifications_outlined,
                              color: Color(0xFF1B4332),
                              size: 22),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Search Bar ─────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) =>
                                setState(() => _searchQuery = val),
                            decoration: InputDecoration(
                              hintText: 'Search places in Sri Lanka...',
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 14),
                              prefixIcon: Icon(Icons.search,
                                  color: Colors.grey[400], size: 20),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear,
                                          color: Colors.grey, size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(
                                            () => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Category Chips ──────────────────────
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _categories.length,
                    itemBuilder: (_, i) {
                      final cat = _categories[i];
                      final selected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => setState(
                              () => _selectedCategory = cat),
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF1B4332)
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(alpha: 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Colors.grey[600],
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // ── Scrollable Content ──────────────────
                Expanded(
                  child: _searchQuery.isNotEmpty
                      ? _buildSearchResults()
                      : _buildMainContent(provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    final results = _filtered;
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 70, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No results for "$_searchQuery"',
                style: TextStyle(
                    fontSize: 16, color: Colors.grey[500])),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: results.length,
      itemBuilder: (_, i) => _PopularCard(attraction: results[i]),
    );
  }

  Widget _buildMainContent(FavoritesProvider provider) {
    final featured = _filtered.take(5).toList();
    final popular = _filtered;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Featured header
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B4332),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Featured Places',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A))),
              const Spacer(),
            ],
          ),
        ),

        // Featured horizontal scroll
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            itemCount: featured.length,
            itemBuilder: (_, i) =>
                _FeaturedCard(attraction: featured[i]),
          ),
        ),
        const SizedBox(height: 20),

        // Popular header
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B4332),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Popular Near You',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A))),
            ],
          ),
        ),

        // Popular list
        ...popular.map((a) => _PopularCard(attraction: a)),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ── Featured Card ───────────────────────────────────────

class _FeaturedCard extends StatelessWidget {
  final Attraction attraction;
  const _FeaturedCard({required this.attraction});

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Hotels': return Colors.orange;
      case 'Nature': return const Color(0xFF1B4332);
      case 'Historical': return Colors.purple;
      default: return Colors.teal;
    }
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
        width: 240,
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                attraction.imageUrl,
                fit: BoxFit.cover,
                headers: const {'Accept': 'image/*'},
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Container(
                        color: Colors.grey[200],
                        child: const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF1B4332),
                                strokeWidth: 2))),
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.landscape,
                      size: 60, color: Colors.grey),
                ),
              ),
              // Gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              // Heart
              Positioned(
                top: 12, right: 12,
                child: GestureDetector(
                  onTap: () => context
                      .read<FavoritesProvider>()
                      .toggleFavorite(attraction),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red, size: 18,
                    ),
                  ),
                ),
              ),
              // Info
              Positioned(
                bottom: 12, left: 12, right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attraction.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.white70, size: 12),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            attraction.address.split(',').first,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _categoryColor(attraction.category),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.white, size: 11),
                              const SizedBox(width: 3),
                              Text(
                                rating > 0
                                    ? rating.toStringAsFixed(1)
                                    : '4.5',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
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

// ── Popular Card ────────────────────────────────────────

class _PopularCard extends StatelessWidget {
  final Attraction attraction;
  const _PopularCard({required this.attraction});

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Hotels': return Colors.orange;
      case 'Nature': return const Color(0xFF1B4332);
      case 'Historical': return Colors.purple;
      default: return Colors.teal;
    }
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
        margin:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 80, height: 80,
                child: Image.network(
                  attraction.imageUrl,
                  fit: BoxFit.cover,
                  headers: const {'Accept': 'image/*'},
                  loadingBuilder: (_, child, progress) =>
                      progress == null
                          ? child
                          : Container(
                              color: Colors.grey[100],
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF1B4332)))),
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.landscape,
                        color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attraction.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1A1A1A)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _categoryColor(attraction.category)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      attraction.category,
                      style: TextStyle(
                          color: _categoryColor(attraction.category),
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFFD4A843), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating > 0
                            ? '${rating.toStringAsFixed(1)} (reviews)'
                            : '4.8 (1.2k reviews)',
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => context
                  .read<FavoritesProvider>()
                  .toggleFavorite(attraction),
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey[300],
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}