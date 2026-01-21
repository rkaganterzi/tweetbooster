import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/extensions.dart';
import '../data/models/generated_post.dart';

class StyleSelector extends StatelessWidget {
  final PostStyle selectedStyle;
  final ValueChanged<PostStyle> onStyleChanged;

  const StyleSelector({
    super.key,
    required this.selectedStyle,
    required this.onStyleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.style,
          style: AppTypography.label,
        ),
        AppSpacing.verticalGapSm,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PostStyle.values.map((style) {
            final isSelected = style == selectedStyle;
            return _StyleChip(
              style: style,
              isSelected: isSelected,
              onTap: () => onStyleChanged(style),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StyleChip extends StatelessWidget {
  final PostStyle style;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleChip({
    required this.style,
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
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              style.icon,
              size: 18,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            AppSpacing.horizontalGapSm,
            Text(
              style.label,
              style: AppTypography.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
