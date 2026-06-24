import 'package:flutter/material.dart';
import '../services/settings_services.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _allNotifications = true;
  bool _newAttractions = true;
  bool _travelTips = false;
  bool _promotions = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = await SettingsServices.getNotifications();
    setState(() {
      _allNotifications = enabled;
      _newAttractions = enabled;
      _loading = false;
    });
  }

  Future<void> _saveAll(bool value) async {
    await SettingsServices.setNotifications(value);
    setState(() {
      _allNotifications = value;
      if (!value) {
        _newAttractions = false;
        _travelTips = false;
        _promotions = false;
      } else {
        _newAttractions = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SectionHeader('Push Notifications'),
                _ToggleTile(
                  icon: Icons.notifications_active,
                  iconColor: Colors.teal,
                  title: 'All Notifications',
                  subtitle: 'Enable or disable all notifications',
                  value: _allNotifications,
                  onChanged: _saveAll,
                ),
                const Divider(height: 32),

                _SectionHeader('Notification Types'),
                _ToggleTile(
                  icon: Icons.place,
                  iconColor: Colors.blue,
                  title: 'New Attractions',
                  subtitle: 'Get notified about new places',
                  value: _newAttractions && _allNotifications,
                  onChanged: _allNotifications
                      ? (v) => setState(() => _newAttractions = v)
                      : null,
                ),
                _ToggleTile(
                  icon: Icons.lightbulb_outline,
                  iconColor: Colors.orange,
                  title: 'Travel Tips',
                  subtitle: 'Weekly travel tips for Sri Lanka',
                  value: _travelTips && _allNotifications,
                  onChanged: _allNotifications
                      ? (v) => setState(() => _travelTips = v)
                      : null,
                ),
                _ToggleTile(
                  icon: Icons.local_offer_outlined,
                  iconColor: Colors.purple,
                  title: 'Promotions',
                  subtitle: 'Special offers and deals',
                  value: _promotions && _allNotifications,
                  onChanged: _allNotifications
                      ? (v) => setState(() => _promotions = v)
                      : null,
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.teal.shade700, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Notification preferences are saved locally on your device.',
                          style: TextStyle(
                              color: Colors.teal.shade700,
                              fontSize: 13,
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D40))),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _ToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: onChanged == null
                            ? Colors.grey
                            : Colors.black)),
                Text(subtitle,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          activeThumbColor: const Color(0xFF00695C),
          activeTrackColor: const Color(0xFF00695C).withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}