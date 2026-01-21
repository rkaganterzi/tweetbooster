import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/extensions.dart';
import '../providers/competitor_provider.dart';
import '../widgets/comparison_card.dart';

class CompetitorHistoryScreen extends ConsumerStatefulWidget {
  const CompetitorHistoryScreen({super.key});

  @override
  ConsumerState<CompetitorHistoryScreen> createState() =>
      _CompetitorHistoryScreenState();
}

class _CompetitorHistoryScreenState
    extends ConsumerState<CompetitorHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(competitorControllerProvider.notifier).loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(competitorControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Geçmiş Analizler'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: AppColors.textMuted,
                      ),
                      AppSpacing.verticalGapMd,
                      Text(
                        'Henüz analiz geçmişi yok',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.verticalGapSm,
                      Text(
                        'Rakip analizleri burada görünecek',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: AppSpacing.screenPadding,
                  itemCount: state.history.length,
                  separatorBuilder: (_, __) => AppSpacing.verticalGapMd,
                  itemBuilder: (context, index) {
                    final analysis = state.history[index];
                    return ComparisonCard(
                      competitorAnalysis: analysis,
                      onDelete: analysis.id != null
                          ? () => _confirmDelete(analysis.id!)
                          : null,
                      onViewDetails: () {
                        // Could navigate to detail screen
                        _showAnalysisDetails(analysis);
                      },
                    );
                  },
                ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Analizi Sil'),
        content: const Text('Bu analizi silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(competitorControllerProvider.notifier).deleteAnalysis(id);
              Navigator.pop(context);
              context.showSnackBar('Analiz silindi');
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void _showAnalysisDetails(competitorAnalysis) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          final analysis = competitorAnalysis.analysis;
          return SingleChildScrollView(
            controller: scrollController,
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Analiz Detayları',
                  style: AppTypography.h3,
                ),
                AppSpacing.verticalGapMd,
                Text(
                  competitorAnalysis.competitorContent,
                  style: AppTypography.body,
                ),
                AppSpacing.verticalGapLg,
                _DetailRow('Genel Skor', '${analysis.overallScore.toStringAsFixed(0)}/100'),
                _DetailRow('Beğeni Potansiyeli', '${analysis.engagementScores.likeability.toStringAsFixed(0)}'),
                _DetailRow('RT Potansiyeli', '${analysis.engagementScores.retweetability.toStringAsFixed(0)}'),
                _DetailRow('Yanıt Potansiyeli', '${analysis.engagementScores.replyability.toStringAsFixed(0)}'),
                _DetailRow('Kaydetme Potansiyeli', '${analysis.engagementScores.bookmarkability.toStringAsFixed(0)}'),
                if (competitorAnalysis.notes != null) ...[
                  AppSpacing.verticalGapMd,
                  Text(
                    'Notlar',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    competitorAnalysis.notes!,
                    style: AppTypography.body,
                  ),
                ],
                AppSpacing.verticalGapXl,
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
