import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../data/models/performance_tracking.dart';

class TrendsChart extends StatelessWidget {
  final PerformanceTrends trends;

  const TrendsChart({
    super.key,
    required this.trends,
  });

  @override
  Widget build(BuildContext context) {
    if (trends.trend.isEmpty) {
      return AppCard(
        child: Column(
          children: [
            const Icon(
              Icons.show_chart,
              color: AppColors.textMuted,
              size: 48,
            ),
            AppSpacing.verticalGapMd,
            Text(
              'Henüz trend verisi yok',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.verticalGapSm,
            Text(
              'Birkaç performans kaydı ekledikten sonra\ntrend grafikleri burada görünecek',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
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
              const Icon(
                Icons.trending_up,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Etkileşim Trendi',
                style: AppTypography.h3,
              ),
            ],
          ),

          AppSpacing.verticalGapMd,

          // Summary stats
          Row(
            children: [
              _StatBox(
                label: 'Toplam Analiz',
                value: trends.totalAnalyses.toString(),
                icon: Icons.analytics,
              ),
              AppSpacing.horizontalGapSm,
              _StatBox(
                label: 'Ort. Doğruluk',
                value: trends.averageAccuracy != null
                    ? '${trends.averageAccuracy!.toStringAsFixed(0)}%'
                    : '-',
                icon: Icons.check_circle_outline,
              ),
              AppSpacing.horizontalGapSm,
              _StatBox(
                label: 'Ort. Etkileşim',
                value: trends.averageEngagement != null
                    ? trends.averageEngagement!.toStringAsFixed(0)
                    : '-',
                icon: Icons.favorite_outline,
              ),
            ],
          ),

          AppSpacing.verticalGapLg,

          // Chart
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateInterval(),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.border,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= trends.trend.length) {
                          return const SizedBox.shrink();
                        }
                        final point = trends.trend[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${point.date.day}/${point.date.month}',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: _calculateInterval(),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Likes
                  LineChartBarData(
                    spots: trends.trend.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.likes.toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                  // Retweets
                  LineChartBarData(
                    spots: trends.trend.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.retweets.toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                  // Replies
                  LineChartBarData(
                    spots: trends.trend.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.replies.toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        String label;
                        if (spot.barIndex == 0) label = 'Beğeni';
                        else if (spot.barIndex == 1) label = 'RT';
                        else label = 'Yanıt';
                        return LineTooltipItem(
                          '$label: ${spot.y.toInt()}',
                          TextStyle(color: spot.bar.color),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),

          AppSpacing.verticalGapMd,

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(color: Colors.red, label: 'Beğeni'),
              const SizedBox(width: 16),
              _LegendItem(color: Colors.green, label: 'RT'),
              const SizedBox(width: 16),
              _LegendItem(color: Colors.blue, label: 'Yanıt'),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateInterval() {
    if (trends.trend.isEmpty) return 10;
    final maxValue = trends.trend.fold<int>(0, (max, point) {
      final total = point.likes + point.retweets + point.replies;
      return total > max ? total : max;
    });
    if (maxValue <= 10) return 2;
    if (maxValue <= 50) return 10;
    if (maxValue <= 100) return 20;
    return (maxValue / 5).roundToDouble();
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
