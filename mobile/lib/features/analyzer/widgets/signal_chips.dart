import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/utils/extensions.dart';
import '../data/models/post_analysis.dart';

class SignalChips extends StatelessWidget {
  final AlgorithmSignals signals;

  const SignalChips({
    super.key,
    required this.signals,
  });

  @override
  Widget build(BuildContext context) {
    final signalList = signals.toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.algorithmSignals,
            style: AppTypography.h3,
          ),
          AppSpacing.verticalGapMd,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: signalList.map((signal) {
              return _SignalChip(
                label: signal.label,
                isActive: signal.isActive,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SignalChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _SignalChip({
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withOpacity(0.15)
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? AppColors.success.withOpacity(0.5)
              : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isActive ? AppColors.success : AppColors.textMuted,
          ),
          AppSpacing.horizontalGapXs,
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: isActive ? AppColors.success : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
