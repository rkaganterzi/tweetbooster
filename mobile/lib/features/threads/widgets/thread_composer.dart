import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class ThreadComposer extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;

  const ThreadComposer({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            maxLines: 10,
            minLines: 6,
            onChanged: onChanged,
            style: AppTypography.body.copyWith(height: 1.5),
            decoration: InputDecoration(
              hintText: hintText ?? 'Thread içeriğinizi buraya yazın...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: AppSpacing.paddingMd,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                final characterCount = value.text.length;
                final wordCount = value.text.trim().isEmpty
                    ? 0
                    : value.text.trim().split(RegExp(r'\s+')).length;
                final estimatedParts = (characterCount / 250).ceil();

                return Row(
                  children: [
                    Icon(
                      Icons.text_fields,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$characterCount karakter',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.short_text,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$wordCount kelime',
                      style: AppTypography.caption,
                    ),
                    const Spacer(),
                    if (characterCount > 280) ...[
                      Icon(
                        Icons.list_alt,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '~$estimatedParts parça',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
