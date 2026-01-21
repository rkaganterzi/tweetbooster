import 'dart:convert';
import 'dart:typed_data';
import '../../../core/services/api_service.dart';
import '../../../core/config/api_config.dart';
import 'models/performance_tracking.dart';

class PerformanceRepository {
  final ApiService _apiService;

  PerformanceRepository(this._apiService);

  Future<({ExtractedMetrics metrics, String? id, double? accuracyScore})>
      extractMetrics({
    required Uint8List imageBytes,
    required String mediaType,
    String? originalAnalysisId,
    double? predictedScore,
    String? postContent,
  }) async {
    final imageBase64 = base64Encode(imageBytes);

    final response = await _apiService.post(
      ApiConfig.performanceExtractEndpoint,
      data: {
        'imageBase64': imageBase64,
        'mediaType': mediaType,
        if (originalAnalysisId != null) 'originalAnalysisId': originalAnalysisId,
        if (predictedScore != null) 'predictedScore': predictedScore,
        if (postContent != null) 'postContent': postContent,
      },
    );

    final responseData = response.data as Map<String, dynamic>;
    final data = responseData['data'] as Map<String, dynamic>;

    return (
      metrics: ExtractedMetrics.fromJson(data['metrics'] as Map<String, dynamic>),
      id: data['id'] as String?,
      accuracyScore: (data['accuracyScore'] as num?)?.toDouble(),
    );
  }

  Future<List<PerformanceTracking>> getHistory() async {
    final response = await _apiService.get(ApiConfig.performanceHistoryEndpoint);

    final responseData = response.data as Map<String, dynamic>;
    final list = responseData['data'] as List<dynamic>;
    return list
        .map((e) => PerformanceTracking.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PerformanceTrends> getTrends() async {
    final response = await _apiService.get(ApiConfig.performanceTrendsEndpoint);

    final responseData = response.data as Map<String, dynamic>;
    final data = responseData['data'] as Map<String, dynamic>;
    return PerformanceTrends.fromJson(data);
  }

  Future<PerformanceTracking> updateMetrics(
    String id, {
    int? actualLikes,
    int? actualRetweets,
    int? actualReplies,
    int? actualQuotes,
    int? actualImpressions,
    int? actualBookmarks,
  }) async {
    final response = await _apiService.put(
      ApiConfig.performanceByIdEndpoint(id),
      data: {
        if (actualLikes != null) 'actualLikes': actualLikes,
        if (actualRetweets != null) 'actualRetweets': actualRetweets,
        if (actualReplies != null) 'actualReplies': actualReplies,
        if (actualQuotes != null) 'actualQuotes': actualQuotes,
        if (actualImpressions != null) 'actualImpressions': actualImpressions,
        if (actualBookmarks != null) 'actualBookmarks': actualBookmarks,
      },
    );

    final responseData = response.data as Map<String, dynamic>;
    final data = responseData['data'] as Map<String, dynamic>;
    return PerformanceTracking.fromJson(data);
  }

  Future<void> delete(String id) async {
    await _apiService.delete(ApiConfig.performanceByIdEndpoint(id));
  }
}
