import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/utils/extensions.dart';
import '../data/models/thread_part.dart';

class ThreadPartCard extends StatelessWidget {
  final ThreadPart part;
  final int totalParts;
  final VoidCallback? onEdit;
  final VoidCallback? onCopy;

  const ThreadPartCard({
    super.key,
    required this.part,
    required this.totalParts,
    this.onEdit,
    this.onCopy,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: part.content));
    context.showSnackBar(context.l10n.copiedToClipboard);
    onCopy?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${part.partNumber}/$totalParts',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (part.isEdited) ...[
                AppSpacing.horizontalGapSm,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Düzenlendi',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.warning,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              if (part.score != null)
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: AppColors.getScoreColor(part.score!),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${part.score!.toInt()}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.getScoreColor(part.score!),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          AppSpacing.verticalGapSm,

          // Content
          Container(
            width: double.infinity,
            padding: AppSpacing.paddingSm,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: SelectableText(
              part.content,
              style: AppTypography.body.copyWith(height: 1.4),
            ),
          ),

          AppSpacing.verticalGapSm,

          // Footer
          Row(
            children: [
              Text(
                '${part.characterCount}/280',
                style: AppTypography.caption.copyWith(
                  color: part.isOverLimit
                      ? AppColors.error
                      : AppColors.textSecondary,
                ),
              ),
              if (part.isOverLimit) ...[
                AppSpacing.horizontalGapXs,
                Icon(
                  Icons.warning,
                  size: 14,
                  color: AppColors.error,
                ),
              ],
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: AppColors.textSecondary,
              ),
              AppSpacing.horizontalGapSm,
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () => _copyToClipboard(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
