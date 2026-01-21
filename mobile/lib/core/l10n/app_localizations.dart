import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('tr'),
    Locale('en'),
  ];

  // Strings
  String get appName;
  String get analyzeTab;
  String get generateTab;
  String get templatesTab;
  String get threadsTab;
  String get timingTab;
  String get analyzeButton;
  String get generateButton;
  String get overallScore;
  String get engagementScores;
  String get suggestions;
  String get warnings;
  String get likeability;
  String get replyability;
  String get retweetability;
  String get bookmarkability;
  String get postPlaceholder;
  String characterCount(int count);
  String get settings;
  String get language;
  String get logout;
  String get loginWithGoogle;
  String get bestTimeToPost;
  String get currentScore;
  String get topicHint;
  String get style;
  String get targetEngagement;
  String get copyToClipboard;
  String get copiedToClipboard;
  String get regenerate;
  String get useTemplate;
  String get createThread;
  String get threadPreview;
  String partNumber(int current, int total);
  String get copyAll;
  String get weeklyHeatmap;
  String get bestTimes;
  String get timezone;
  String get noSuggestions;
  String get noWarnings;
  String get loading;
  String get error;
  String get retry;
  String get algorithmSignals;
  String get includeHashtags;
  String get includeEmojis;
  String get welcome;
  String get welcomeSubtitle;
  String get termsAndPrivacy;
  String get notifications;
  String get about;
  String get version;
  String get competitorTab;
  String get performanceTab;
  String get competitorAnalysis;
  String get performanceTracking;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }
  return AppLocalizationsTr();
}

class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr() : super('tr');

  @override
  String get appName => 'TweetBoost';
  @override
  String get analyzeTab => 'Analiz';
  @override
  String get generateTab => 'Oluştur';
  @override
  String get templatesTab => 'Şablonlar';
  @override
  String get threadsTab => 'Thread';
  @override
  String get timingTab => 'Zamanlama';
  @override
  String get analyzeButton => 'Analiz Et';
  @override
  String get generateButton => 'Oluştur';
  @override
  String get overallScore => 'Genel Skor';
  @override
  String get engagementScores => 'Etkileşim Skorları';
  @override
  String get suggestions => 'Öneriler';
  @override
  String get warnings => 'Uyarılar';
  @override
  String get likeability => 'Beğeni Potansiyeli';
  @override
  String get replyability => 'Yanıt Potansiyeli';
  @override
  String get retweetability => 'Retweet Potansiyeli';
  @override
  String get bookmarkability => 'Kaydetme Potansiyeli';
  @override
  String get postPlaceholder => 'Postunuzu buraya yazın...';
  @override
  String characterCount(int count) => '$count karakter';
  @override
  String get settings => 'Ayarlar';
  @override
  String get language => 'Dil';
  @override
  String get logout => 'Çıkış Yap';
  @override
  String get loginWithGoogle => 'Google ile Giriş Yap';
  @override
  String get bestTimeToPost => 'Paylaşım için en iyi zaman';
  @override
  String get currentScore => 'Şu anki skor';
  @override
  String get topicHint => 'Konu veya fikir girin';
  @override
  String get style => 'Stil';
  @override
  String get targetEngagement => 'Hedef Etkileşim';
  @override
  String get copyToClipboard => 'Kopyala';
  @override
  String get copiedToClipboard => 'Panoya kopyalandı';
  @override
  String get regenerate => 'Yeniden Oluştur';
  @override
  String get useTemplate => 'Şablonu Kullan';
  @override
  String get createThread => 'Thread Oluştur';
  @override
  String get threadPreview => 'Thread Önizleme';
  @override
  String partNumber(int current, int total) => 'Parça $current/$total';
  @override
  String get copyAll => 'Tümünü Kopyala';
  @override
  String get weeklyHeatmap => 'Haftalık Isı Haritası';
  @override
  String get bestTimes => 'En İyi Zamanlar';
  @override
  String get timezone => 'Saat Dilimi';
  @override
  String get noSuggestions => 'Öneri yok';
  @override
  String get noWarnings => 'Uyarı yok';
  @override
  String get loading => 'Yükleniyor...';
  @override
  String get error => 'Hata';
  @override
  String get retry => 'Tekrar Dene';
  @override
  String get algorithmSignals => 'Algoritma Sinyalleri';
  @override
  String get includeHashtags => 'Hashtag Ekle';
  @override
  String get includeEmojis => 'Emoji Ekle';
  @override
  String get welcome => 'Hoş Geldiniz';
  @override
  String get welcomeSubtitle => 'X postlarınızı optimize edin';
  @override
  String get termsAndPrivacy =>
      'Devam ederek Kullanım Şartları ve Gizlilik Politikasını kabul etmiş olursunuz.';
  @override
  String get notifications => 'Bildirimler';
  @override
  String get about => 'Hakkında';
  @override
  String get version => 'Versiyon';
  @override
  String get competitorTab => 'Rakip';
  @override
  String get performanceTab => 'Performans';
  @override
  String get competitorAnalysis => 'Rakip Analizi';
  @override
  String get performanceTracking => 'Performans Takibi';
}

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override
  String get appName => 'TweetBoost';
  @override
  String get analyzeTab => 'Analyze';
  @override
  String get generateTab => 'Generate';
  @override
  String get templatesTab => 'Templates';
  @override
  String get threadsTab => 'Threads';
  @override
  String get timingTab => 'Timing';
  @override
  String get analyzeButton => 'Analyze';
  @override
  String get generateButton => 'Generate';
  @override
  String get overallScore => 'Overall Score';
  @override
  String get engagementScores => 'Engagement Scores';
  @override
  String get suggestions => 'Suggestions';
  @override
  String get warnings => 'Warnings';
  @override
  String get likeability => 'Likeability';
  @override
  String get replyability => 'Replyability';
  @override
  String get retweetability => 'Retweetability';
  @override
  String get bookmarkability => 'Bookmarkability';
  @override
  String get postPlaceholder => 'Write your post here...';
  @override
  String characterCount(int count) => '$count characters';
  @override
  String get settings => 'Settings';
  @override
  String get language => 'Language';
  @override
  String get logout => 'Logout';
  @override
  String get loginWithGoogle => 'Sign in with Google';
  @override
  String get bestTimeToPost => 'Best time to post';
  @override
  String get currentScore => 'Current score';
  @override
  String get topicHint => 'Enter topic or idea';
  @override
  String get style => 'Style';
  @override
  String get targetEngagement => 'Target Engagement';
  @override
  String get copyToClipboard => 'Copy';
  @override
  String get copiedToClipboard => 'Copied to clipboard';
  @override
  String get regenerate => 'Regenerate';
  @override
  String get useTemplate => 'Use Template';
  @override
  String get createThread => 'Create Thread';
  @override
  String get threadPreview => 'Thread Preview';
  @override
  String partNumber(int current, int total) => 'Part $current/$total';
  @override
  String get copyAll => 'Copy All';
  @override
  String get weeklyHeatmap => 'Weekly Heatmap';
  @override
  String get bestTimes => 'Best Times';
  @override
  String get timezone => 'Timezone';
  @override
  String get noSuggestions => 'No suggestions';
  @override
  String get noWarnings => 'No warnings';
  @override
  String get loading => 'Loading...';
  @override
  String get error => 'Error';
  @override
  String get retry => 'Retry';
  @override
  String get algorithmSignals => 'Algorithm Signals';
  @override
  String get includeHashtags => 'Include Hashtags';
  @override
  String get includeEmojis => 'Include Emojis';
  @override
  String get welcome => 'Welcome';
  @override
  String get welcomeSubtitle => 'Optimize your X posts';
  @override
  String get termsAndPrivacy =>
      'By continuing, you agree to our Terms of Service and Privacy Policy.';
  @override
  String get notifications => 'Notifications';
  @override
  String get about => 'About';
  @override
  String get version => 'Version';
  @override
  String get competitorTab => 'Competitor';
  @override
  String get performanceTab => 'Performance';
  @override
  String get competitorAnalysis => 'Competitor Analysis';
  @override
  String get performanceTracking => 'Performance Tracking';
}
