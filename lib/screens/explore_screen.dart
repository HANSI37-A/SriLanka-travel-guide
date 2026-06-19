import 'package:flutter/material.dart';
import '../data/attractions_data.dart';
import '../widgets/attraction_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['Historical', 'Nature', 'Hotels'];
    final icons = [Icons.history_edu, Icons.park, Icons.hotel];
    final colors = [Colors.purple, Colors.green, Colors.orange];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Sri Lanka',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
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

          // Category sections
          ...List.generate(categories.length, (ci) {
            final cat = categories[ci];
            final catAttractions =
                sampleAttractions.where((a) => a.category == cat).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors[ci].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icons[ci], color: colors[ci], size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(cat,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('${catAttractions.length} places',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13)),
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
      ),
    );
  }
}