import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/threads_repository.dart';
import '../data/models/thread_part.dart';

// Repository provider
final threadsRepositoryProvider = Provider<ThreadsRepository>((ref) {
  return ThreadsRepository();
});

// Threads state
class ThreadsState {
  final String inputContent;
  final Thread? thread;
  final bool isProcessing;
  final String? error;

  const ThreadsState({
    this.inputContent = '',
    this.thread,
    this.isProcessing = false,
    this.error,
  });

  ThreadsState copyWith({
    String? inputContent,
    Thread? thread,
    bool? isProcessing,
    String? error,
    bool clearThread = false,
  }) {
    return ThreadsState(
      inputContent: inputContent ?? this.inputContent,
      thread: clearThread ? null : (thread ?? this.thread),
      isProcessing: isProcessing ?? this.isProcessing,
      error: error,
    );
  }
}

class ThreadsController extends StateNotifier<ThreadsState> {
  final ThreadsRepository _repository;

  ThreadsController(this._repository) : super(const ThreadsState());

  void setContent(String content) {
    state = state.copyWith(inputContent: content);
  }

  void createThread() {
    if (state.inputContent.trim().isEmpty) {
      state = state.copyWith(error: 'Lütfen içerik girin');
      return;
    }

    state = state.copyWith(isProcessing: true, error: null);

    try {
      final thread = _repository.createThread(state.inputContent);
      state = state.copyWith(thread: thread, isProcessing: false);
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  void updatePart(int index, String newContent) {
    if (state.thread == null) return;

    final updatedThread = _repository.updatePart(
      state.thread!,
      index,
      newContent,
    );
    state = state.copyWith(thread: updatedThread);
  }

  String getFormattedThread() {
    if (state.thread == null) return '';
    return _repository.formatThreadForCopy(state.thread!);
  }

  void clearThread() {
    state = state.copyWith(clearThread: true, inputContent: '');
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final threadsControllerProvider =
    StateNotifierProvider<ThreadsController, ThreadsState>((ref) {
  final repository = ref.watch(threadsRepositoryProvider);
  return ThreadsController(repository);
});
