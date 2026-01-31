import '../../../core/services/api_service.dart';
import '../../../core/config/api_config.dart';
import 'models/timing_recommendation.dart';

class TimingRepository {
  final ApiService _apiService;

  TimingRepository(this._apiService);

  Future<TimingAnalysis> getCurrentTiming() async {
    try {
      // Get current timing
      final nowResponse = await _apiService.get(ApiConfig.timingNowEndpoint);
      final nowData = (nowResponse.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;

      // Get full timing data for best times
      final timingResponse = await _apiService.get(ApiConfig.timingEndpoint);
      final timingData = (timingResponse.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;

      // Parse optimal hours
      final optimalHours = (timingData['optimalHours'] as List<dynamic>?) ?? [];
      // Convert Dart weekday to JS weekday format (Sun=0, Sat=6)
      final currentDayJs = TimingRecommendation.dartToJsWeekday(DateTime.now().weekday);

      final topTimes = optimalHours.take(5).map((h) {
        final hour = h as Map<String, dynamic>;
        return TimingRecommendation(
          hour: hour['hour'] as int? ?? 0,
          dayOfWeek: currentDayJs,
          score: (hour['score'] as num?)?.toDouble() ?? 0,
          label: hour['audienceActivity'] as String? ?? '',
          description: 'Engagement: ${hour['engagementMultiplier']}x',
        );
      }).toList();

      return TimingAnalysis(
        currentScore: (nowData['currentScore'] as num?)?.toDouble() ?? 0,
        isGoodTime: nowData['isOptimalTime'] as bool? ?? false,
        recommendation: nowData['recommendation'] as String? ?? '',
        bestTime: topTimes.isNotEmpty ? topTimes.first : null,
        topTimes: topTimes,
        heatmapData: TimingAnalysis.generateMockHeatmap(),
      );
    } catch (e) {
      // Return mock data if API fails
      return _getMockTimingAnalysis();
    }
  }

  Future<List<TimingRecommendation>> getBestTimes() async {
    try {
      final response = await _apiService.get(ApiConfig.timingEndpoint);
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;

      final optimalHours = (data['optimalHours'] as List<dynamic>?) ?? [];
      final dayOfWeek = (data['dayOfWeek'] as List<dynamic>?) ?? [];

      // Combine optimal hours with day data
      List<TimingRecommendation> recommendations = [];

      for (var i = 0; i < dayOfWeek.length && i < 7; i++) {
        final day = dayOfWeek[i] as Map<String, dynamic>;
        final bestHours = (day['bestHours'] as List<dynamic>?) ?? [];
        if (bestHours.isNotEmpty) {
          recommendations.add(TimingRecommendation(
            hour: bestHours.first as int,
            dayOfWeek: i,
            score: (day['overallScore'] as num?)?.toDouble() ?? 0,
            label: day['day'] as String? ?? '',
            description: day['reasoning'] as String? ?? '',
          ));
        }
      }

      // Sort by score descending
      recommendations.sort((a, b) => b.score.compareTo(a.score));
      return recommendations.take(5).toList();
    } catch (e) {
      return _getMockBestTimes();
    }
  }

  TimingAnalysis _getMockTimingAnalysis() {
    final now = DateTime.now();
    final currentHour = now.hour;
    // Convert Dart weekday to JS weekday format (Sun=0, Sat=6)
    final currentDay = TimingRecommendation.dartToJsWeekday(now.weekday);

    // Calculate mock score based on current time
    double score;
    bool isGoodTime;
    String recommendation;

    if (currentHour >= 9 && currentHour <= 11) {
      score = 75 + (currentDay < 5 ? 10 : 5);
      isGoodTime = true;
      recommendation = 'Sabah saatleri - İş trafiği yüksek!';
    } else if (currentHour >= 12 && currentHour <= 14) {
      score = 82 + (currentDay < 5 ? 8 : 5);
      isGoodTime = true;
      recommendation = 'Öğle molası - Paylaşım için harika zaman!';
    } else if (currentHour >= 17 && currentHour <= 21) {
      score = 88 + (currentDay >= 5 ? 7 : 5);
      isGoodTime = true;
      recommendation = 'Akşam saatleri - En yüksek etkileşim!';
    } else if (currentHour >= 22 || currentHour <= 6) {
      score = 25 + (currentHour * 2);
      isGoodTime = false;
      recommendation = 'Gece saatleri - Etkileşim düşük olabilir.';
    } else {
      score = 55.0 + (currentHour * 1.5);
      isGoodTime = currentHour > 7;
      recommendation = 'Orta düzey trafik - Yine de paylaşabilirsiniz.';
    }

    return TimingAnalysis(
      currentScore: score.clamp(0, 100),
      isGoodTime: isGoodTime,
      recommendation: recommendation,
      bestTime: TimingRecommendation(
        hour: 19,
        dayOfWeek: 2, // Tuesday in JS format (Sun=0)
        score: 95,
        label: 'En İyi Zaman',
        description: 'Salı akşamları en yüksek etkileşim',
      ),
      topTimes: _getMockBestTimes(),
      heatmapData: TimingAnalysis.generateMockHeatmap(),
    );
  }

  /// Mock best times using JS weekday format (Sun=0, Sat=6)
  List<TimingRecommendation> _getMockBestTimes() {
    return [
      TimingRecommendation(
        hour: 19,
        dayOfWeek: 2, // Tuesday
        score: 95,
        label: '1. En İyi',
        description: 'Salı 19:00 - En yüksek etkileşim',
      ),
      TimingRecommendation(
        hour: 12,
        dayOfWeek: 4, // Thursday
        score: 92,
        label: '2. En İyi',
        description: 'Perşembe 12:00 - Öğle molası',
      ),
      TimingRecommendation(
        hour: 20,
        dayOfWeek: 1, // Monday
        score: 90,
        label: '3. En İyi',
        description: 'Pazartesi 20:00 - Akşam trafiği',
      ),
      TimingRecommendation(
        hour: 18,
        dayOfWeek: 5, // Friday
        score: 88,
        label: '4. En İyi',
        description: 'Cuma 18:00 - Hafta sonu başlangıcı',
      ),
      TimingRecommendation(
        hour: 10,
        dayOfWeek: 3, // Wednesday
        score: 85,
        label: '5. En İyi',
        description: 'Çarşamba 10:00 - Sabah trafiği',
      ),
    ];
  }
}
