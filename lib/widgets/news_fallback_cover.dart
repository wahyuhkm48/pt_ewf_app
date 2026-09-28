// widgets/news_fallback_cover.dart
import 'package:flutter/material.dart';

class NewsFallbackCover extends StatelessWidget {
  final String sourceName;
  final String? sourceIcon;
  final double logoSize;

  const NewsFallbackCover({
    super.key,
    required this.sourceName,
    this.sourceIcon,
    this.logoSize = 56,
  });

  Color _brandColor(String source) {
    switch (source.toLowerCase()) {
      case 'bloomberg':
        return const Color(0xFF1A1A1A);
      case 'cnbc':
        return const Color(0xFF0A1E42);
      case 'reuters':
        return const Color(0xFFFF6600);
      default:
        return const Color(0xFF37474F);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _brandColor(sourceName),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (sourceIcon != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                sourceIcon!,
                width: logoSize, height: logoSize, fit: BoxFit.contain,
                errorBuilder: (_, _, _ ) => Icon(Icons.public, color: Colors.white54, size: logoSize * 0.7),
              ),
            )
          else
            Icon(Icons.public, color: Colors.white54, size: logoSize * 0.7),
          const SizedBox(height: 8),
          Text(sourceName,
              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 13, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}