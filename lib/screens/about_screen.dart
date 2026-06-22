import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF004D40),
                      Color(0xFF00796B),
                      Color(0xFF26A69A),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.travel_explore,
                        size: 55,
                        color: Color(0xFF00796B),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Local Travel Guide',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Version 1.0.0',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About the app
                  _SectionTitle(title: 'About the App'),
                  const SizedBox(height: 10),
                  _InfoCard(
                    child: const Text(
                      'Local Travel Guide is your ultimate companion for exploring the beautiful island of Sri Lanka. '
                      'Discover historical landmarks, natural wonders, and top-rated hotels — all in one place. '
                      'Save your favourites, rate attractions, and navigate directly to any destination.',
                      style: TextStyle(height: 1.7, fontSize: 15, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Features
                  _SectionTitle(title: 'Features'),
                  const SizedBox(height: 10),
                  _InfoCard(
                    child: Column(
                      children: const [
                        _FeatureRow(icon: Icons.grid_view, color: Colors.teal,
                            text: 'Browse attractions in Grid or List view'),
                        _FeatureRow(icon: Icons.filter_list, color: Colors.blue,
                            text: 'Filter by Hotels, Nature & Historical'),
                        _FeatureRow(icon: Icons.search, color: Colors.purple,
                            text: 'Search attractions instantly'),
                        _FeatureRow(icon: Icons.favorite, color: Colors.red,
                            text: 'Save favourites with SQLite persistence'),
                        _FeatureRow(icon: Icons.star, color: Colors.amber,
                            text: 'Rate attractions out of 5 stars'),
                        _FeatureRow(icon: Icons.my_location, color: Colors.green,
                            text: 'GPS distance calculation from your location'),
                        _FeatureRow(icon: Icons.navigation, color: Colors.orange,
                            text: 'Navigate via Google Maps'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Developer Info
                  _SectionTitle(title: 'Developer'),
                  const SizedBox(height: 10),
                  _InfoCard(
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.person,
                          label: 'Name',
                          value: 'Hansi Tharaki',
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                          icon: Icons.badge,
                          label: 'Student ID',
                          value: 'SE/2022/004',
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                          icon: Icons.school,
                          label: 'Course',
                          value: 'SENG 31323',
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                          icon: Icons.apartment,
                          label: 'University',
                          value: 'University of Kelaniya',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tech Stack
                  _SectionTitle(title: 'Built With'),
                  const SizedBox(height: 10),
                  _InfoCard(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _TechChip(label: 'Flutter', icon: Icons.flutter_dash),
                        _TechChip(label: 'Dart', icon: Icons.code),
                        _TechChip(label: 'SQLite', icon: Icons.storage),
                        _TechChip(label: 'Provider', icon: Icons.hub),
                        _TechChip(label: 'Geolocator', icon: Icons.gps_fixed),
                        _TechChip(label: 'Google Maps', icon: Icons.map),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Attractions covered
                  _SectionTitle(title: 'Attractions Covered'),
                  const SizedBox(height: 10),
                  _InfoCard(
                    child: Column(
                      children: const [
                        _DetailRow(icon: Icons.history_edu, label: 'Historical', value: '3 places'),
                        Divider(height: 20),
                        _DetailRow(icon: Icons.park, label: 'Nature', value: '3 places'),
                        Divider(height: 20),
                        _DetailRow(icon: Icons.hotel, label: 'Hotels', value: '3 places'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Footer
                  Center(
                    child: Text(
                      '© 2026 Local Travel Guide\nMade with heart for Sri Lanka 🇱🇰',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ),
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

// ── Helper Widgets ──────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 20,
            decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _FeatureRow(
      {required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 14, height: 1.4))),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 20),
        const SizedBox(width: 12),
        Text(label,
            style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _TechChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.teal),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
        ],
      ),
    );
  }
}