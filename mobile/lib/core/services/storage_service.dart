import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _localeKey = 'locale';
  static const String _themeKey = 'theme';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _historyBoxName = 'analysis_history';
  static const String _draftsBoxName = 'drafts';

  /// Maximum number of history items to keep
  static const int _maxHistoryItems = 50;

  static StorageService? _instance;
  static StorageService get instance {
    if (_instance == null) {
      throw StateError('StorageService not initialized. Call StorageService.initialize() first.');
    }
    return _instance!;
  }

  SharedPreferences? _prefs;
  Box<String>? _historyBox;
  Box<String>? _draftsBox;

  StorageService._();

  static Future<StorageService> initialize() async {
    if (_instance != null) return _instance!;

    final service = StorageService._();
    service._prefs = await SharedPreferences.getInstance();

    // Initialize Hive
    await Hive.initFlutter();
    service._historyBox = await Hive.openBox<String>(_historyBoxName);
    service._draftsBox = await Hive.openBox<String>(_draftsBoxName);

    _instance = service;
    return service;
  }

  // Locale
  String? getLocale() => _prefs?.getString(_localeKey);

  Future<void> setLocale(String locale) async {
    await _prefs?.setString(_localeKey, locale);
  }

  // Theme
  String? getTheme() => _prefs?.getString(_themeKey);

  Future<void> setTheme(String theme) async {
    await _prefs?.setString(_themeKey, theme);
  }

  // Onboarding
  bool isOnboardingCompleted() =>
      _prefs?.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingCompleted() async {
    await _prefs?.setBool(_onboardingKey, true);
  }

  // Analysis History (using Hive for larger data)
  List<Map<String, dynamic>> getAnalysisHistory() {
    try {
      final values = _historyBox?.values.toList() ?? [];
      return values
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList()
          .reversed
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addAnalysisHistory(Map<String, dynamic> analysis) async {
    if (_historyBox == null) return;

    final key = DateTime.now().millisecondsSinceEpoch.toString();
    await _historyBox!.put(key, jsonEncode(analysis));

    // Keep only last N items
    if (_historyBox!.length > _maxHistoryItems) {
      final keysToDelete = _historyBox!.keys.take(_historyBox!.length - _maxHistoryItems);
      for (final key in keysToDelete) {
        await _historyBox!.delete(key);
      }
    }
  }

  Future<void> clearAnalysisHistory() async {
    await _historyBox?.clear();
  }

  // Drafts
  List<Map<String, dynamic>> getDrafts() {
    try {
      final values = _draftsBox?.values.toList() ?? [];
      return values
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList()
          .reversed
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveDraft(Map<String, dynamic> draft) async {
    if (_draftsBox == null) return;

    final key = draft['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
    await _draftsBox!.put(key, jsonEncode(draft));
  }

  Future<void> deleteDraft(String id) async {
    await _draftsBox?.delete(id);
  }

  Future<void> clearDrafts() async {
    await _draftsBox?.clear();
  }

  // Generic key-value storage
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  String? getString(String key) => _prefs?.getString(key);

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  bool? getBool(String key) => _prefs?.getBool(key);

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  int? getInt(String key) => _prefs?.getInt(key);

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
    await _historyBox?.clear();
    await _draftsBox?.clear();
  }

  /// Dispose and close all resources
  Future<void> dispose() async {
    await _historyBox?.close();
    await _draftsBox?.close();
    _instance = null;
  }
}
