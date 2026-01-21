import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/utils/extensions.dart';
import '../data/models/thread_part.dart';
import 'thread_part_card.dart';

class ThreadPreview extends StatelessWidget {
  final Thread thread;
  final Function(int index) onEditPart;
  final VoidCallback onCopyAll;

  const ThreadPreview({
    super.key,
    required this.thread,
    required this.onEditPart,
    required this.onCopyAll,
  });

  void _copyAllToClipboard(BuildContext context) {
    final content = thread.parts.map((p) => p.content).join('\n\n---\n\n');
    Clipboard.setData(ClipboardData(text: content));
    context.showSnackBar(context.l10n.copiedToClipboard);
    onCopyAll();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Text(
              l10n.threadPreview,
              style: AppTypography.h3,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${thread.totalParts} parça',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        AppSpacing.verticalGapMd,

        // Thread parts
        ...thread.parts.map((part) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ThreadPartCard(
              part: part,
              totalParts: thread.totalParts,
              onEdit: () => onEditPart(part.index),
            ),
          );
        }),

        AppSpacing.verticalGapMd,

        // Copy all button
        AppButton(
          text: l10n.copyAll,
          variant: AppButtonVariant.secondary,
          onPressed: () => _copyAllToClipboard(context),
          icon: Icons.copy_all,
        ),
      ],
    );
  }
}
