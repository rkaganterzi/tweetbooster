import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/score_indicator.dart';
import '../../../core/utils/extensions.dart';
import '../data/models/engagement_scores.dart';

class EngagementChart extends StatelessWidget {
  final EngagementScores scores;

  const EngagementChart({
    super.key,
    required this.scores,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.engagementScores,
            style: AppTypography.h3,
          ),
          AppSpacing.verticalGapMd,
          ...scores.toList().map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: LinearScoreIndicator(
                label: _getLocalizedLabel(context, item.key),
                score: item.value,
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getLocalizedLabel(BuildContext context, String key) {
    final l10n = context.l10n;
    switch (key) {
      case 'likeability':
        return l10n.likeability;
      case 'replyability':
        return l10n.replyability;
      case 'retweetability':
        return l10n.retweetability;
      case 'quoteability':
        return l10n.quoteability;
      case 'shareability':
        return l10n.shareability;
      case 'dwellPotential':
        return l10n.dwellPotential;
      case 'followPotential':
        return l10n.followPotential;
      default:
        return key;
    }
  }
}
