import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/extensions.dart';
import '../data/models/generation_request.dart';

class EngagementTargetSelector extends StatelessWidget {
  final EngagementTarget? selectedTarget;
  final ValueChanged<EngagementTarget?> onTargetChanged;

  const EngagementTargetSelector({
    super.key,
    this.selectedTarget,
    required this.onTargetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.targetEngagement,
          style: AppTypography.label,
        ),
        AppSpacing.verticalGapSm,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: EngagementTarget.values.map((target) {
              final isSelected = target == selectedTarget;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _TargetChip(
                  target: target,
                  isSelected: isSelected,
                  onTap: () {
                    if (isSelected) {
                      onTargetChanged(null);
                    } else {
                      onTargetChanged(target);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _TargetChip extends StatelessWidget {
  final EngagementTarget target;
  final bool isSelected;
  final VoidCallback onTap;

  const _TargetChip({
    required this.target,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? _getTargetColor(target).withOpacity(0.15)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _getTargetColor(target) : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getTargetIcon(target),
              size: 18,
              color:
                  isSelected ? _getTargetColor(target) : AppColors.textSecondary,
            ),
            AppSpacing.horizontalGapSm,
            Text(
              target.label,
              style: AppTypography.bodySmall.copyWith(
                color: isSelected
                    ? _getTargetColor(target)
                    : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTargetColor(EngagementTarget target) {
    switch (target) {
      case EngagementTarget.likes:
        return AppColors.error;
      case EngagementTarget.replies:
        return AppColors.info;
      case EngagementTarget.retweets:
        return AppColors.success;
      case EngagementTarget.bookmarks:
        return AppColors.warning;
      case EngagementTarget.viral:
        return AppColors.primary;
    }
  }

  IconData _getTargetIcon(EngagementTarget target) {
    switch (target) {
      case EngagementTarget.likes:
        return Icons.favorite_outline;
      case EngagementTarget.replies:
        return Icons.chat_bubble_outline;
      case EngagementTarget.retweets:
        return Icons.repeat;
      case EngagementTarget.bookmarks:
        return Icons.bookmark_outline;
      case EngagementTarget.viral:
        return Icons.trending_up;
    }
  }
}
