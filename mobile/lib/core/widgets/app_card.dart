import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool hasBorder;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius ?? AppSpacing.borderRadiusLg,
        border: hasBorder
            ? Border.all(color: AppColors.border, width: 1)
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

class AppCardHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const AppCardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                AppSpacing.verticalGapXs,
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
