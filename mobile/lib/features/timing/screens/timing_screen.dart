import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/utils/extensions.dart';
import '../providers/timing_provider.dart';
import '../widgets/hour_grid.dart';
import '../widgets/timing_card.dart';

class TimingScreen extends ConsumerWidget {
  const TimingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTimingAsync = ref.watch(currentTimingProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.timingTab),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: currentTimingAsync.when(
        data: (analysis) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(currentTimingProvider);
            },
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current time analysis
                  CurrentTimeCard(analysis: analysis),

                  AppSpacing.verticalGapLg,

                  // Weekly heatmap
                  Text(
                    l10n.weeklyHeatmap,
                    style: AppTypography.h3,
                  ),
                  AppSpacing.verticalGapMd,
                  AppCard(
                    child: HourGrid(
                      heatmapData: analysis.heatmapData,
                      onCellTap: (day, hour) {
                        _showTimeDetails(context, day, hour, analysis);
                      },
                    ),
                  ),

                  AppSpacing.verticalGapLg,

                  // Best times
                  Text(
                    l10n.bestTimes,
                    style: AppTypography.h3,
                  ),
                  AppSpacing.verticalGapMd,
                  ...analysis.topTimes.map((time) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: BestTimeCard(recommendation: time),
                    );
                  }),

                  AppSpacing.verticalGapLg,

                  // Timezone selector
                  _TimezoneSelector(),

                  AppSpacing.verticalGapXl,
                ],
              ),
            ),
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
                'Veriler yüklenemedi',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.verticalGapMd,
              TextButton.icon(
                onPressed: () => ref.refresh(currentTimingProvider),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimeDetails(
    BuildContext context,
    int day,
    int hour,
    dynamic analysis,
  ) {
    final days = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];

    final score = analysis.heatmapData[day][hour] * 100;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AppSpacing.verticalGapLg,
            Text(
              '${days[day]} ${hour.toString().padLeft(2, '0')}:00',
              style: AppTypography.h2,
            ),
            AppSpacing.verticalGapMd,
            Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: AppColors.getScoreColor(score).withOpacity(0.1),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics,
                    color: AppColors.getScoreColor(score),
                  ),
                  AppSpacing.horizontalGapSm,
                  Text(
                    'Etkileşim Skoru: ${score.toInt()}',
                    style: AppTypography.body.copyWith(
                      color: AppColors.getScoreColor(score),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.verticalGapMd,
            Text(
              _getRecommendationText(score),
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalGapLg,
          ],
        ),
      ),
    );
  }

  String _getRecommendationText(double score) {
    if (score >= 80) {
      return 'Bu zaman dilimi paylaşım için mükemmel! Yüksek etkileşim bekleniyor.';
    } else if (score >= 60) {
      return 'İyi bir zaman dilimi. Makul düzeyde etkileşim alabilirsiniz.';
    } else if (score >= 40) {
      return 'Orta düzey trafik. Daha iyi bir zaman bekleyebilirsiniz.';
    } else {
      return 'Düşük trafik zamanı. Mümkünse başka bir zaman tercih edin.';
    }
  }
}

class _TimezoneSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTimezone = ref.watch(selectedTimezoneProvider);
    final timezones = ref.watch(availableTimezonesProvider);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.timezone,
            style: AppTypography.label,
          ),
          AppSpacing.verticalGapSm,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppSpacing.borderRadiusSm,
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedTimezone,
                isExpanded: true,
                dropdownColor: AppColors.surface,
                items: timezones.map((tz) {
                  return DropdownMenuItem(
                    value: tz,
                    child: Text(
                      getTimezoneLabel(tz),
                      style: AppTypography.body,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(selectedTimezoneProvider.notifier).state = value;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
