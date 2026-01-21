import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/score_indicator.dart';
import '../../../core/utils/extensions.dart';

class ScoreCard extends StatelessWidget {
  final double score;
  final String? label;

  const ScoreCard({
    super.key,
    required this.score,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppSpacing.paddingLg,
      child: Column(
        children: [
          Text(
            context.l10n.overallScore,
            style: AppTypography.h3,
          ),
          AppSpacing.verticalGapMd,
          ScoreIndicator(
            score: score,
            size: 140,
            strokeWidth: 12,
            label: _getScoreLabel(score),
          ),
          AppSpacing.verticalGapMd,
          _buildScoreDescription(score),
        ],
      ),
    );
  }

  String _getScoreLabel(double score) {
    if (score >= 80) return 'Mükemmel';
    if (score >= 60) return 'İyi';
    if (score >= 40) return 'Orta';
    return 'Düşük';
  }

  Widget _buildScoreDescription(double score) {
    String description;
    Color color;

    if (score >= 80) {
      description = 'Bu post yüksek etkileşim alabilir!';
      color = AppColors.scoreExcellent;
    } else if (score >= 60) {
      description = 'İyi bir post, birkaç iyileştirme yapılabilir.';
      color = AppColors.scoreGood;
    } else if (score >= 40) {
      description = 'Önerileri uygulayarak skoru artırabilirsin.';
      color = AppColors.scoreMedium;
    } else {
      description = 'Bu post iyileştirmeye ihtiyaç duyuyor.';
      color = AppColors.scoreLow;
    }

    return Text(
      description,
      style: AppTypography.bodySmall.copyWith(color: color),
      textAlign: TextAlign.center,
    );
  }
}
