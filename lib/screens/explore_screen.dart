import 'package:flutter/material.dart';
import '../data/attractions_data.dart';
import '../models/attraction.dart';
import '../widgets/attraction_card.dart';
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
  bool _isGridView = true;

  final List<String> _categories = const ['Nature', 'Historical', 'Hotels'];
  final List<IconData> _categoryIcons = const [Icons.park, Icons.history_edu, Icons.hotel];
  final List<Color> _categoryColors = const [Colors.green, Colors.purple, Colors.orange];

  final List<ExploreSection> _sections = const [
    ExploreSection(
      title: 'Lush Nature',
      category: 'Nature',
      categoryTitle: 'Nature Attractions',
    ),
    ExploreSection(
      title: 'Historical Wonders',
      category: 'Historical',
      categoryTitle: 'Historical Attractions',
    ),
    ExploreSection(
      title: 'Coastal Retreats',
      category: 'Hotels',
      categoryTitle: 'Hotels',
    ),
  ];

  List<Attraction> get _filtered {
    if (_searchQuery.isEmpty) return [];
    return sampleAttractions
        .where((a) =>
            a.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            a.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
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
      appBar: AppBar(
        title: const Text('Explore Sri Lanka',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: _searchQuery.isNotEmpty
            ? [
                IconButton(
                  icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                  tooltip: 'Toggle View',
                  onPressed: () => setState(() => _isGridView = !_isGridView),
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          // Search Bar (Reuses design, prefix/suffix icons, borders from HomeScreen)
          Container(
            color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.3),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search attractions...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.teal.shade100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.teal, width: 1.5),
                ),
              ),
            ),
          ),

          // Content Area
          Expanded(
            child: _searchQuery.isNotEmpty
                ? _buildSearchResults()
                : _buildDefaultContent(),
          ),
        ],
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
                style: TextStyle(fontSize: 18, color: Colors.grey[500])),
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            children: [
              Text(
                '${results.length} results for "$_searchQuery"',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isGridView
              ? GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: results.length,
                  itemBuilder: (_, i) =>
                      AttractionCard(attraction: results[i], isGrid: true),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: results.length,
                  itemBuilder: (_, i) =>
                      AttractionCard(attraction: results[i], isGrid: false),
                ),
        ),
      ],
    );
  }

  Widget _buildDefaultContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF004D40), Color(0xFF26A69A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
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
              Text('Explore 9 handpicked attractions\nacross 3 categories',
                  style: TextStyle(color: Colors.white70, height: 1.5)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Category Cards Section
        const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(_categories.length, (ci) {
            final cat = _categories[ci];
            final icon = _categoryIcons[ci];
            final color = _categoryColors[ci];

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryScreen(
                        title: _getCategoryTitle(cat),
                        category: cat,
                        attractionList: sampleAttractions,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: color, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          cat,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),

        // Category sections with functional View All buttons
        ..._sections.map((section) {
          final catAttractions =
              sampleAttractions.where((a) => a.category == section.category).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryScreen(
                            title: section.categoryTitle,
                            category: section.category,
                            attractionList: sampleAttractions,
                          ),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View All',
                          style: TextStyle(
                            color: Color(0xFF00695C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Color(0xFF00695C),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: catAttractions.length,
                  itemBuilder: (_, i) => SizedBox(
                    width: 160,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: AttractionCard(
                          attraction: catAttractions[i], isGrid: true),
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