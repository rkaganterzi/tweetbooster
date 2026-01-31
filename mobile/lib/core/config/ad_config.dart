import 'dart:io';

class AdConfig {
  AdConfig._();

  // Test Ad Unit IDs (use these during development)
  static const String _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const String _testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialIos = 'ca-app-pub-3940256099942544/4411468910';

  // Production Ad Unit IDs
  static const String _prodBannerAndroid = 'ca-app-pub-9682546527690102/3722375044';
  static const String _prodBannerIos = 'ca-app-pub-XXXXXXXXXXXXXXXX/BBBBBBBBBB'; // iOS için henüz yok
  static const String _prodInterstitialAndroid = 'ca-app-pub-9682546527690102/1570143980';
  static const String _prodInterstitialIos = 'ca-app-pub-XXXXXXXXXXXXXXXX/DDDDDDDDDD'; // iOS için henüz yok

  // Set to false in production
  static const bool isTestMode = true;

  // Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (isTestMode) {
      return Platform.isAndroid ? _testBannerAndroid : _testBannerIos;
    }
    return Platform.isAndroid ? _prodBannerAndroid : _prodBannerIos;
  }

  // Interstitial Ad Unit ID
  static String get interstitialAdUnitId {
    if (isTestMode) {
      return Platform.isAndroid ? _testInterstitialAndroid : _testInterstitialIos;
    }
    return Platform.isAndroid ? _prodInterstitialAndroid : _prodInterstitialIos;
  }

  // Interstitial frequency (show every N actions)
  static const int interstitialFrequency = 2;
}
