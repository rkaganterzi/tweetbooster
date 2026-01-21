import '../../../core/services/api_service.dart';
import '../../../core/config/api_config.dart';
import 'models/post_analysis.dart';

class AnalyzerRepository {
  final ApiService _apiService;

  AnalyzerRepository(this._apiService);

  Future<PostAnalysis> analyzePost(String content) async {
    final response = await _apiService.post(
      ApiConfig.analyzeEndpoint,
      data: {'content': content},
    );

    final responseData = response.data as Map<String, dynamic>;
    final data = responseData['data'] as Map<String, dynamic>;
    data['content'] = content; // API doesn't return content, add it
    return PostAnalysis.fromJson(data);
  }

  Future<List<PostAnalysis>> getHistory() async {
    final response = await _apiService.get(ApiConfig.analyzeHistoryEndpoint);

    final list = response.data as List<dynamic>;
    return list
        .map((e) => PostAnalysis.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
