import 'package:flutter/material.dart';
import '../models/attraction.dart';
import '../widgets/place_card.dart'; 

class CategoryScreen extends StatefulWidget {
  final String title;
  final String category;
  final List<Attraction> attractionList;

  const CategoryScreen({
    super.key,
    required this.title,
    required this.category,
    required this.attractionList,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    // Ensure we only display attractions matching the selected category
    final displayList = widget.attractionList
        .where((a) => a.category.toLowerCase() == widget.category.toLowerCase())
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F0), 
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF5FE4C1), // Seamlessly flows down into the container gradient
        foregroundColor: const Color(0xFF1A1A1A),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: 'Toggle View',
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5FE4C1), // High deeper accent teal finish tint 
              Color(0xFFF8F6F0), // Low flat cream body structure tone
            ],
            stops: [0.0, 0.25], // Fades nicely within top header portion bounds
          ),
        ),
        child: Column(
          children: [
           
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text(
                    '${displayList.length} places found in this category',
                    style: const TextStyle(
                      color: Color(0xFF555555), 
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ── Content Layout ────────────────────────────
            Expanded(
              child: displayList.isEmpty
                  ? _buildEmptyState()
                  : _isGridView
                      ? _buildGridView(displayList)
                      : _buildListView(displayList),
            ),
          ],
        ),
      ),
    );
  }

 
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off, size: 60, color: Colors.teal.shade200),
          ),
          const SizedBox(height: 24),
          const Text(
            'No attractions found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // Clean uniform grid mapping incorporating PlaceCard details 
  Widget _buildGridView(List<Attraction> displayList) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75, 
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: displayList.length,
      itemBuilder: (_, i) => PlaceCard(
        attraction: displayList[i],
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  // Alternative structured item layout tracking option
  Widget _buildListView(List<Attraction> displayList) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: displayList.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SizedBox(
          height: 140, // Uniform fixed baseline row bounds setup
          child: PlaceCard(
            attraction: displayList[i],
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}