import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../analyzer/providers/analyzer_provider.dart';
import '../data/performance_repository.dart';
import '../data/models/performance_tracking.dart';

// Repository provider
final performanceRepositoryProvider = Provider<PerformanceRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PerformanceRepository(apiService);
});

// Performance state
class PerformanceState {
  final ExtractedMetrics? currentMetrics;
  final String? currentId;
  final double? accuracyScore;
  final Uint8List? selectedImage;
  final List<PerformanceTracking> history;
  final PerformanceTrends? trends;
  final bool isLoading;
  final bool isExtracting;
  final String? error;

  const PerformanceState({
    this.currentMetrics,
    this.currentId,
    this.accuracyScore,
    this.selectedImage,
    this.history = const [],
    this.trends,
    this.isLoading = false,
    this.isExtracting = false,
    this.error,
  });

  PerformanceState copyWith({
    ExtractedMetrics? currentMetrics,
    String? currentId,
    double? accuracyScore,
    Uint8List? selectedImage,
    List<PerformanceTracking>? history,
    PerformanceTrends? trends,
    bool? isLoading,
    bool? isExtracting,
    String? error,
    bool clearMetrics = false,
    bool clearImage = false,
  }) {
    return PerformanceState(
      currentMetrics: clearMetrics ? null : (currentMetrics ?? this.currentMetrics),
      currentId: clearMetrics ? null : (currentId ?? this.currentId),
      accuracyScore: clearMetrics ? null : (accuracyScore ?? this.accuracyScore),
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      history: history ?? this.history,
      trends: trends ?? this.trends,
      isLoading: isLoading ?? this.isLoading,
      isExtracting: isExtracting ?? this.isExtracting,
      error: error,
    );
  }
}

class PerformanceController extends StateNotifier<PerformanceState> {
  final PerformanceRepository _repository;

  PerformanceController(this._repository) : super(const PerformanceState());

  void setSelectedImage(Uint8List? imageBytes) {
    state = state.copyWith(selectedImage: imageBytes, clearMetrics: true);
  }

  Future<void> extractMetrics({
    required Uint8List imageBytes,
    String mediaType = 'image/png',
    String? originalAnalysisId,
    double? predictedScore,
    String? postContent,
  }) async {
    state = state.copyWith(isExtracting: true, error: null);

    try {
      final result = await _repository.extractMetrics(
        imageBytes: imageBytes,
        mediaType: mediaType,
        originalAnalysisId: originalAnalysisId,
        predictedScore: predictedScore,
        postContent: postContent,
      );

      state = state.copyWith(
        currentMetrics: result.metrics,
        currentId: result.id,
        accuracyScore: result.accuracyScore,
        isExtracting: false,
      );

      // Reload history to include new entry
      await loadHistory();
    } catch (e) {
      state = state.copyWith(
        isExtracting: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final history = await _repository.getHistory();
      state = state.copyWith(history: history, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadTrends() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final trends = await _repository.getTrends();
      state = state.copyWith(trends: trends, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateMetrics(String id, ExtractedMetrics metrics) async {
    try {
      await _repository.updateMetrics(
        id,
        actualLikes: metrics.likes,
        actualRetweets: metrics.retweets,
        actualReplies: metrics.replies,
        actualQuotes: metrics.quotes,
        actualImpressions: metrics.impressions,
        actualBookmarks: metrics.bookmarks,
      );

      // Reload history
      await loadHistory();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteRecord(String id) async {
    try {
      await _repository.delete(id);
      state = state.copyWith(
        history: state.history.where((h) => h.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearCurrentMetrics() {
    state = state.copyWith(clearMetrics: true, clearImage: true);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final performanceControllerProvider =
    StateNotifierProvider<PerformanceController, PerformanceState>((ref) {
  final repository = ref.watch(performanceRepositoryProvider);
  return PerformanceController(repository);
});

// Trends provider
final performanceTrendsProvider = FutureProvider<PerformanceTrends>((ref) async {
  final repository = ref.watch(performanceRepositoryProvider);
  return repository.getTrends();
});
