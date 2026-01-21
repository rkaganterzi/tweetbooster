import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../analyzer/providers/analyzer_provider.dart';
import '../data/timing_repository.dart';
import '../data/models/timing_recommendation.dart';

// Repository provider
final timingRepositoryProvider = Provider<TimingRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TimingRepository(apiService);
});

// Current timing analysis provider
final currentTimingProvider = FutureProvider<TimingAnalysis>((ref) async {
  final repository = ref.watch(timingRepositoryProvider);
  return repository.getCurrentTiming();
});

// Best times provider
final bestTimesProvider = FutureProvider<List<TimingRecommendation>>((ref) async {
  final repository = ref.watch(timingRepositoryProvider);
  return repository.getBestTimes();
});

// Selected timezone provider
final selectedTimezoneProvider = StateProvider<String>((ref) {
  return 'Europe/Istanbul';
});

// Available timezones
final availableTimezonesProvider = Provider<List<String>>((ref) {
  return [
    'Europe/Istanbul',
    'Europe/London',
    'America/New_York',
    'America/Los_Angeles',
    'Asia/Tokyo',
    'Australia/Sydney',
  ];
});

// Timezone labels
String getTimezoneLabel(String timezone) {
  switch (timezone) {
    case 'Europe/Istanbul':
      return 'İstanbul (GMT+3)';
    case 'Europe/London':
      return 'Londra (GMT+0)';
    case 'America/New_York':
      return 'New York (GMT-5)';
    case 'America/Los_Angeles':
      return 'Los Angeles (GMT-8)';
    case 'Asia/Tokyo':
      return 'Tokyo (GMT+9)';
    case 'Australia/Sydney':
      return 'Sydney (GMT+11)';
    default:
      return timezone;
  }
}
