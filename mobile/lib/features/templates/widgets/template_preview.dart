import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/utils/extensions.dart';
import '../data/models/post_template.dart';

class TemplatePreviewSheet extends StatefulWidget {
  final PostTemplate template;
  final Function(String content) onUse;

  const TemplatePreviewSheet({
    super.key,
    required this.template,
    required this.onUse,
  });

  @override
  State<TemplatePreviewSheet> createState() => _TemplatePreviewSheetState();
}

class _TemplatePreviewSheetState extends State<TemplatePreviewSheet> {
  final Map<String, TextEditingController> _controllers = {};
  String _previewContent = '';

  @override
  void initState() {
    super.initState();
    _previewContent = widget.template.template;

    for (final placeholder in widget.template.placeholders) {
      _controllers[placeholder] = TextEditingController();
      _controllers[placeholder]!.addListener(_updatePreview);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updatePreview() {
    final values = <String, String>{};
    for (final entry in _controllers.entries) {
      values[entry.key] = entry.value.text.isNotEmpty
          ? entry.value.text
          : '{${entry.key}}';
    }

    setState(() {
      _previewContent = widget.template.applyPlaceholders(values);
    });
  }

  void _copyToClipboard() {
    final values = <String, String>{};
    for (final entry in _controllers.entries) {
      if (entry.value.text.isNotEmpty) {
        values[entry.key] = entry.value.text;
      }
    }
    final content = widget.template.applyPlaceholders(values);

    Clipboard.setData(ClipboardData(text: content));
    context.showSnackBar(context.l10n.copiedToClipboard);
  }

  void _useTemplate() {
    final values = <String, String>{};
    for (final entry in _controllers.entries) {
      if (entry.value.text.isNotEmpty) {
        values[entry.key] = entry.value.text;
      }
    }
    final content = widget.template.applyPlaceholders(values);
    widget.onUse(content);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          AppSpacing.verticalGapMd,

          // Title
          Text(
            widget.template.name,
            style: AppTypography.h3,
          ),

          AppSpacing.verticalGapXs,

          Text(
            widget.template.description,
            style: AppTypography.caption,
          ),

          AppSpacing.verticalGapMd,

          // Placeholder inputs
          if (widget.template.hasPlaceholders) ...[
            Text(
              'Alanları Doldur',
              style: AppTypography.label,
            ),
            AppSpacing.verticalGapSm,
            ...widget.template.placeholders.map((placeholder) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppTextField(
                  controller: _controllers[placeholder],
                  labelText: placeholder.capitalize,
                  hintText: '$placeholder girin...',
                ),
              );
            }),
          ],

          // Preview
          Text(
            'Önizleme',
            style: AppTypography.label,
          ),
          AppSpacing.verticalGapSm,
          Container(
            width: double.infinity,
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(color: AppColors.border),
            ),
            child: SelectableText(
              _previewContent,
              style: AppTypography.body.copyWith(height: 1.5),
            ),
          ),

          AppSpacing.verticalGapLg,

          // Actions
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: context.l10n.copyToClipboard,
                  variant: AppButtonVariant.secondary,
                  onPressed: _copyToClipboard,
                  icon: Icons.copy,
                ),
              ),
              AppSpacing.horizontalGapSm,
              Expanded(
                child: AppButton(
                  text: context.l10n.useTemplate,
                  onPressed: _useTemplate,
                  icon: Icons.check,
                ),
              ),
            ],
          ),

          // Safe area for bottom
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
