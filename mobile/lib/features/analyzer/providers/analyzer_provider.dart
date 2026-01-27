import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../data/analyzer_repository.dart';
import '../data/models/post_analysis.dart';

// API Service provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Storage Service provider - uses singleton initialized in main()
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService.instance;
});

// Repository provider
final analyzerRepositoryProvider = Provider<AnalyzerRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AnalyzerRepository(apiService);
});

// Post content state
final postContentProvider = StateProvider<String>((ref) => '');

// Analysis state
class AnalyzerState {
  final PostAnalysis? analysis;
  final bool isLoading;
  final String? error;

  const AnalyzerState({
    this.analysis,
    this.isLoading = false,
    this.error,
  });

  AnalyzerState copyWith({
    PostAnalysis? analysis,
    bool? isLoading,
    String? error,
  }) {
    return AnalyzerState(
      analysis: analysis ?? this.analysis,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AnalyzerController extends StateNotifier<AnalyzerState> {
  final AnalyzerRepository _repository;
  final StorageService _storage;

  AnalyzerController(this._repository, this._storage)
      : super(const AnalyzerState());

  Future<void> analyzePost(String content) async {
    if (content.trim().isEmpty) {
      state = state.copyWith(error: 'Post içeriği boş olamaz');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final analysis = await _repository.analyzePost(content);
      state = state.copyWith(analysis: analysis, isLoading: false);

      // Save to history
      await _storage.addAnalysisHistory(analysis.toJson());
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is ApiException ? e.message : 'Analiz yapılırken bir hata oluştu.',
      );
    }
  }

  void clearAnalysis() {
    state = const AnalyzerState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final analyzerControllerProvider =
    StateNotifierProvider<AnalyzerController, AnalyzerState>((ref) {
  final repository = ref.watch(analyzerRepositoryProvider);
  final storage = ref.watch(storageServiceProvider);
  return AnalyzerController(repository, storage);
});

// History provider
final analysisHistoryProvider = FutureProvider<List<PostAnalysis>>((ref) async {
  final repository = ref.watch(analyzerRepositoryProvider);
  return repository.getHistory();
});

// Local history provider
final localHistoryProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getAnalysisHistory();
});
