import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class HourGrid extends StatelessWidget {
  final List<List<double>> heatmapData;
  final Function(int day, int hour)? onCellTap;

  const HourGrid({
    super.key,
    required this.heatmapData,
    this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    if (heatmapData.isEmpty) {
      return const SizedBox.shrink();
    }

    final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final hours = List.generate(24, (i) => i);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hour labels (top)
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Row(
            children: [0, 6, 12, 18, 23].map((hour) {
              return Expanded(
                child: Text(
                  '$hour:00',
                  style: AppTypography.caption.copyWith(fontSize: 9),
                ),
              );
            }).toList(),
          ),
        ),
        AppSpacing.verticalGapXs,
        // Grid
        ...List.generate(7, (dayIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              children: [
                // Day label
                SizedBox(
                  width: 28,
                  child: Text(
                    days[dayIndex],
                    style: AppTypography.caption.copyWith(fontSize: 10),
                  ),
                ),
                // Hour cells
                Expanded(
                  child: Row(
                    children: hours.map((hour) {
                      final value = dayIndex < heatmapData.length &&
                              hour < heatmapData[dayIndex].length
                          ? heatmapData[dayIndex][hour]
                          : 0.0;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onCellTap?.call(dayIndex, hour),
                          child: Container(
                            height: 20,
                            margin: const EdgeInsets.all(0.5),
                            decoration: BoxDecoration(
                              color: _getHeatColor(value),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }),
        AppSpacing.verticalGapSm,
        // Legend
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Düşük',
          style: AppTypography.caption.copyWith(fontSize: 10),
        ),
        AppSpacing.horizontalGapSm,
        ...List.generate(5, (i) {
          return Container(
            width: 20,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: _getHeatColor(i * 0.25),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
        AppSpacing.horizontalGapSm,
        Text(
          'Yüksek',
          style: AppTypography.caption.copyWith(fontSize: 10),
        ),
      ],
    );
  }

  Color _getHeatColor(double value) {
    if (value >= 0.9) return AppColors.scoreExcellent;
    if (value >= 0.7) return AppColors.scoreGood;
    if (value >= 0.5) return AppColors.scoreMedium;
    if (value >= 0.3) return AppColors.warning.withOpacity(0.5);
    return AppColors.surfaceLight;
  }
}
