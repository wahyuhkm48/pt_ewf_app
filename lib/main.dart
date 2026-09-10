import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api_client.dart';
import 'services/auth_service.dart';
import 'services/pivot_point_service.dart';
import 'services/emas_fisik_service.dart';
import 'services/histori_service.dart';
import 'services/news_service.dart';
import 'services/market_data_service.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/pivot_point_viewmodel.dart';
import 'viewmodels/emas_fisik_viewmodel.dart';
import 'viewmodels/histori_viewmodel.dart';
import 'viewmodels/news_viewmodel.dart';
import 'views/login_page.dart';

void main() {
  final apiClient = ApiClient();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => apiClient),
        ChangeNotifierProvider(create: (_) => AuthViewModel(AuthService(apiClient))),
        ChangeNotifierProvider(create: (_) => PivotPointViewModel(PivotPointService(apiClient))),
        ChangeNotifierProvider(create: (_) => EmasFisikViewModel(EmasFisikService(apiClient), MarketDataService(apiClient))),
        ChangeNotifierProvider(create: (_) => HistoriViewModel(HistoriService(apiClient))),
        ChangeNotifierProvider(create: (_) => NewsViewModel(NewsService(apiClient))),
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
      home: const LoginPage(),
    );
  }
}