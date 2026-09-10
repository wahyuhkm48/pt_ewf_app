// views/hot_news_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';
import '../models/news_model.dart';
import '../viewmodels/news_viewmodel.dart';
import '../utils/page_transitions.dart';
import 'news_detail_page.dart';

class HotNewsPage extends StatefulWidget {
  final String query;
  const HotNewsPage({super.key, required this.query});

  @override
  State<HotNewsPage> createState() => _HotNewsPageState();
}

class _HotNewsPageState extends State<HotNewsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsViewModel>().loadNews(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NewsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 4),
              const Text('Hot News', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              Expanded(
                child: Builder(builder: (context) {
                  if (vm.isLoading && vm.articles == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (vm.errorMessage != null && vm.articles == null) {
                    return const Center(child: EmptyState(icon: Icons.error_outline_rounded, title: 'Gagal memuat berita'));
                  }
                  final articles = vm.articles ?? [];
                  if (articles.isEmpty) {
                    return const Center(child: EmptyState(icon: Icons.article_outlined, title: 'Belum ada berita'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: articles.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) => _HotNewsCard(article: articles[index]),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HotNewsCard extends StatelessWidget {
  final NewsModel article;
  const _HotNewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageTransitions.heroDetail(NewsDetailPage(article: article))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 220,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'news_image_${article.articleId}',
                child: article.imageUrl != null
                    ? Image.network(
                        article.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.divider,
                          child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textSecondary, size: 40),
                        ),
                      )
                    : Container(color: AppColors.divider, child: const Icon(Icons.image_outlined, color: AppColors.textSecondary, size: 40)),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black87], stops: [0.4, 1.0]),
                ),
              ),
              Positioned(
                left: 16, right: 16, bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    if (article.description != null) ...[
                      const SizedBox(height: 6),
                      Text(article.description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}