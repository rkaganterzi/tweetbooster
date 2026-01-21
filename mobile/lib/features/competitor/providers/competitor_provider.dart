import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../analyzer/providers/analyzer_provider.dart';
import '../data/competitor_repository.dart';
import '../data/models/competitor_analysis.dart';

// Repository provider
final competitorRepositoryProvider = Provider<CompetitorRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CompetitorRepository(apiService);
});

// Competitor input state
final competitorContentProvider = StateProvider<String>((ref) => '');
final competitorSourceUrlProvider = StateProvider<String>((ref) => '');
final competitorNotesProvider = StateProvider<String>((ref) => '');

// Competitor state
class CompetitorState {
  final CompetitorAnalysis? analysis;
  final List<CompetitorAnalysis> history;
  final bool isLoading;
  final String? error;

  const CompetitorState({
    this.analysis,
    this.history = const [],
    this.isLoading = false,
    this.error,
  });

  CompetitorState copyWith({
    CompetitorAnalysis? analysis,
    List<CompetitorAnalysis>? history,
    bool? isLoading,
    String? error,
    bool clearAnalysis = false,
  }) {
    return CompetitorState(
      analysis: clearAnalysis ? null : (analysis ?? this.analysis),
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CompetitorController extends StateNotifier<CompetitorState> {
  final CompetitorRepository _repository;

  CompetitorController(this._repository) : super(const CompetitorState());

  Future<void> analyzeCompetitor({
    required String content,
    String? sourceUrl,
    String? notes,
  }) async {
    if (content.trim().isEmpty) {
      state = state.copyWith(error: 'Rakip içeriği boş olamaz');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final analysis = await _repository.analyzeCompetitor(
        content: content,
        sourceUrl: sourceUrl?.isNotEmpty == true ? sourceUrl : null,
        notes: notes?.isNotEmpty == true ? notes : null,
      );
      state = state.copyWith(
        analysis: analysis,
        history: [analysis, ...state.history],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
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

  Future<void> deleteAnalysis(String id) async {
    try {
      await _repository.delete(id);
      state = state.copyWith(
        history: state.history.where((a) => a.id != id).toList(),
        clearAnalysis: state.analysis?.id == id,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearAnalysis() {
    state = state.copyWith(clearAnalysis: true);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final competitorControllerProvider =
    StateNotifierProvider<CompetitorController, CompetitorState>((ref) {
  final repository = ref.watch(competitorRepositoryProvider);
  return CompetitorController(repository);
});

// History provider
final competitorHistoryProvider =
    FutureProvider<List<CompetitorAnalysis>>((ref) async {
  final repository = ref.watch(competitorRepositoryProvider);
  return repository.getHistory();
});
