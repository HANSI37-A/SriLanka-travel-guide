import 'package:flutter/material.dart';

class RatingDialog extends StatefulWidget {
  final double currentRating;
  final String attractionName;

  const RatingDialog({
    super.key,
    required this.currentRating,
    required this.attractionName,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late double _selectedRating;

  final List<String> _labels = [
    '',
    'Poor',
    'Fair',
    'Good',
    'Very Good',
    'Excellent',
  ];

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.currentRating;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Rate this place',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              widget.attractionName,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final starValue = i + 1.0;
                final isSelected = _selectedRating >= starValue;
                
                return IconButton(
                  iconSize: 36, 
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact, // Condenses material padding blocks safely
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isSelected ? Colors.amber : Colors.grey[300],
                  ),
                  onPressed: () => setState(() => _selectedRating = starValue),
                );
              }),
            ),
            const SizedBox(height: 12),

            // Context label string tracking display logic
            Text(
              _selectedRating > 0
                  ? _labels[_selectedRating.toInt()]
                  : 'Tap a star to rate',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _selectedRating > 0 ? Colors.amber[700] : Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),

            // Action Control Strip 
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, null),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedRating > 0
                        ? () => Navigator.pop(context, _selectedRating)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}