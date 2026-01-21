class AppConfig {
  AppConfig._();

  static const String appName = 'TweetBoost';
  static const String appVersion = '1.0.0';

  // Default locale
  static const String defaultLocale = 'tr';
  static const List<String> supportedLocales = ['tr', 'en'];

  // Feature flags
  static const bool enableAnalytics = false;
  static const bool enableCrashlytics = false;
}
