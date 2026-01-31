import '../../../core/services/api_service.dart';
import '../../../core/config/api_config.dart';
import 'models/generated_post.dart';
import 'models/generation_request.dart';

class GeneratorRepository {
  final ApiService _apiService;

  GeneratorRepository(this._apiService);

  Future<GeneratedPost> generatePost(GenerationRequest request) async {
    final response = await _apiService.post(
      ApiConfig.generateEndpoint,
      data: request.toJson(),
    );

    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      throw ApiException(message: 'Geçersiz API yanıtı');
    }

    final data = responseData['data'];
    if (data is! Map<String, dynamic>) {
      throw ApiException(message: 'Post oluşturulamadı');
    }

    data['style'] = request.style.value; // Add style as string from request
    return GeneratedPost.fromJson(data);
  }

  // Note: This endpoint doesn't exist in backend - kept for future use
  Future<List<GeneratedPost>> generateMultiple(
    GenerationRequest request, {
    int count = 3,
  }) async {
    final response = await _apiService.post(
      '${ApiConfig.generateEndpoint}/multiple',
      data: {
        ...request.toJson(),
        'count': count,
      },
    );

    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      return [];
    }

    final list = responseData['data'];
    if (list is! List<dynamic>) {
      return [];
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => GeneratedPost.fromJson(e))
        .toList();
  }
}
