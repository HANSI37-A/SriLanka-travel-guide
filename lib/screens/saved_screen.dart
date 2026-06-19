import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/attraction_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesProvider>().favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Places',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: favs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50, shape: BoxShape.circle),
                    child: Icon(Icons.bookmark_outline,
                        size: 60, color: Colors.red.shade200),
                  ),
                  const SizedBox(height: 24),
                  const Text('No saved places yet!',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Tap ♥ on any attraction to save it.',
                      style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  color: Colors.teal.shade50,
                  child: Text(
                    '❤️  ${favs.length} saved place${favs.length == 1 ? '' : 's'}',
                    style: TextStyle(
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: favs.length,
                    itemBuilder: (_, i) =>
                        AttractionCard(attraction: favs[i], isGrid: true),
                  ),
                ),
              ],
            ),
    );
  }
}