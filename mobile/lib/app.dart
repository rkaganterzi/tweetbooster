import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/config/theme_config.dart';
import 'core/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'features/settings/providers/settings_provider.dart';

class TweetBoostApp extends ConsumerWidget {
  const TweetBoostApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'TweetBoost',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.darkTheme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
      ],
      routerConfig: router,
    );
  }
}
