import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/utils/extensions.dart';
import '../data/models/generated_post.dart';

class GeneratedPostCard extends StatelessWidget {
  final GeneratedPost post;
  final VoidCallback? onAnalyze;
  final VoidCallback? onRegenerate;
  final VoidCallback? onCopy;

  const GeneratedPostCard({
    super.key,
    required this.post,
    this.onAnalyze,
    this.onRegenerate,
    this.onCopy,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: post.content));
    context.showSnackBar(context.l10n.copiedToClipboard);
    onCopy?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with score
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getScoreColor(post.score).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.getScoreColor(post.score),
                    ),
                    AppSpacing.horizontalGapXs,
                    Text(
                      '${post.score.toInt()}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.getScoreColor(post.score),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                post.style,
                style: AppTypography.caption,
              ),
            ],
          ),

          AppSpacing.verticalGapMd,

          // Content
          Container(
            width: double.infinity,
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: SelectableText(
              post.content,
              style: AppTypography.body.copyWith(
                height: 1.5,
              ),
            ),
          ),

          AppSpacing.verticalGapMd,

          // Actions
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.copy,
                  label: context.l10n.copyToClipboard,
                  onTap: () => _copyToClipboard(context),
                ),
              ),
              AppSpacing.horizontalGapSm,
              Expanded(
                child: _ActionButton(
                  icon: Icons.analytics_outlined,
                  label: context.l10n.analyzeButton,
                  onTap: onAnalyze,
                ),
              ),
              AppSpacing.horizontalGapSm,
              Expanded(
                child: _ActionButton(
                  icon: Icons.refresh,
                  label: context.l10n.regenerate,
                  onTap: onRegenerate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusSm,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppSpacing.borderRadiusSm,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.textSecondary,
            ),
            AppSpacing.verticalGapXs,
            Text(
              label,
              style: AppTypography.caption.copyWith(
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
