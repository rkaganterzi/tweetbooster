import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/config/app_config.dart';
import '../../analyzer/providers/analyzer_provider.dart';

// Supported locales
const _supportedLocales = ['tr', 'en'];

// Locale provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return LocaleNotifier(storage);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final StorageService _storage;

  LocaleNotifier(this._storage) : super(_getInitialLocale()) {
    _loadLocale();
  }

  /// Get initial locale based on device language
  static Locale _getInitialLocale() {
    try {
      // Get device locale
      final deviceLocale = ui.PlatformDispatcher.instance.locale;
      final languageCode = deviceLocale.languageCode;

      // Check if device language is supported
      if (_supportedLocales.contains(languageCode)) {
        return Locale(languageCode);
      }

      // Fallback to English for unsupported languages
      return const Locale('en');
    } catch (e) {
      // Fallback to English if detection fails
      return const Locale('en');
    }
  }

  void _loadLocale() {
    try {
      final savedLocale = _storage.getLocale();
      if (savedLocale != null && _supportedLocales.contains(savedLocale)) {
        state = Locale(savedLocale);
      }
      // If no saved locale, keep the device-detected locale from constructor
    } catch (e) {
      // Storage not initialized yet, use device locale
      debugPrint('Locale load error: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    try {
      await _storage.setLocale(locale.languageCode);
    } catch (e) {
      debugPrint('Locale save error: $e');
    }
  }
}

// Theme mode provider (for future use)
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark);

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

// Notifications provider
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);

// App version provider
final appVersionProvider = Provider<String>((ref) {
  return AppConfig.appVersion;
});
