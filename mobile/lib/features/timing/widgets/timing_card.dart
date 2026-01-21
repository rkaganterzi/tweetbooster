import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/score_indicator.dart';
import '../data/models/timing_recommendation.dart';

class CurrentTimeCard extends StatelessWidget {
  final TimingAnalysis analysis;

  const CurrentTimeCard({
    super.key,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Şu An',
                      style: AppTypography.h3,
                    ),
                    AppSpacing.verticalGapXs,
                    Text(
                      _getCurrentTimeString(),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              ScoreIndicator(
                score: analysis.currentScore,
                size: 80,
                strokeWidth: 8,
              ),
            ],
          ),
          AppSpacing.verticalGapMd,
          Container(
            width: double.infinity,
            padding: AppSpacing.paddingSm,
            decoration: BoxDecoration(
              color: analysis.isGoodTime
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.warning.withOpacity(0.1),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Row(
              children: [
                Icon(
                  analysis.isGoodTime
                      ? Icons.thumb_up_outlined
                      : Icons.schedule,
                  size: 20,
                  color:
                      analysis.isGoodTime ? AppColors.success : AppColors.warning,
                ),
                AppSpacing.horizontalGapSm,
                Expanded(
                  child: Text(
                    analysis.recommendation,
                    style: AppTypography.bodySmall.copyWith(
                      color: analysis.isGoodTime
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentTimeString() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final days = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];
    return '${days[now.weekday - 1]}, $hour:$minute';
  }
}

class BestTimeCard extends StatelessWidget {
  final TimingRecommendation recommendation;

  const BestTimeCard({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingSm,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.getScoreColor(recommendation.score)
                  .withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${recommendation.score.toInt()}',
                style: AppTypography.body.copyWith(
                  color: AppColors.getScoreColor(recommendation.score),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AppSpacing.horizontalGapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${recommendation.dayName} ${recommendation.formattedTime}',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  recommendation.description,
                  style: AppTypography.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
