import 'package:flutter/material.dart';
import '../models/attraction.dart';
import '../widgets/attraction_card.dart';

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
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: 'Toggle View',
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: Column(
        children: [
          // Count Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Text(
                  '${displayList.length} places found',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          if (displayList.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 70, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text('No attractions found',
                        style: TextStyle(fontSize: 18, color: Colors.grey[500])),
                  ],
                ),
              ),
            )
          else
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
                      itemCount: displayList.length,
                      itemBuilder: (_, i) =>
                          AttractionCard(attraction: displayList[i], isGrid: true),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: displayList.length,
                      itemBuilder: (_, i) =>
                          AttractionCard(attraction: displayList[i], isGrid: false),
                    ),
            ),
        ],
      ),
    );
  }
}
