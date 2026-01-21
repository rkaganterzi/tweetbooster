import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';

class CompetitorInput extends StatelessWidget {
  final TextEditingController contentController;
  final TextEditingController? sourceUrlController;
  final TextEditingController? notesController;
  final ValueChanged<String>? onContentChanged;
  final bool showOptionalFields;
  final VoidCallback? onToggleOptional;

  const CompetitorInput({
    super.key,
    required this.contentController,
    this.sourceUrlController,
    this.notesController,
    this.onContentChanged,
    this.showOptionalFields = false,
    this.onToggleOptional,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rakip Tweeti',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSpacing.verticalGapSm,
              TextField(
                controller: contentController,
                maxLines: 5,
                maxLength: 280,
                onChanged: onContentChanged,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Rakibin tweet içeriğini buraya yapıştırın...',
                  hintStyle: TextStyle(
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  counterStyle: TextStyle(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),

        AppSpacing.verticalGapMd,

        // Optional fields toggle
        if (onToggleOptional != null)
          GestureDetector(
            onTap: onToggleOptional,
            child: Row(
              children: [
                Icon(
                  showOptionalFields
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  showOptionalFields ? 'Detayları Gizle' : 'Detay Ekle (İsteğe Bağlı)',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

        // Optional fields
        if (showOptionalFields && sourceUrlController != null) ...[
          AppSpacing.verticalGapMd,
          AppTextField(
            controller: sourceUrlController!,
            labelText: 'Kaynak URL',
            hintText: 'https://x.com/user/status/...',
            keyboardType: TextInputType.url,
          ),
        ],

        if (showOptionalFields && notesController != null) ...[
          AppSpacing.verticalGapSm,
          AppTextField(
            controller: notesController!,
            labelText: 'Notlar',
            hintText: 'Bu rakip hakkında notlarınız...',
            maxLines: 2,
          ),
        ],
      ],
    );
  }
}
