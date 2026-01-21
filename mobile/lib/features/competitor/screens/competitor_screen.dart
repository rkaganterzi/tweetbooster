import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/widgets/banner_ad_widget.dart';
import '../../../core/providers/ad_provider.dart';
import '../../../core/utils/extensions.dart';
import '../providers/competitor_provider.dart';
import '../widgets/competitor_input.dart';
import '../widgets/comparison_card.dart';
import '../../analyzer/widgets/score_card.dart';
import '../../analyzer/widgets/engagement_chart.dart';
import '../../analyzer/widgets/suggestions_list.dart';
import '../../analyzer/widgets/signal_chips.dart';

class CompetitorScreen extends ConsumerStatefulWidget {
  const CompetitorScreen({super.key});

  @override
  ConsumerState<CompetitorScreen> createState() => _CompetitorScreenState();
}

class _CompetitorScreenState extends ConsumerState<CompetitorScreen> {
  final _contentController = TextEditingController();
  final _sourceUrlController = TextEditingController();
  final _notesController = TextEditingController();
  bool _showOptionalFields = false;

  @override
  void dispose() {
    _contentController.dispose();
    _sourceUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onAnalyze() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      context.showSnackBar('Lütfen rakip içeriğini girin', isError: true);
      return;
    }

    await ref.read(competitorControllerProvider.notifier).analyzeCompetitor(
          content: content,
          sourceUrl: _sourceUrlController.text.trim(),
          notes: _notesController.text.trim(),
        );

    // Record action for interstitial ad
    ref.read(adControllerProvider.notifier).recordAction();
  }

  void _onClear() {
    _contentController.clear();
    _sourceUrlController.clear();
    _notesController.clear();
    ref.read(competitorControllerProvider.notifier).clearAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(competitorControllerProvider);
    final l10n = context.l10n;

    // Listen for errors
    ref.listen<CompetitorState>(competitorControllerProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        context.showSnackBar(next.error!, isError: true);
        ref.read(competitorControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rakip Analizi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push(AppRoutes.competitorHistory),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: state.isLoading,
        message: 'Analiz ediliyor...',
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Input section
                    CompetitorInput(
                      contentController: _contentController,
                      sourceUrlController: _sourceUrlController,
                      notesController: _notesController,
                      onContentChanged: (value) {
                        ref.read(competitorContentProvider.notifier).state = value;
                      },
                      showOptionalFields: _showOptionalFields,
                      onToggleOptional: () {
                        setState(() => _showOptionalFields = !_showOptionalFields);
                      },
                    ),

                    AppSpacing.verticalGapMd,

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AppButton(
                            text: 'Analiz Et',
                            onPressed: _onAnalyze,
                            isLoading: state.isLoading,
                            icon: Icons.analytics,
                          ),
                        ),
                        AppSpacing.horizontalGapSm,
                        Expanded(
                          child: AppButton(
                            text: 'Temizle',
                            variant: AppButtonVariant.secondary,
                            onPressed: state.analysis != null ? _onClear : null,
                            icon: Icons.clear,
                          ),
                        ),
                      ],
                    ),

                    // Results Section
                    if (state.analysis != null) ...[
                      AppSpacing.verticalGapLg,

                      // Overall Score
                      ScoreCard(score: state.analysis!.analysis.overallScore),

                      AppSpacing.verticalGapMd,

                      // Engagement Scores
                      EngagementChart(
                        scores: state.analysis!.analysis.engagementScores,
                      ),

                      AppSpacing.verticalGapMd,

                      // Algorithm Signals
                      SignalChips(signals: state.analysis!.analysis.signals),

                      AppSpacing.verticalGapMd,

                      // Suggestions
                      SuggestionsList(
                        suggestions: state.analysis!.analysis.suggestions,
                      ),

                      AppSpacing.verticalGapXl,
                    ],
                  ],
                ),
              ),
            ),
            const BottomBannerAd(),
          ],
        ),
      ),
    );
  }
}
