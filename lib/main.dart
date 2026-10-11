import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/api_client.dart';
import 'services/auth_service.dart';
import 'services/pivot_point_service.dart';
import 'services/emas_fisik_service.dart';
import 'services/histori_service.dart';
import 'services/news_service.dart';
import 'services/market_data_service.dart';
import 'theme/app_colors.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/pivot_point_viewmodel.dart';
import 'viewmodels/emas_fisik_viewmodel.dart';
import 'viewmodels/histori_viewmodel.dart';
import 'viewmodels/news_viewmodel.dart';
import 'services/nest_service.dart';
import 'viewmodels/nest_viewmodel.dart';
import 'views/splash_page.dart';
import 'viewmodels/recent_history_viewmodel.dart';

void main() {
  final apiClient = ApiClient();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => apiClient),
        ChangeNotifierProvider(create: (_) => AuthViewModel(AuthService(apiClient))),
        ChangeNotifierProvider(create: (_) => PivotPointViewModel(PivotPointService(apiClient))),
        ChangeNotifierProvider(create: (_) => NestViewModel(NestService(apiClient))),
        ChangeNotifierProvider(create: (_) => EmasFisikViewModel(EmasFisikService(apiClient), MarketDataService(apiClient))),
        ChangeNotifierProvider(create: (_) => HistoriViewModel(HistoriService(apiClient))),
        ChangeNotifierProvider(create: (_) => NewsViewModel(NewsService(apiClient))),
        ChangeNotifierProvider(create: (_) => RecentHistoryViewModel(PivotPointService(apiClient),NestService(apiClient),EmasFisikService(apiClient),),),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EquityWorld',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        dividerColor: AppColors.divider,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          error: AppColors.danger,
          surface: AppColors.background,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
      ),
      home: const SplashPage(),
    );
  }
}