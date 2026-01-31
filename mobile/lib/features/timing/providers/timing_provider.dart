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

// Selected timezone provider - auto-detect from device
final selectedTimezoneProvider = StateProvider<String>((ref) {
  return _detectTimezone();
});

/// Detect timezone based on device UTC offset
String _detectTimezone() {
  final offset = DateTime.now().timeZoneOffset;
  final hours = offset.inHours;

  // Map UTC offset to common timezones
  switch (hours) {
    case 3:
      return 'Europe/Istanbul';
    case 0:
      return 'Europe/London';
    case -5:
      return 'America/New_York';
    case -8:
      return 'America/Los_Angeles';
    case 9:
      return 'Asia/Tokyo';
    case 10:
    case 11:
      return 'Australia/Sydney';
    case 1:
      return 'Europe/Paris';
    case 2:
      return 'Europe/Berlin';
    case 5:
    case 6:
      return 'Asia/Kolkata';
    case 8:
      return 'Asia/Shanghai';
    default:
      // Fallback to UTC for unknown offsets
      return 'UTC';
  }
}

// Available timezones
final availableTimezonesProvider = Provider<List<String>>((ref) {
  return [
    'UTC',
    'Europe/London',
    'Europe/Paris',
    'Europe/Berlin',
    'Europe/Istanbul',
    'Asia/Kolkata',
    'Asia/Shanghai',
    'Asia/Tokyo',
    'Australia/Sydney',
    'America/New_York',
    'America/Los_Angeles',
  ];
});

// Timezone labels
String getTimezoneLabel(String timezone) {
  switch (timezone) {
    case 'UTC':
      return 'UTC (GMT+0)';
    case 'Europe/London':
      return 'Londra (GMT+0)';
    case 'Europe/Paris':
      return 'Paris (GMT+1)';
    case 'Europe/Berlin':
      return 'Berlin (GMT+1)';
    case 'Europe/Istanbul':
      return 'İstanbul (GMT+3)';
    case 'Asia/Kolkata':
      return 'Mumbai (GMT+5:30)';
    case 'Asia/Shanghai':
      return 'Şangay (GMT+8)';
    case 'Asia/Tokyo':
      return 'Tokyo (GMT+9)';
    case 'Australia/Sydney':
      return 'Sydney (GMT+11)';
    case 'America/New_York':
      return 'New York (GMT-5)';
    case 'America/Los_Angeles':
      return 'Los Angeles (GMT-8)';
    default:
      return timezone;
  }
}
