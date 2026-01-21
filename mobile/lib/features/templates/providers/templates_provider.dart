import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../analyzer/providers/analyzer_provider.dart';
import '../data/templates_repository.dart';
import '../data/models/post_template.dart';

// Repository provider
final templatesRepositoryProvider = Provider<TemplatesRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TemplatesRepository(apiService);
});

// Selected category provider
final selectedCategoryProvider = StateProvider<TemplateCategory>((ref) {
  return TemplateCategory.all;
});

// Templates list provider
final templatesProvider = FutureProvider<List<PostTemplate>>((ref) async {
  final repository = ref.watch(templatesRepositoryProvider);
  final category = ref.watch(selectedCategoryProvider);

  try {
    return await repository.getTemplates(category: category);
  } catch (e) {
    // Return mock templates if API fails
    final mockTemplates = TemplatesRepository.getMockTemplates();
    if (category == TemplateCategory.all) {
      return mockTemplates;
    }
    return mockTemplates
        .where((t) => t.category == category)
        .toList();
  }
});

// Single template provider
final templateProvider =
    FutureProvider.family<PostTemplate, String>((ref, id) async {
  final repository = ref.watch(templatesRepositoryProvider);
  return repository.getTemplate(id);
});

// Template state for using a template
class TemplateUsageState {
  final PostTemplate? selectedTemplate;
  final Map<String, String> placeholderValues;
  final String? generatedContent;

  const TemplateUsageState({
    this.selectedTemplate,
    this.placeholderValues = const {},
    this.generatedContent,
  });

  TemplateUsageState copyWith({
    PostTemplate? selectedTemplate,
    Map<String, String>? placeholderValues,
    String? generatedContent,
    bool clearTemplate = false,
  }) {
    return TemplateUsageState(
      selectedTemplate: clearTemplate ? null : (selectedTemplate ?? this.selectedTemplate),
      placeholderValues: placeholderValues ?? this.placeholderValues,
      generatedContent: generatedContent ?? this.generatedContent,
    );
  }
}

class TemplateUsageController extends StateNotifier<TemplateUsageState> {
  TemplateUsageController() : super(const TemplateUsageState());

  void selectTemplate(PostTemplate template) {
    state = TemplateUsageState(
      selectedTemplate: template,
      placeholderValues: {},
    );
  }

  void setPlaceholderValue(String key, String value) {
    state = state.copyWith(
      placeholderValues: {
        ...state.placeholderValues,
        key: value,
      },
    );
  }

  void generateContent() {
    if (state.selectedTemplate == null) return;

    final content = state.selectedTemplate!.applyPlaceholders(
      state.placeholderValues,
    );
    state = state.copyWith(generatedContent: content);
  }

  void clearSelection() {
    state = const TemplateUsageState();
  }
}

final templateUsageControllerProvider =
    StateNotifierProvider<TemplateUsageController, TemplateUsageState>((ref) {
  return TemplateUsageController();
});
