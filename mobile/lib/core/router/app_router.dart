import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/analyzer/screens/analyzer_screen.dart';
import '../../features/generator/screens/generator_screen.dart';
import '../../features/templates/screens/templates_screen.dart';
import '../../features/threads/screens/threads_screen.dart';
import '../../features/timing/screens/timing_screen.dart';
import '../../features/competitor/screens/competitor_screen.dart';
import '../../features/competitor/screens/competitor_history_screen.dart';
import '../../features/performance/screens/performance_screen.dart';
import '../../features/performance/screens/performance_history_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../widgets/bottom_nav.dart';

class AppRoutes {
  static const splash = '/splash';
  static const home = '/';
  static const analyzer = '/analyzer';
  static const generator = '/generator';
  static const templates = '/templates';
  static const threads = '/threads';
  static const timing = '/timing';
  static const competitor = '/competitor';
  static const competitorHistory = '/competitor/history';
  static const performance = '/performance';
  static const performanceHistory = '/performance/history';
  static const settings = '/settings';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AnalyzerScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.analyzer,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AnalyzerScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.generator,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: GeneratorScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.templates,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TemplatesScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.threads,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ThreadsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.timing,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TimingScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.competitor,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CompetitorScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.performance,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PerformanceScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.competitorHistory,
        builder: (context, state) => const CompetitorHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.performanceHistory,
        builder: (context, state) => const PerformanceHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Sayfa bulunamadı: ${state.matchedLocation}'),
      ),
    ),
  );
});

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final List<String> _routes = [
    AppRoutes.home,
    AppRoutes.generator,
    AppRoutes.templates,
    AppRoutes.threads,
    AppRoutes.timing,
    AppRoutes.competitor,
    AppRoutes.performance,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _getSelectedIndex(context),
        onTap: (index) {
          context.go(_routes[index]);
        },
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    if (location == AppRoutes.home || location == AppRoutes.analyzer) return 0;
    if (location == AppRoutes.generator) return 1;
    if (location == AppRoutes.templates) return 2;
    if (location == AppRoutes.threads) return 3;
    if (location == AppRoutes.timing) return 4;
    if (location == AppRoutes.competitor) return 5;
    if (location == AppRoutes.performance) return 6;

    return 0;
  }
}
