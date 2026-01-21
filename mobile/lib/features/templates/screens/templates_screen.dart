import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/utils/extensions.dart';
import '../providers/templates_provider.dart';
import '../data/models/post_template.dart';
import '../widgets/template_card.dart';
import '../widgets/template_preview.dart';

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  void _showTemplatePreview(
    BuildContext context,
    WidgetRef ref,
    PostTemplate template,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TemplatePreviewSheet(
          template: template,
          onUse: (content) {
            Navigator.pop(context);
            // Navigate to analyzer with content
            context.go(AppRoutes.analyzer);
            // TODO: Pass content to analyzer
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.templatesTab),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category tabs
          _CategoryTabs(
            selectedCategory: selectedCategory,
            onCategoryChanged: (category) {
              ref.read(selectedCategoryProvider.notifier).state = category;
            },
          ),

          // Templates grid
          Expanded(
            child: templatesAsync.when(
              data: (templates) {
                if (templates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.grid_view_outlined,
                          size: 64,
                          color: AppColors.textMuted,
                        ),
                        AppSpacing.verticalGapMd,
                        Text(
                          'Şablon bulunamadı',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: AppSpacing.screenPadding,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    return TemplateCard(
                      template: template,
                      onTap: () => _showTemplatePreview(context, ref, template),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    AppSpacing.verticalGapMd,
                    Text(
                      'Şablonlar yüklenemedi',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.verticalGapMd,
                    TextButton.icon(
                      onPressed: () => ref.refresh(templatesProvider),
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final TemplateCategory selectedCategory;
  final ValueChanged<TemplateCategory> onCategoryChanged;

  const _CategoryTabs({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: TemplateCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = TemplateCategory.values[index];
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () => onCategoryChanged(category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                category.label,
                style: AppTypography.body.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
