import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/utils/extensions.dart';
import '../data/models/suggestion.dart';

class SuggestionsList extends StatelessWidget {
  final List<Suggestion> suggestions;

  const SuggestionsList({
    super.key,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return AppCard(
        child: Column(
          children: [
            Text(
              context.l10n.suggestions,
              style: AppTypography.h3,
            ),
            AppSpacing.verticalGapMd,
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: AppColors.success,
            ),
            AppSpacing.verticalGapSm,
            Text(
              context.l10n.noSuggestions,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.l10n.suggestions,
                style: AppTypography.h3,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${suggestions.length}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGapMd,
          ...suggestions.asMap().entries.map((entry) {
            final index = entry.key;
            final suggestion = entry.value;
            return _SuggestionItem(
              suggestion: suggestion,
              isLast: index == suggestions.length - 1,
            );
          }),
        ],
      ),
    );
  }
}

class _SuggestionItem extends StatefulWidget {
  final Suggestion suggestion;
  final bool isLast;

  const _SuggestionItem({
    required this.suggestion,
    this.isLast = false,
  });

  @override
  State<_SuggestionItem> createState() => _SuggestionItemState();
}

class _SuggestionItemState extends State<_SuggestionItem> {
  bool _isExpanded = false;

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.copiedToClipboard),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            borderRadius: AppSpacing.borderRadiusMd,
            child: Padding(
              padding: AppSpacing.paddingMd,
              child: Row(
                children: [
                  _buildPriorityIndicator(widget.suggestion.priority),
                  AppSpacing.horizontalGapSm,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.suggestion.title,
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (!_isExpanded) ...[
                          AppSpacing.verticalGapXs,
                          Text(
                            widget.suggestion.description,
                            style: AppTypography.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: AppColors.border),
                  AppSpacing.verticalGapSm,
                  Text(
                    widget.suggestion.description,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  // AI-generated improved content
                  if (widget.suggestion.hasImprovement) ...[
                    AppSpacing.verticalGapMd,
                    Container(
                      width: double.infinity,
                      padding: AppSpacing.paddingMd,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.1),
                            AppColors.primary.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: AppSpacing.borderRadiusMd,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              AppSpacing.horizontalGapXs,
                              Text(
                                'Düzenlenmiş Hali',
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () => _copyToClipboard(context, widget.suggestion.improvedContent!),
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.copy,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.verticalGapSm,
                          Text(
                            widget.suggestion.improvedContent!,
                            style: AppTypography.body.copyWith(
                              height: 1.5,
                            ),
                          ),
                          AppSpacing.verticalGapSm,
                          Text(
                            '${widget.suggestion.improvedContent!.length} karakter',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (widget.suggestion.example != null) ...[
                    AppSpacing.verticalGapMd,
                    Container(
                      width: double.infinity,
                      padding: AppSpacing.paddingSm,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Örnek:',
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          AppSpacing.verticalGapXs,
                          Text(
                            widget.suggestion.example!,
                            style: AppTypography.bodySmall.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (widget.suggestion.impactScore != null && widget.suggestion.impactScore! > 0) ...[
                    AppSpacing.verticalGapMd,
                    Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          size: 16,
                          color: AppColors.success,
                        ),
                        AppSpacing.horizontalGapXs,
                        Text(
                          'Tahmini etki: +${(widget.suggestion.impactScore! * 100).toInt()}%',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
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

  Widget _buildPriorityIndicator(SuggestionPriority priority) {
    Color color;
    IconData icon;

    switch (priority) {
      case SuggestionPriority.high:
        color = AppColors.error;
        icon = Icons.priority_high;
        break;
      case SuggestionPriority.medium:
        color = AppColors.warning;
        icon = Icons.remove;
        break;
      case SuggestionPriority.low:
        color = AppColors.success;
        icon = Icons.keyboard_arrow_down;
        break;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 18,
        color: color,
      ),
    );
  }
}
