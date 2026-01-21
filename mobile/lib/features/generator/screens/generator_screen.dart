import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/utils/extensions.dart';
import '../providers/generator_provider.dart';
import '../data/models/generated_post.dart';
import '../widgets/style_selector.dart';
import '../widgets/engagement_target.dart';
import '../widgets/generated_post_card.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({super.key});

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> {
  final _topicController = TextEditingController();
  bool _showConstraints = false;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _onGenerate() {
    ref.read(generatorControllerProvider.notifier).generate();
  }

  void _onAnalyze(String content) {
    // Navigate to analyzer with content
    context.go(AppRoutes.analyzer);
    // TODO: Pass content to analyzer
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(generatorControllerProvider);
    final l10n = context.l10n;

    // Listen for errors
    ref.listen<GeneratorState>(generatorControllerProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        context.showSnackBar(next.error!, isError: true);
        ref.read(generatorControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.generateTab),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: state.isLoading,
        message: 'Oluşturuluyor...',
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Topic Input
              AppTextField(
                controller: _topicController,
                labelText: 'Konu',
                hintText: l10n.topicHint,
                maxLines: 2,
                onChanged: (value) {
                  ref
                      .read(generatorControllerProvider.notifier)
                      .setTopic(value);
                },
              ),

              AppSpacing.verticalGapLg,

              // Style Selector
              StyleSelector(
                selectedStyle: state.style,
                onStyleChanged: (style) {
                  ref.read(generatorControllerProvider.notifier).setStyle(style);
                },
              ),

              AppSpacing.verticalGapLg,

              // Engagement Target
              EngagementTargetSelector(
                selectedTarget: state.targetEngagement,
                onTargetChanged: (target) {
                  ref
                      .read(generatorControllerProvider.notifier)
                      .setTargetEngagement(target);
                },
              ),

              AppSpacing.verticalGapLg,

              // Constraints (Collapsible)
              _ConstraintsSection(
                isExpanded: _showConstraints,
                onToggle: () {
                  setState(() => _showConstraints = !_showConstraints);
                },
                constraints: state.constraints,
                onHashtagsToggle: () {
                  ref
                      .read(generatorControllerProvider.notifier)
                      .toggleHashtags();
                },
                onEmojisToggle: () {
                  ref.read(generatorControllerProvider.notifier).toggleEmojis();
                },
              ),

              AppSpacing.verticalGapLg,

              // Generate Button
              AppButton(
                text: l10n.generateButton,
                onPressed: _onGenerate,
                isLoading: state.isLoading,
                icon: Icons.auto_awesome,
              ),

              // Generated Result
              if (state.generatedPost != null) ...[
                AppSpacing.verticalGapLg,

                GeneratedPostCard(
                  post: state.generatedPost!,
                  onAnalyze: () => _onAnalyze(state.generatedPost!.content),
                  onRegenerate: () {
                    ref.read(generatorControllerProvider.notifier).regenerate();
                  },
                ),
              ],

              AppSpacing.verticalGapXl,
            ],
          ),
        ),
      ),
    );
  }
}

class _ConstraintsSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final GenerationConstraints constraints;
  final VoidCallback onHashtagsToggle;
  final VoidCallback onEmojisToggle;

  const _ConstraintsSection({
    required this.isExpanded,
    required this.onToggle,
    required this.constraints,
    required this.onHashtagsToggle,
    required this.onEmojisToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: AppSpacing.paddingMd,
              child: Row(
                children: [
                  const Icon(
                    Icons.tune,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  AppSpacing.horizontalGapSm,
                  Text(
                    'Gelişmiş Ayarlar',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: AppSpacing.paddingMd,
              child: Column(
                children: [
                  _ConstraintToggle(
                    label: context.l10n.includeHashtags,
                    value: constraints.includeHashtags,
                    onChanged: (_) => onHashtagsToggle(),
                  ),
                  AppSpacing.verticalGapSm,
                  _ConstraintToggle(
                    label: context.l10n.includeEmojis,
                    value: constraints.includeEmojis,
                    onChanged: (_) => onEmojisToggle(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ConstraintToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ConstraintToggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.body,
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
