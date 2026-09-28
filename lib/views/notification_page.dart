import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _enableAll = true;
  bool _priceAlert = true;
  bool _priceIncrease = true;
  bool _priceDecrease = true;
  bool _latestNews = true;

  void _toggleAll(bool value) {
    setState(() {
      _enableAll = value;
      _priceAlert = value;
      _priceIncrease = value;
      _priceDecrease = value;
      _latestNews = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1E6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enable All Notifications',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Receive all notifications from the app',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _enableAll,
                  activeThumbColor: Colors.orange,
                  onChanged: _toggleAll,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Notification Settings',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.orange),
          ),
          const SizedBox(height: 12),
          _NotificationTile(
            icon: Icons.notifications_none_rounded,
            title: 'Price Alert',
            subtitle: 'Get notified when price reach your target',
            value: _priceAlert,
            onChanged: (v) => setState(() => _priceAlert = v),
          ),
          _NotificationTile(
            icon: Icons.trending_up_rounded,
            title: 'Price Increase',
            subtitle: 'Notify when price goes up',
            value: _priceIncrease,
            onChanged: (v) => setState(() => _priceIncrease = v),
          ),
          _NotificationTile(
            icon: Icons.trending_down_rounded,
            title: 'Price Decrease',
            subtitle: 'Notify when price goes down',
            value: _priceDecrease,
            onChanged: (v) => setState(() => _priceDecrease = v),
          ),
          _NotificationTile(
            icon: Icons.article_outlined,
            title: 'Latest News',
            subtitle: 'Get notified about latest news and updates',
            value: _latestNews,
            onChanged: (v) => setState(() => _latestNews = v),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1E6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Switch(value: value, activeThumbColor: Colors.orange, onChanged: onChanged),
        ],
      ),
    );
  }
}