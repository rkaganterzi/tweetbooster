import '../../../core/services/api_service.dart';
import '../../../core/config/api_config.dart';
import 'models/competitor_analysis.dart';

class CompetitorRepository {
  final ApiService _apiService;

  CompetitorRepository(this._apiService);

  Future<CompetitorAnalysis> analyzeCompetitor({
    required String content,
    String? sourceUrl,
    String? notes,
  }) async {
    final response = await _apiService.post(
      ApiConfig.competitorAnalyzeEndpoint,
      data: {
        'content': content,
        if (sourceUrl != null) 'sourceUrl': sourceUrl,
        if (notes != null) 'notes': notes,
      },
    );

    final responseData = response.data as Map<String, dynamic>;
    final data = responseData['data'] as Map<String, dynamic>;
    return CompetitorAnalysis.fromJson(data);
  }

  Future<List<CompetitorAnalysis>> getHistory() async {
    final response = await _apiService.get(ApiConfig.competitorHistoryEndpoint);

    final responseData = response.data as Map<String, dynamic>;
    final list = responseData['data'] as List<dynamic>;
    return list
        .map((e) => CompetitorAnalysis.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CompetitorAnalysis> getById(String id) async {
    final response = await _apiService.get(ApiConfig.competitorByIdEndpoint(id));

    final responseData = response.data as Map<String, dynamic>;
    final data = responseData['data'] as Map<String, dynamic>;
    return CompetitorAnalysis.fromJson(data);
  }

  Future<void> delete(String id) async {
    await _apiService.delete(ApiConfig.competitorByIdEndpoint(id));
  }
}
