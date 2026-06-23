import 'package:flutter/material.dart';
import '../data/attractions_data.dart';
import '../models/attraction.dart';
import '../widgets/place_card.dart';
import 'category_screen.dart';

class ExploreSection {
  final String title;
  final String category;
  final String categoryTitle;

  const ExploreSection({
    required this.title,
    required this.category,
    required this.categoryTitle,
  });
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = const [
    'Nature', 'Historical', 'Hotels'
  ];
  final List<IconData> _categoryIcons = const [
    Icons.park, Icons.history_edu, Icons.hotel
  ];
  final List<Color> _categoryColors = const [
    Colors.green, Colors.purple, Colors.orange
  ];

  final List<ExploreSection> _sections = const [
    ExploreSection(
        title: 'Lush Nature',
        category: 'Nature',
        categoryTitle: 'Nature Attractions'),
    ExploreSection(
        title: 'Historical Wonders',
        category: 'Historical',
        categoryTitle: 'Historical Attractions'),
    ExploreSection(
        title: 'Coastal Retreats',
        category: 'Hotels',
        categoryTitle: 'Hotels'),
  ];

  List<Attraction> get _filtered {
    if (_searchQuery.isEmpty) return [];
    return sampleAttractions
        .where((a) =>
            a.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            a.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            a.address.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  String _getCategoryTitle(String category) {
    if (category == 'Nature') return 'Nature Attractions';
    if (category == 'Historical') return 'Historical Attractions';
    return category;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F0),
     
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 95, 228, 193), // Upper part: High/Deeper accent tint
              Color(0xFFF8F6F0), // Down part: Low flat cream color
            ],
            stops: [0.0, 0.35], // Smooth fading finish in the upper third region
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── App Bar ────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    const Text(
                      'Explore Sri Lanka',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A)),
                    ),
                  ],
                ),
              ),

              // ── Search Bar ─────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
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
                      hintText: 'Search attractions...',
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
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Content ────────────────────────────
              Expanded(
                child: _searchQuery.isNotEmpty
                    ? _buildSearchResults()
                    : _buildDefaultContent(),
              ),
            ],
          ),
        ),
      ),
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
            Text('No attractions found',
                style:
                    TextStyle(fontSize: 18, color: Colors.grey[500])),
            const SizedBox(height: 8),
            Text('Try a different search term',
                style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Row(
            children: [
              Text(
                '${results.length} results for "$_searchQuery"',
                style:
                    TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.78,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: results.length,
            itemBuilder: (_, i) => PlaceCard(attraction: results[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // ── Banner ──────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B4332), Color(0xFF40916C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🇱🇰 Discover Sri Lanka',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                  'Explore 9 handpicked attractions\nacross 3 categories',
                  style:
                      TextStyle(color: Colors.white70, height: 1.5)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── Category Cards ───────────────────────
        const Text('Categories',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: List.generate(_categories.length, (ci) {
            final cat = _categories[ci];
            final icon = _categoryIcons[ci];
            final color = _categoryColors[ci];
            return Expanded(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(
                      title: _getCategoryTitle(cat),
                      category: cat,
                      attractionList: sampleAttractions,
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(
                      right: ci < _categories.length - 1 ? 10 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(cat,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),

        // ── Category Sections ────────────────────
        ..._sections.map((section) {
          final catAttractions = sampleAttractions
              .where((a) => a.category == section.category)
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(section.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryScreen(
                          title: section.categoryTitle,
                          category: section.category,
                          attractionList: sampleAttractions,
                        ),
                  ),
                ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View All',
                            style: TextStyle(
                                color: Color(0xFF1B4332),
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                        Icon(Icons.chevron_right,
                            color: Color(0xFF1B4332), size: 18),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: catAttractions.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: PlaceCard(
                      attraction: catAttractions[i],
                      width: 155,
                      height: 200,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        }),
      ],
    );
  }
}