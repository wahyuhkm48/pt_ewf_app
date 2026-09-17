// views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hot_news_page.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';
import '../widgets/market_info_section.dart';
import '../models/news_model.dart';
import '../viewmodels/news_viewmodel.dart';
import '../utils/page_transitions.dart';
import '../viewmodels/auth_viewmodel.dart';

const String kNewsCombinedQuery = 'Federal Reserve OR interest rate';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsViewModel>().loadNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NewsViewModel>();
    final employee = context.watch<AuthViewModel>().employee;
    final namaDepan = (employee?.namaLengkap ?? 'Pengguna').split(' ').first;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hi $namaDepan!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    const Text('Good Morning', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  ],
                ),
                Container(
                  width: 44, height: 44,
                  decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                  child: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Welcome!', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        SizedBox(height: 6),
                        Text("Let's schedule your projects", style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.laptop_mac_rounded, size: 48, color: AppColors.primaryDark),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _SectionHeader(
              title: 'Information',
              onViewAll: () {
                Navigator.of(context).push(PageTransitions.slideRight(const HotNewsPage(query: kNewsCombinedQuery)));
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: Builder(builder: (context) {
                if (vm.isLoading && vm.articles == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (vm.errorMessage != null && vm.articles == null) {
                  return const EmptyState(icon: Icons.error_outline_rounded, title: 'Gagal memuat berita');
                }
                final articles = vm.articles ?? [];
                if (articles.isEmpty) {
                  return const EmptyState(icon: Icons.article_outlined, title: 'Belum ada berita');
                }
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: articles.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => _NewsCard(article: articles[index]),
                );
              }),
            ),
            const SizedBox(height: 24),
            const MarketInfoSection(),
            const SizedBox(height: 24),
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
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        GestureDetector(
          onTap: onViewAll,
          child: const Text('view all', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsModel article;
  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.imageUrl != null)
            Image.network(
              article.imageUrl!,
              height: 80, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 80, color: Colors.white24,
                child: const Icon(Icons.image_not_supported_outlined, color: Colors.white70, size: 24),
              ),
            )
          else
            Container(height: 80, color: Colors.white24, child: const Icon(Icons.image_outlined, color: Colors.white70, size: 24)),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.sourceName, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 4),
                Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}