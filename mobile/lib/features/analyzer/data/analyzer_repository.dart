import '../../../core/services/api_service.dart';
import '../../../core/config/api_config.dart';
import 'models/post_analysis.dart';

class AnalyzerRepository {
  final ApiService _apiService;

  AnalyzerRepository(this._apiService);

  Future<PostAnalysis> analyzePost(String content, {bool generateImprovements = true}) async {
    final response = await _apiService.post(
      ApiConfig.analyzeEndpoint,
      data: {
        'content': content,
        'generateImprovements': generateImprovements,
      },
    );

    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      throw ApiException(message: 'Geçersiz API yanıtı');
    }

    final data = responseData['data'];
    if (data is! Map<String, dynamic>) {
      throw ApiException(message: 'Analiz verisi bulunamadı');
    }

    data['content'] = content; // API doesn't return content, add it
    return PostAnalysis.fromJson(data);
  }

  Future<List<PostAnalysis>> getHistory() async {
    final response = await _apiService.get(ApiConfig.analyzeHistoryEndpoint);

    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      return []; // Return empty list for invalid response
    }

    final list = responseData['data'];
    if (list is! List<dynamic>) {
      return []; // Return empty list if no data
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => PostAnalysis.fromJson(e))
        .toList();
  }
}
