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

    return GeneratedPost.fromJson(response.data as Map<String, dynamic>);
  }

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

    final list = response.data as List<dynamic>;
    return list
        .map((e) => GeneratedPost.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
