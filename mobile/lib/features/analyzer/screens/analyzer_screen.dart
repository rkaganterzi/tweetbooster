import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/widgets/banner_ad_widget.dart';
import '../../../core/providers/ad_provider.dart';
import '../../../core/utils/extensions.dart';
import '../providers/analyzer_provider.dart';
import '../widgets/post_input.dart';
import '../widgets/score_card.dart';
import '../widgets/engagement_chart.dart';
import '../widgets/suggestions_list.dart';
import '../widgets/warnings_list.dart';
import '../widgets/signal_chips.dart';

class AnalyzerScreen extends ConsumerStatefulWidget {
  const AnalyzerScreen({super.key});

  @override
  ConsumerState<AnalyzerScreen> createState() => _AnalyzerScreenState();
}

class _AnalyzerScreenState extends ConsumerState<AnalyzerScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onAnalyze() async {
    final content = _textController.text.trim();
    if (content.isEmpty) {
      context.showSnackBar('Lütfen bir post yazın', isError: true);
      return;
    }

    await ref.read(analyzerControllerProvider.notifier).analyzePost(content);

    // Record action for interstitial ad
    ref.read(adControllerProvider.notifier).recordAction();
  }

  void _onClear() {
    _textController.clear();
    ref.read(analyzerControllerProvider.notifier).clearAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    final analyzerState = ref.watch(analyzerControllerProvider);
    final l10n = context.l10n;

    // Listen for errors
    ref.listen<AnalyzerState>(analyzerControllerProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        context.showSnackBar(next.error!, isError: true);
        ref.read(analyzerControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('TweetBoost'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: analyzerState.isLoading,
        message: 'Analiz ediliyor...',
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
          controller: _scrollController,
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Post Input
              PostInput(
                controller: _textController,
                onChanged: (value) {
                  ref.read(postContentProvider.notifier).state = value;
                },
              ),

              AppSpacing.verticalGapMd,

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      text: l10n.analyzeButton,
                      onPressed: _onAnalyze,
                      isLoading: analyzerState.isLoading,
                      icon: Icons.analytics,
                    ),
                  ),
                  AppSpacing.horizontalGapSm,
                  Expanded(
                    child: AppButton(
                      text: 'Temizle',
                      variant: AppButtonVariant.secondary,
                      onPressed: analyzerState.analysis != null ? _onClear : null,
                      icon: Icons.clear,
                    ),
                  ),
                ],
              ),

              // Results Section
              if (analyzerState.analysis != null) ...[
                AppSpacing.verticalGapLg,

                // Overall Score
                ScoreCard(score: analyzerState.analysis!.overallScore),

                AppSpacing.verticalGapMd,

                // Warnings (if any)
                if (analyzerState.analysis!.warnings.isNotEmpty) ...[
                  WarningsList(warnings: analyzerState.analysis!.warnings),
                  AppSpacing.verticalGapMd,
                ],

                // Engagement Scores
                EngagementChart(
                  scores: analyzerState.analysis!.engagementScores,
                ),

                AppSpacing.verticalGapMd,

                // Algorithm Signals
                SignalChips(signals: analyzerState.analysis!.signals),

                AppSpacing.verticalGapMd,

                // Suggestions
                SuggestionsList(
                  suggestions: analyzerState.analysis!.suggestions,
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
