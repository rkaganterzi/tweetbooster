import '../../../core/services/api_service.dart';
import '../../../core/config/api_config.dart';
import 'models/timing_recommendation.dart';

class TimingRepository {
  final ApiService _apiService;

  TimingRepository(this._apiService);

  Future<TimingAnalysis> getCurrentTiming() async {
    try {
      final response = await _apiService.get(ApiConfig.timingNowEndpoint);
      return TimingAnalysis.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      // Return mock data if API fails
      return _getMockTimingAnalysis();
    }
  }

  Future<List<TimingRecommendation>> getBestTimes() async {
    try {
      final response = await _apiService.get(ApiConfig.timingEndpoint);
      final list = response.data as List<dynamic>;
      return list
          .map((e) => TimingRecommendation.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return _getMockBestTimes();
    }
  }

  TimingAnalysis _getMockTimingAnalysis() {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentDay = now.weekday - 1;

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
        dayOfWeek: 1,
        score: 95,
        label: 'En İyi Zaman',
        description: 'Salı akşamları en yüksek etkileşim',
      ),
      topTimes: _getMockBestTimes(),
      heatmapData: TimingAnalysis.generateMockHeatmap(),
    );
  }

  List<TimingRecommendation> _getMockBestTimes() {
    return [
      TimingRecommendation(
        hour: 19,
        dayOfWeek: 1,
        score: 95,
        label: '1. En İyi',
        description: 'Salı 19:00 - En yüksek etkileşim',
      ),
      TimingRecommendation(
        hour: 12,
        dayOfWeek: 3,
        score: 92,
        label: '2. En İyi',
        description: 'Perşembe 12:00 - Öğle molası',
      ),
      TimingRecommendation(
        hour: 20,
        dayOfWeek: 0,
        score: 90,
        label: '3. En İyi',
        description: 'Pazartesi 20:00 - Akşam trafiği',
      ),
      TimingRecommendation(
        hour: 18,
        dayOfWeek: 4,
        score: 88,
        label: '4. En İyi',
        description: 'Cuma 18:00 - Hafta sonu başlangıcı',
      ),
      TimingRecommendation(
        hour: 10,
        dayOfWeek: 2,
        score: 85,
        label: '5. En İyi',
        description: 'Çarşamba 10:00 - Sabah trafiği',
      ),
    ];
  }
}
