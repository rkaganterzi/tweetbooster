import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../constants/app_spacing.dart';
import '../constants/algorithm_weights.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.autofocus = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTypography.label,
          ),
          AppSpacing.verticalGapSm,
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          enabled: enabled,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          focusNode: focusNode,
          autofocus: autofocus,
          validator: validator,
          style: AppTypography.body,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            counterText: '',
          ),
        ),
      ],
    );
  }
}

class PostTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool showCharacterCount;
  final int maxLength;

  const PostTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.showCharacterCount = true,
    this.maxLength = AlgorithmWeights.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppSpacing.borderRadiusMd,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              TextField(
                controller: controller,
                maxLines: 6,
                minLines: 4,
                maxLength: maxLength,
                onChanged: onChanged,
                style: AppTypography.body.copyWith(height: 1.5),
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: AppSpacing.paddingMd,
                  counterText: '',
                ),
              ),
              if (showCharacterCount)
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    final count = value.text.length;
                    final isOverLimit = count > maxLength;
                    final isNearLimit = count > maxLength * 0.9;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Character count circle (X style)
                          _CharacterCountIndicator(
                            current: count,
                            max: maxLength,
                          ),
                          AppSpacing.horizontalGapSm,
                          Text(
                            '$count/$maxLength',
                            style: AppTypography.caption.copyWith(
                              color: isOverLimit
                                  ? AppColors.error
                                  : isNearLimit
                                      ? AppColors.warning
                                      : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CharacterCountIndicator extends StatelessWidget {
  final int current;
  final int max;

  const _CharacterCountIndicator({
    required this.current,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final progress = current / max;
    final isOverLimit = progress > 1;
    final isNearLimit = progress > 0.9;

    Color progressColor;
    if (isOverLimit) {
      progressColor = AppColors.error;
    } else if (isNearLimit) {
      progressColor = AppColors.warning;
    } else {
      progressColor = AppColors.primary;
    }

    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress.clamp(0, 1),
            strokeWidth: 2.5,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
          if (isOverLimit)
            Text(
              '-${current - max}',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
        ],
      ),
    );
  }
}
