import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  static AdService get instance => _instance;

  AdService._internal();

  bool _isInitialized = false;
  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 0;
  int _actionCount = 0;
  static const int _maxLoadAttempts = 3;

  bool get isInitialized => _isInitialized;

  /// Initialize the Mobile Ads SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('[AdService] MobileAds SDK initialized');

      // Pre-load interstitial ad
      _loadInterstitialAd();
    } catch (e) {
      debugPrint('[AdService] Failed to initialize: $e');
    }
  }

  /// Load an interstitial ad
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
          debugPrint('[AdService] Interstitial ad loaded');

          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('[AdService] Interstitial failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] Interstitial failed to load: $error');
          _interstitialAd = null;
          _interstitialLoadAttempts++;

          if (_interstitialLoadAttempts < _maxLoadAttempts) {
            Future.delayed(const Duration(seconds: 3), _loadInterstitialAd);
          }
        },
      ),
    );
  }

  /// Record an action and potentially show interstitial
  Future<bool> recordActionAndMaybeShowInterstitial() async {
    _actionCount++;

    if (_actionCount >= AdConfig.interstitialFrequency) {
      _actionCount = 0;
      return await showInterstitialAd();
    }

    return false;
  }

  /// Show interstitial ad if available
  Future<bool> showInterstitialAd() async {
    if (_interstitialAd == null) {
      debugPrint('[AdService] Interstitial not ready');
      return false;
    }

    try {
      await _interstitialAd!.show();
      return true;
    } catch (e) {
      debugPrint('[AdService] Failed to show interstitial: $e');
      return false;
    }
  }

  /// Create a banner ad
  BannerAd createBannerAd({
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (ad) => debugPrint('[AdService] Banner ad opened'),
        onAdClosed: (ad) => debugPrint('[AdService] Banner ad closed'),
      ),
    );
  }

  /// Dispose resources
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
