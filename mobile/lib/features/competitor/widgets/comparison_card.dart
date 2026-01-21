import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../data/models/competitor_analysis.dart';

class ComparisonCard extends StatelessWidget {
  final CompetitorAnalysis competitorAnalysis;
  final VoidCallback? onViewDetails;
  final VoidCallback? onDelete;

  const ComparisonCard({
    super.key,
    required this.competitorAnalysis,
    this.onViewDetails,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final analysis = competitorAnalysis.analysis;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getScoreColor(analysis.overallScore).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Rakip',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Score badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getScoreColor(analysis.overallScore),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${analysis.overallScore.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.verticalGapMd,

          // Content preview
          Text(
            competitorAnalysis.competitorContent,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          if (competitorAnalysis.sourceUrl != null) ...[
            AppSpacing.verticalGapSm,
            Row(
              children: [
                Icon(
                  Icons.link,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    competitorAnalysis.sourceUrl!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],

          AppSpacing.verticalGapMd,

          // Engagement Metrics
          Row(
            children: [
              _MetricChip(
                icon: Icons.favorite_outline,
                value: analysis.engagementScores.likeability,
                label: 'Beğeni',
              ),
              AppSpacing.horizontalGapSm,
              _MetricChip(
                icon: Icons.repeat,
                value: analysis.engagementScores.retweetability,
                label: 'RT',
              ),
              AppSpacing.horizontalGapSm,
              _MetricChip(
                icon: Icons.chat_bubble_outline,
                value: analysis.engagementScores.replyability,
                label: 'Yanıt',
              ),
            ],
          ),

          AppSpacing.verticalGapMd,

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onDelete != null)
                TextButton.icon(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline, size: 18),
                  label: const Text('Sil'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              if (onViewDetails != null)
                TextButton.icon(
                  onPressed: onViewDetails,
                  icon: Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Detaylar'),
                ),
            ],
          ),

          // Date
          Text(
            _formatDate(competitorAnalysis.createdAt),
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.primary;
    if (score >= 40) return AppColors.warning;
    return AppColors.error;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Az önce';
    if (diff.inHours < 1) return '${diff.inMinutes} dk önce';
    if (diff.inDays < 1) return '${diff.inHours} saat önce';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';

    return '${date.day}/${date.month}/${date.year}';
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final double value;
  final String label;

  const _MetricChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              '${value.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
