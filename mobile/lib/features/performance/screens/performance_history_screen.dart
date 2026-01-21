import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/utils/extensions.dart';
import '../providers/performance_provider.dart';
import '../widgets/trends_chart.dart';
import '../data/models/performance_tracking.dart';

class PerformanceHistoryScreen extends ConsumerStatefulWidget {
  const PerformanceHistoryScreen({super.key});

  @override
  ConsumerState<PerformanceHistoryScreen> createState() =>
      _PerformanceHistoryScreenState();
}

class _PerformanceHistoryScreenState
    extends ConsumerState<PerformanceHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(performanceControllerProvider.notifier).loadHistory();
      ref.read(performanceControllerProvider.notifier).loadTrends();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(performanceControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Performans Geçmişi'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(performanceControllerProvider.notifier).loadHistory();
                await ref.read(performanceControllerProvider.notifier).loadTrends();
              },
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Trends chart
                    if (state.trends != null) ...[
                      TrendsChart(trends: state.trends!),
                      AppSpacing.verticalGapLg,
                    ],

                    // History list header
                    Row(
                      children: [
                        const Icon(
                          Icons.history,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Son Kayıtlar',
                          style: AppTypography.h3,
                        ),
                      ],
                    ),

                    AppSpacing.verticalGapMd,

                    if (state.history.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.bar_chart,
                                size: 64,
                                color: AppColors.textMuted,
                              ),
                              AppSpacing.verticalGapMd,
                              Text(
                                'Henüz performans kaydı yok',
                                style: AppTypography.body.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...state.history.map((record) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _HistoryCard(
                              record: record,
                              onDelete: record.id != null
                                  ? () => _confirmDelete(record.id!)
                                  : null,
                            ),
                          )),

                    AppSpacing.verticalGapXl,
                  ],
                ),
              ),
            ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Kaydı Sil'),
        content: const Text('Bu performans kaydını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(performanceControllerProvider.notifier).deleteRecord(id);
              Navigator.pop(context);
              context.showSnackBar('Kayıt silindi');
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final PerformanceTracking record;
  final VoidCallback? onDelete;

  const _HistoryCard({
    required this.record,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.bar_chart,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatDate(record.createdAt),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
              if (record.accuracyScore != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getAccuracyColor(record.accuracyScore!).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Doğruluk: ${record.accuracyScore!.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 11,
                      color: _getAccuracyColor(record.accuracyScore!),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          AppSpacing.verticalGapMd,

          // Metrics row
          Row(
            children: [
              _MetricItem(
                icon: Icons.favorite,
                value: record.actualLikes,
                color: Colors.red,
              ),
              _MetricItem(
                icon: Icons.repeat,
                value: record.actualRetweets,
                color: Colors.green,
              ),
              _MetricItem(
                icon: Icons.chat_bubble,
                value: record.actualReplies,
                color: Colors.blue,
              ),
              _MetricItem(
                icon: Icons.visibility,
                value: record.actualImpressions,
                color: Colors.orange,
              ),
            ],
          ),

          // Post content preview
          if (record.postContent != null) ...[
            AppSpacing.verticalGapMd,
            Text(
              record.postContent!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],

          // Delete action
          if (onDelete != null) ...[
            AppSpacing.verticalGapSm,
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline, size: 16),
                label: const Text('Sil'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return AppColors.success;
    if (accuracy >= 60) return AppColors.primary;
    if (accuracy >= 40) return AppColors.warning;
    return AppColors.error;
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final int? value;
  final Color color;

  const _MetricItem({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            _formatNumber(value ?? 0),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
