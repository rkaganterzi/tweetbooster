import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ad_service.dart';

// AdService provider
final adServiceProvider = Provider<AdService>((ref) {
  return AdService.instance;
});

// Ad initialization state
final adInitializedProvider = StateProvider<bool>((ref) => false);

// Action counter for interstitial ads
class AdController extends StateNotifier<int> {
  final AdService _adService;

  AdController(this._adService) : super(0);

  /// Record an action (e.g., analyze, generate) and show interstitial if threshold reached
  Future<void> recordAction() async {
    state++;
    await _adService.recordActionAndMaybeShowInterstitial();
  }

  /// Force show interstitial (e.g., after specific events)
  Future<void> showInterstitial() async {
    await _adService.showInterstitialAd();
  }

  /// Reset action counter
  void resetCounter() {
    state = 0;
  }
}

final adControllerProvider = StateNotifierProvider<AdController, int>((ref) {
  final adService = ref.watch(adServiceProvider);
  return AdController(adService);
});
