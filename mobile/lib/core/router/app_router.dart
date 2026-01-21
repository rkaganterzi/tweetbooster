import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/analyzer/screens/analyzer_screen.dart';
import '../../features/generator/screens/generator_screen.dart';
import '../../features/templates/screens/templates_screen.dart';
import '../../features/threads/screens/threads_screen.dart';
import '../../features/timing/screens/timing_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../widgets/bottom_nav.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/';
  static const analyzer = '/analyzer';
  static const generator = '/generator';
  static const templates = '/templates';
  static const threads = '/threads';
  static const timing = '/timing';
  static const settings = '/settings';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);
  final authState = ref.watch(authStateProvider);
  final isFirebaseAvailable = authService.isFirebaseAvailable;

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isSplash = state.matchedLocation == AppRoutes.splash;

      // If Firebase is not available, skip auth and go directly to home
      if (!isFirebaseAvailable) {
        if (isSplash || isLoggingIn) return AppRoutes.home;
        return null;
      }

      return authState.when(
        data: (user) {
          if (user == null) {
            // Not logged in
            if (isLoggingIn || isSplash) return null;
            return AppRoutes.login;
          } else {
            // Logged in
            if (isLoggingIn || isSplash) return AppRoutes.home;
            return null;
          }
        },
        loading: () => isSplash ? null : AppRoutes.splash,
        error: (_, __) => AppRoutes.login,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
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
        ],
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

    return 0;
  }
}
