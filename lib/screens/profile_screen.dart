import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../services/settings_services.dart';
import 'about_screen.dart';
import 'edit_profile_screen.dart';
import 'notifications_screen.dart';
import 'language_screen.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _profileImagePath;
  String _language = 'English';
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final img = await SettingsServices.getProfileImage();
    final lang = await SettingsServices.getLanguage();
    final notif = await SettingsServices.getNotifications();
    setState(() {
      _profileImagePath = img;
      _language = lang;
      _notifications = notif;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoritesProvider>();
    final savedCount = provider.favorites.length;
    final ratings = provider.ratings;
    final userName =
        provider.currentUser?['fullName'] ?? 'Traveller';
    final userEmail =
        provider.currentUser?['email'] ?? '';
    final imagePath =
        provider.currentUser?['imagePath'] ?? _profileImagePath;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF00695C),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF004D40), Color(0xFF00897B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Profile image
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white,
                          backgroundImage: imagePath != null
                              ? FileImage(File(imagePath))
                              : null,
                          child: imagePath == null
                              ? const Icon(Icons.person,
                                  size: 50, color: Color(0xFF00695C))
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProfileScreen(
                                    currentName: userName,
                                    currentEmail: userEmail,
                                    currentImagePath: imagePath,
                                  ),
                                ),
                              );
                              _loadSettings();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit,
                                  color: Color(0xFF00695C), size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(userName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Text(userEmail.isNotEmpty ? userEmail : '🇱🇰 Sri Lanka',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats ──────────────────────────
                  Row(
                    children: [
                      _StatCard(value: '9', label: 'Visited'),
                      const SizedBox(width: 12),
                      _StatCard(
                          value: '${ratings.length}', label: 'Reviews'),
                      const SizedBox(width: 12),
                      _StatCard(value: '$savedCount', label: 'Saved'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Categories ─────────────────────
                  const Text('Categories',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _CategoryIcon(
                          icon: Icons.terrain,
                          label: 'Mountains',
                          color: Colors.teal),
                      _CategoryIcon(
                          icon: Icons.park,
                          label: 'Forests',
                          color: Colors.green),
                      _CategoryIcon(
                          icon: Icons.beach_access,
                          label: 'Beaches',
                          color: Colors.orange),
                      _CategoryIcon(
                          icon: Icons.temple_buddhist,
                          label: 'Temples',
                          color: Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Travel Summary ──────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF004D40), Color(0xFF00897B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Upcoming Trip',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 4),
                        const Text('Explore Sri Lanka',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(children: const [
                          Icon(Icons.calendar_today,
                              color: Colors.white70, size: 14),
                          SizedBox(width: 6),
                          Text('Plan your next adventure',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Eco Score + Level ───────────────
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.eco,
                          iconColor: Colors.green,
                          title: 'Eco Score',
                          value: '${savedCount * 100} pts',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.explore,
                          iconColor: Colors.purple,
                          title: 'Explorer Level',
                          value: 'Lvl ${ratings.length + 1}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Settings ───────────────────────
                  const Text('Settings',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // Edit Profile
                  _SettingsRow(
                    icon: Icons.person_outline,
                    label: 'Edit Profile',
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(
                            currentName: userName,
                            currentEmail: userEmail,
                            currentImagePath: imagePath,
                          ),
                        ),
                      );
                      _loadSettings();
                    },
                  ),

                  // Notifications
                  _SettingsRow(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    trailing: Switch(
                      value: _notifications,
                      onChanged: (v) async {
                        await SettingsServices.setNotifications(v);
                        setState(() => _notifications = v);
                      },
                      activeThumbColor: const Color(0xFF00695C),
                      activeTrackColor: const Color(0xFF00695C).withValues(alpha: 0.5),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationsScreen()),
                      );
                      _loadSettings();
                    },
                  ),

                  // Language
                  _SettingsRow(
                    icon: Icons.language,
                    label: 'Language',
                    trailing: Text(_language,
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 13)),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LanguageScreen()),
                      );
                      _loadSettings();
                    },
                  ),

                  // About
                  _SettingsRow(
                    icon: Icons.info_outline,
                    label: 'About App',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AboutScreen()),
                    ),
                  ),

                  // Logout
                  const SizedBox(height: 8),
                  _SettingsRow(
                    icon: Icons.logout,
                    label: 'Log Out',
                    isDestructive: true,
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Log Out'),
                          content: const Text(
                              'Are you sure you want to log out?'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: const Text('Log Out',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        context.read<FavoritesProvider>().logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WelcomeScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
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

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00695C))),
            const SizedBox(height: 4),
            Text(label,
                style:
                    TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _CategoryIcon(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(title,
              style:
                  TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final Widget? trailing;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.shade50
                    : Colors.teal.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: isDestructive ? Colors.red : Colors.teal,
                  size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 15,
                      color:
                          isDestructive ? Colors.red : Colors.black,
                      fontWeight: isDestructive
                          ? FontWeight.w600
                          : FontWeight.normal)),
            ),
            if (trailing != null) trailing!,
            if (trailing == null)
              Icon(Icons.chevron_right,
                  color: isDestructive
                      ? Colors.red.shade200
                      : Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}