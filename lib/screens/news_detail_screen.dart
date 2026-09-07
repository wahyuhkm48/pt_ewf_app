import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/news_article.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final creatorName = (article.creator != null && article.creator!.isNotEmpty)
        ? article.creator!.join(', ')
        : article.sourceName;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar hero + tombol back + judul overlay
            Stack(
              children: [
                // Hero widget — tag-nya HARUS SAMA PERSIS dengan yang di card list
                Hero(
                  tag: 'news_image_${article.articleId}',
                  child: SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: article.imageUrl != null
                        ? Image.network(
                            article.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.divider,
                              child: const Icon(Icons.image_not_supported_outlined,
                                  color: AppColors.textSecondary, size: 48),
                            ),
                          )
                        : Container(
                            color: AppColors.divider,
                            child: const Icon(Icons.image_outlined,
                                color: AppColors.textSecondary, size: 48),
                          ),
                  ),
                ),
                // Gradient gelap di bawah, biar judul putih tetap terbaca
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 160,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ),
                // Tombol back
                Positioned(
                  top: 50,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black26,
                    ),
                  ),
                ),
                // Judul overlay di bawah gambar
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),

            // Info creator/sumber berita
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.divider,
                    child: Text(
                      creatorName.isNotEmpty ? creatorName[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        creatorName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Text(
                        'Creator',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Isi/deskripsi berita
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Text(
                article.description ?? 'Tidak ada deskripsi tersedia untuk berita ini.',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}