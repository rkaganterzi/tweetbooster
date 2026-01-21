import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/utils/extensions.dart';
import '../data/models/warning.dart';

class WarningsList extends StatelessWidget {
  final List<Warning> warnings;

  const WarningsList({
    super.key,
    required this.warnings,
  });

  @override
  Widget build(BuildContext context) {
    if (warnings.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppCard(
      backgroundColor: AppColors.error.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: 20,
              ),
              AppSpacing.horizontalGapSm,
              Text(
                context.l10n.warnings,
                style: AppTypography.h3.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGapMd,
          ...warnings.map((warning) => _WarningItem(warning: warning)),
        ],
      ),
    );
  }
}

class _WarningItem extends StatelessWidget {
  final Warning warning;

  const _WarningItem({required this.warning});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: AppSpacing.paddingSm,
      decoration: BoxDecoration(
        color: _getSeverityColor(warning.severity).withOpacity(0.1),
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(
          color: _getSeverityColor(warning.severity).withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getSeverityIcon(warning.severity),
            size: 18,
            color: _getSeverityColor(warning.severity),
          ),
          AppSpacing.horizontalGapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warning.title,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: _getSeverityColor(warning.severity),
                  ),
                ),
                AppSpacing.verticalGapXs,
                Text(
                  warning.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (warning.recommendation != null) ...[
                  AppSpacing.verticalGapSm,
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      AppSpacing.horizontalGapXs,
                      Expanded(
                        child: Text(
                          warning.recommendation!,
                          style: AppTypography.caption.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(WarningSeverity severity) {
    switch (severity) {
      case WarningSeverity.critical:
        return AppColors.error;
      case WarningSeverity.warning:
        return AppColors.warning;
      case WarningSeverity.info:
        return AppColors.info;
    }
  }

  IconData _getSeverityIcon(WarningSeverity severity) {
    switch (severity) {
      case WarningSeverity.critical:
        return Icons.error;
      case WarningSeverity.warning:
        return Icons.warning;
      case WarningSeverity.info:
        return Icons.info_outline;
    }
  }
}
