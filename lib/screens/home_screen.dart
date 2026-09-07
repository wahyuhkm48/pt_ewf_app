import 'package:flutter/material.dart';
import 'hot_news_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';
import '../models/news_article.dart';
import '../services/news_repository.dart';
import '../utils/page_transitions.dart';


const String kNewsCombinedQuery = 'Federal Reserve OR interest rate';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    NewsRepository.instance.loadNews(kNewsCombinedQuery); // cache-aware, aman dipanggil berkali-kali
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header sapaan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi Alex!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Good Morning',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_none_rounded,
                      color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Banner welcome
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Welcome!',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Let's schedule your projects",
                          style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.laptop_mac_rounded, size: 48, color: AppColors.primaryDark),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Information — SEKARANG DARI API
            _SectionHeader(
              title: 'Information',
              onViewAll: () {
                Navigator.of(context).push(
                  PageTransitions.slideRight(HotNewsScreen(query: kNewsCombinedQuery)), // pakai yang baru
                );
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListenableBuilder(
                listenable: NewsRepository.instance,
                builder: (context, _) {
                  final repo = NewsRepository.instance;

                  if (repo.isLoading && repo.articles == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (repo.error != null && repo.articles == null) {
                    return const EmptyState(
                      icon: Icons.error_outline_rounded,
                      title: 'Gagal memuat berita',
                    );
                  }
                  final articles = repo.articles ?? [];
                  if (articles.isEmpty) {
                    return const EmptyState(
                      icon: Icons.article_outlined,
                      title: 'Belum ada berita',
                    );
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: articles.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => _NewsCard(article: articles[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: const Text(
            'view all',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsArticle article;
  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias, // supaya gambar ikut kepotong sesuai border radius
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar berita (kalau ada)
          if (article.imageUrl != null)
            Image.network(
              article.imageUrl!,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
              // Kalau gambar gagal dimuat (link rusak/expired), jangan crash,
              // tampilkan area kosong biasa saja
              errorBuilder: (context, error, stackTrace) => Container(
                height: 80,
                color: Colors.white24,
                child: const Icon(Icons.image_not_supported_outlined,
                    color: Colors.white70, size: 24),
              ),
            )
          else
            Container(
              height: 80,
              color: Colors.white24,
              child: const Icon(Icons.image_outlined, color: Colors.white70, size: 24),
            ),

          // Teks (sourceName + title)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.sourceName,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 4), 
                Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
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