import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/chart_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/emas_fisik_screen.dart';
import 'widgets/custom_bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // wajib sebelum await di main()
  await dotenv.load(fileName: ".env");
  runApp(const PivotApp());
}

class PivotApp extends StatelessWidget {
  const PivotApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TextTheme dasar: Inter untuk body, Geist untuk heading & label
    final baseTextTheme = ThemeData.light().textTheme;
    final textTheme = GoogleFonts.interTextTheme(baseTextTheme).copyWith(
      displayLarge: GoogleFonts.geist(textStyle: baseTextTheme.displayLarge),
      displayMedium: GoogleFonts.geist(textStyle: baseTextTheme.displayMedium),
      displaySmall: GoogleFonts.geist(textStyle: baseTextTheme.displaySmall),
      headlineLarge: GoogleFonts.geist(textStyle: baseTextTheme.headlineLarge),
      headlineMedium: GoogleFonts.geist(textStyle: baseTextTheme.headlineMedium),
      headlineSmall: GoogleFonts.geist(textStyle: baseTextTheme.headlineSmall),
      titleLarge: GoogleFonts.geist(textStyle: baseTextTheme.titleLarge),
      titleMedium: GoogleFonts.geist(textStyle: baseTextTheme.titleMedium),
      labelLarge: GoogleFonts.geist(textStyle: baseTextTheme.labelLarge),
      labelMedium: GoogleFonts.geist(textStyle: baseTextTheme.labelMedium),
      labelSmall: GoogleFonts.geist(textStyle: baseTextTheme.labelSmall),
    );

    return MaterialApp(
      title: 'Pivot App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        textTheme: textTheme,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Index nav: 0=Home, 1=History, 2=Chart, 3=Settings
  final List<Widget> _screens = const [
    HomeScreen(),
    HistoryScreen(),
    ChartScreen(),
    SettingsScreen(),
  ];

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  List<SpeedDialAction> get _calculatorActions => [
    SpeedDialAction(
      iconAsset: 'assets/images/icons/pivot_point.png',
      label: 'Segera Hadir',
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fitur ini segera hadir')),
        );
      },
    ),
    SpeedDialAction(
      iconAsset: 'assets/images/icons/emas_fisik.png',
      label: 'Emas Fisik',
      onTap: () {
        debugPrint('🟠 Tombol Emas Fisik ditekan');
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const EmasFisikScreen()),
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Beri ruang kosong di bawah supaya konten screen tidak
          // ketutupan nav bar yang sekarang jadi overlay mengambang
          Padding(
            padding: const EdgeInsets.only(bottom: 90),
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
          // Nav bar sekarang jadi overlay di dalam body, BUKAN di
          // slot bottomNavigationBar — supaya tombol yang "menyembul"
          // ke atas bisa disentuh dengan benar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNav(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
              calculatorActions: _calculatorActions,
            ),
          ),
        ],
      ),
    );
  }
}

