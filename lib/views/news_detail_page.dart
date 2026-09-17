// views/news_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../models/news_model.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsModel article;
  const NewsDetailPage({super.key, required this.article});

  Future<void> _bukaSumberAsli(BuildContext context) async {
    final url = article.linkUrl;
    if (url == null || url.isEmpty) return;

    final uri = Uri.tryParse(url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak bisa membuka link sumber.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'news_image_${article.articleId}',
                  child: SizedBox(
                    height: 400, width: double.infinity,
                    child: article.imageUrl != null
                        ? Image.network(
                            article.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.divider,
                              child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textSecondary, size: 48),
                            ),
                          )
                        : Container(color: AppColors.divider, child: const Icon(Icons.image_outlined, color: AppColors.textSecondary, size: 48)),
                  ),
                ),
                Positioned(
                  left: 0, right: 0, bottom: 0,
                  child: Container(
                    height: 160,
                    decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black87])),
                  ),
                ),
                Positioned(
                  top: 50, left: 16,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    style: IconButton.styleFrom(backgroundColor: Colors.black26),
                  ),
                ),
                Positioned(
                  left: 20, right: 20, bottom: 20,
                  child: Text(article.title, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 1.2)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26, backgroundColor: AppColors.divider,
                    child: Text(article.sourceName.isNotEmpty ? article.sourceName[0].toUpperCase() : '?',
                        style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(article.sourceName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        Text(article.pubDate != null ? _formatTanggal(article.pubDate!) : 'Sumber berita',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(article.description ?? 'Tidak ada deskripsi tersedia untuk berita ini.',
                  style: const TextStyle(fontSize: 16, height: 1.5, color: AppColors.textPrimary)),
            ),
            if (article.linkUrl != null && article.linkUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _bukaSumberAsli(context),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: Text('Baca Selengkapnya di ${article.sourceName}'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.primary),
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTanggal(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}