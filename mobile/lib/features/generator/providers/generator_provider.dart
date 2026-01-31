import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../analyzer/providers/analyzer_provider.dart';
import '../data/generator_repository.dart';
import '../data/models/generated_post.dart';
import '../data/models/generation_request.dart';

// Repository provider
final generatorRepositoryProvider = Provider<GeneratorRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return GeneratorRepository(apiService);
});

// Generator state - uses GenerationConstraints from generation_request.dart
class GeneratorState {
  final String topic;
  final PostStyle style;
  final EngagementTarget? targetEngagement;
  final GenerationConstraints constraints;
  final GeneratedPost? generatedPost;
  final List<GeneratedPost> history;
  final bool isLoading;
  final String? error;

  GeneratorState({
    this.topic = '',
    this.style = PostStyle.informative,
    this.targetEngagement,
    GenerationConstraints? constraints,
    this.generatedPost,
    this.history = const [],
    this.isLoading = false,
    this.error,
  }) : constraints = constraints ?? GenerationConstraints();

  GeneratorState copyWith({
    String? topic,
    PostStyle? style,
    EngagementTarget? targetEngagement,
    GenerationConstraints? constraints,
    GeneratedPost? generatedPost,
    List<GeneratedPost>? history,
    bool? isLoading,
    String? error,
    bool clearTargetEngagement = false,
    bool clearGeneratedPost = false,
  }) {
    return GeneratorState(
      topic: topic ?? this.topic,
      style: style ?? this.style,
      targetEngagement:
          clearTargetEngagement ? null : (targetEngagement ?? this.targetEngagement),
      constraints: constraints ?? this.constraints,
      generatedPost:
          clearGeneratedPost ? null : (generatedPost ?? this.generatedPost),
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class GeneratorController extends StateNotifier<GeneratorState> {
  final GeneratorRepository _repository;

  GeneratorController(this._repository) : super(GeneratorState());

  void setTopic(String topic) {
    state = state.copyWith(topic: topic);
  }

  void setStyle(PostStyle style) {
    state = state.copyWith(style: style);
  }

  void setTargetEngagement(EngagementTarget? target) {
    state = state.copyWith(
      targetEngagement: target,
      clearTargetEngagement: target == null,
    );
  }

  void setConstraints(GenerationConstraints constraints) {
    state = state.copyWith(constraints: constraints);
  }

  void toggleHashtags() {
    state = state.copyWith(
      constraints: state.constraints.copyWith(
        includeHashtags: !state.constraints.includeHashtags,
      ),
    );
  }

  void toggleEmojis() {
    state = state.copyWith(
      constraints: state.constraints.copyWith(
        includeEmojis: !state.constraints.includeEmojis,
      ),
    );
  }

  Future<void> generate() async {
    if (state.topic.trim().isEmpty) {
      state = state.copyWith(error: 'Lütfen bir konu girin');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = GenerationRequest(
        topic: state.topic,
        style: state.style,
        targetEngagement: state.targetEngagement,
        constraints: state.constraints,
      );

      final post = await _repository.generatePost(request);

      state = state.copyWith(
        generatedPost: post,
        history: [post, ...state.history],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        clearGeneratedPost: true, // Clear old post on error
      );
    }
  }

  Future<void> regenerate() async {
    await generate();
  }

  void clearGenerated() {
    state = state.copyWith(clearGeneratedPost: true);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = GeneratorState();
  }
}

final generatorControllerProvider =
    StateNotifierProvider<GeneratorController, GeneratorState>((ref) {
  final repository = ref.watch(generatorRepositoryProvider);
  return GeneratorController(repository);
});
