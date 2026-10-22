// views/home_screen.dart
import 'dart:async';
import 'dart:math' show Random;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hot_news_page.dart';
import 'news_detail_page.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/empty_state.dart';
import '../widgets/recent_history_section.dart';
import '../models/news_model.dart';
import '../viewmodels/news_viewmodel.dart';
import '../viewmodels/recent_history_viewmodel.dart';
import '../utils/greeting.dart';
import '../utils/page_transitions.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/news_fallback_cover.dart';

const String kNewsCombinedQuery = 'Federal Reserve OR interest rate';

class HomePage extends StatefulWidget {
  /// Dipanggil saat "view all" di Riwayat Terbaru ditekan (pindah ke tab History).
  final VoidCallback? onViewAllHistory;
  const HomePage({super.key, this.onViewAllHistory});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _greeting = greetingWib();
  Timer? _greetingTimer;

  @override
  void initState() {
    super.initState();
    // Cek tiap menit; rebuild hanya kalau sapaan benar-benar berganti
    // (mis. app dibiarkan terbuka melewati jam 11.00)
    _greetingTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      final baru = greetingWib();
      if (mounted && baru != _greeting) setState(() => _greeting = baru);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsViewModel>().loadNews();
      context.read<RecentHistoryViewModel>().load();
    });
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<NewsViewModel>().loadNews(forceRefresh: true),
      context.read<RecentHistoryViewModel>().load(silent: true),
    ]);
  }

  @override                   
  void dispose() {
    _greetingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NewsViewModel>();
    final employee = context.watch<AuthViewModel>().employee;
    final namaDepan = (employee?.namaLengkap ?? 'Pengguna').split(' ').first;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                      Text('Hi $namaDepan!', style: AppTextStyles.h2()),
                      const SizedBox(height: 2),
                      Text(_greeting, style: AppTextStyles.bodyMd()),
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
              const _WelcomeCard(),
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
              RecentHistorySection(onViewAll: widget.onViewAllHistory),
              const SizedBox(height: 24),
            ],
          ),
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
        Text(title, style: AppTextStyles.labelLg()),
        GestureDetector(
          onTap: onViewAll,
          child: Text('view all', style: AppTextStyles.labelMd(color: AppColors.primary)),
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
    final heroTag = 'home_news_image_${article.articleId}';

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageTransitions.heroDetail(NewsDetailPage(article: article, heroTag: heroTag)),
      ),
      child: Container(
        width: 280,
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80, width: double.infinity,
              child: Hero(
                tag: heroTag,
                child: article.imageUrl != null
                    ? Image.network(
                        article.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            NewsFallbackCover(sourceName: article.sourceName, sourceIcon: article.sourceIcon, logoSize: 32),
                      )
                    : NewsFallbackCover(sourceName: article.sourceName, sourceIcon: article.sourceIcon, logoSize: 32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.sourceName, style: AppTextStyles.micro(color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelMd(color: Colors.white),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatefulWidget {
  const _WelcomeCard();

  @override
  State<_WelcomeCard> createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<_WelcomeCard> {
  // (ikon, judul, isi). Tambah atau ubah pesan di sini.
  static const _messages = <(IconData, String, String)>[
    (Icons.waving_hand_rounded, 'Selamat datang!', 'Pantau pasar dan hitung peluangmu dengan lebih tenang.'),
    (Icons.calculate_outlined, 'Siap menghitung?', 'Coba Pivot Point untuk melihat level support dan resistance.'),
    (Icons.show_chart_rounded, 'Pantau grafik', 'Lihat Gold, Nikkei, dan Hang Seng di menu Chart.'),
    (Icons.savings_outlined, 'Hitung emas fisik', 'Cek selisih harga dan estimasi keuntunganmu.'),
    (Icons.insights_rounded, 'Sinyal harian', 'Bandingkan Close kemarin dan Open hari ini lewat Nest.'),
    (Icons.newspaper_rounded, 'Kabar terbaru', 'Baca berita pasar dari Bloomberg, CNBC, dan Reuters.'),
    (Icons.history_rounded, 'Riwayat tersimpan', 'Lihat kembali hasil perhitunganmu di menu History.'),
  ];

  late int _index = Random().nextInt(_messages.length);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % _messages.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = _messages[_index];

    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      constraints: const BoxConstraints(minHeight: 104),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Row(
          key: ValueKey(_index),
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.$2, style: AppTextStyles.labelLg()),
                  const SizedBox(height: 6),
                  Text(m.$3, style: AppTextStyles.bodySm(color: AppColors.textPrimary)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(m.$1, size: 48, color: AppColors.primaryDark),
          ],
        ),
      ),
    );
  }
}