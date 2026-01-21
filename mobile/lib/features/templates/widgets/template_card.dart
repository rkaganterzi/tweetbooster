import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../data/models/post_template.dart';

class TemplateCard extends StatelessWidget {
  final PostTemplate template;
  final VoidCallback? onTap;

  const TemplateCard({
    super.key,
    required this.template,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.paddingSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category badge and score
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getCategoryColor(template.category).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  template.category.label,
                  style: AppTypography.caption.copyWith(
                    color: _getCategoryColor(template.category),
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              if (template.averageScore != null) ...[
                Icon(
                  Icons.star,
                  size: 14,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 2),
                Text(
                  '${template.averageScore!.toInt()}',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),

          AppSpacing.verticalGapSm,

          // Name
          Text(
            template.name,
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          AppSpacing.verticalGapXs,

          // Description
          Text(
            template.description,
            style: AppTypography.caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          AppSpacing.verticalGapSm,

          // Template preview
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Text(
              template.template,
              style: AppTypography.caption.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 11,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Usage count
          if (template.usageCount > 0) ...[
            AppSpacing.verticalGapSm,
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_formatCount(template.usageCount)} kullanım',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getCategoryColor(TemplateCategory category) {
    switch (category) {
      case TemplateCategory.question:
        return AppColors.info;
      case TemplateCategory.thread:
        return AppColors.success;
      case TemplateCategory.hotTake:
        return AppColors.error;
      case TemplateCategory.value:
        return AppColors.warning;
      case TemplateCategory.story:
        return AppColors.primary;
      case TemplateCategory.all:
        return AppColors.textSecondary;
    }
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
