import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../data/models/performance_tracking.dart';

class MetricsDisplay extends StatelessWidget {
  final ExtractedMetrics metrics;
  final double? accuracyScore;
  final bool isEditable;
  final ValueChanged<ExtractedMetrics>? onMetricsChanged;

  const MetricsDisplay({
    super.key,
    required this.metrics,
    this.accuracyScore,
    this.isEditable = false,
    this.onMetricsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Çıkarılan Metrikler',
                style: AppTypography.h3,
              ),
              const Spacer(),
              if (metrics.confidence > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor(metrics.confidence).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Güven: ${metrics.confidence.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: _getConfidenceColor(metrics.confidence),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          AppSpacing.verticalGapMd,

          // Metrics Grid
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.3,
            children: [
              _MetricTile(
                icon: Icons.favorite,
                label: 'Beğeni',
                value: metrics.likes,
                color: Colors.red,
                isEditable: isEditable,
                onChanged: (v) => _updateMetric('likes', v),
              ),
              _MetricTile(
                icon: Icons.repeat,
                label: 'RT',
                value: metrics.retweets,
                color: Colors.green,
                isEditable: isEditable,
                onChanged: (v) => _updateMetric('retweets', v),
              ),
              _MetricTile(
                icon: Icons.chat_bubble,
                label: 'Yanıt',
                value: metrics.replies,
                color: Colors.blue,
                isEditable: isEditable,
                onChanged: (v) => _updateMetric('replies', v),
              ),
              _MetricTile(
                icon: Icons.format_quote,
                label: 'Alıntı',
                value: metrics.quotes,
                color: Colors.purple,
                isEditable: isEditable,
                onChanged: (v) => _updateMetric('quotes', v),
              ),
              _MetricTile(
                icon: Icons.visibility,
                label: 'Görüntüleme',
                value: metrics.impressions,
                color: Colors.orange,
                isEditable: isEditable,
                onChanged: (v) => _updateMetric('impressions', v),
              ),
              _MetricTile(
                icon: Icons.bookmark,
                label: 'Kaydet',
                value: metrics.bookmarks,
                color: Colors.teal,
                isEditable: isEditable,
                onChanged: (v) => _updateMetric('bookmarks', v),
              ),
            ],
          ),

          if (accuracyScore != null) ...[
            AppSpacing.verticalGapMd,
            _AccuracyIndicator(accuracy: accuracyScore!),
          ],

          if (metrics.totalEngagement != null && metrics.totalEngagement! > 0) ...[
            AppSpacing.verticalGapMd,
            Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Toplam Etkileşim: ',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  Text(
                    _formatNumber(metrics.totalEngagement!),
                    style: AppTypography.h3.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _updateMetric(String key, int? value) {
    if (onMetricsChanged == null) return;

    final updated = ExtractedMetrics(
      likes: key == 'likes' ? value : metrics.likes,
      retweets: key == 'retweets' ? value : metrics.retweets,
      replies: key == 'replies' ? value : metrics.replies,
      quotes: key == 'quotes' ? value : metrics.quotes,
      impressions: key == 'impressions' ? value : metrics.impressions,
      bookmarks: key == 'bookmarks' ? value : metrics.bookmarks,
      confidence: metrics.confidence,
    );

    onMetricsChanged!(updated);
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) return AppColors.success;
    if (confidence >= 50) return AppColors.warning;
    return AppColors.error;
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

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? value;
  final Color color;
  final bool isEditable;
  final ValueChanged<int?>? onChanged;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isEditable = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          if (isEditable && onChanged != null)
            GestureDetector(
              onTap: () => _showEditDialog(context),
              child: Text(
                value?.toString() ?? '-',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          else
            Text(
              value?.toString() ?? '-',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: value?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('$label Düzenle'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Değer girin',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final newValue = int.tryParse(controller.text);
              onChanged?.call(newValue);
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}

class _AccuracyIndicator extends StatelessWidget {
  final double accuracy;

  const _AccuracyIndicator({required this.accuracy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getColor().withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            _getIcon(),
            color: _getColor(),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tahmin Doğruluğu',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${accuracy.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: _getColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _getLabel(),
            style: TextStyle(
              color: _getColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    if (accuracy >= 80) return AppColors.success;
    if (accuracy >= 60) return AppColors.primary;
    if (accuracy >= 40) return AppColors.warning;
    return AppColors.error;
  }

  IconData _getIcon() {
    if (accuracy >= 80) return Icons.check_circle;
    if (accuracy >= 60) return Icons.thumb_up;
    if (accuracy >= 40) return Icons.info;
    return Icons.warning;
  }

  String _getLabel() {
    if (accuracy >= 80) return 'Mükemmel';
    if (accuracy >= 60) return 'İyi';
    if (accuracy >= 40) return 'Orta';
    return 'Düşük';
  }
}
