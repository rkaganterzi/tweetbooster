import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class DaySelector extends StatelessWidget {
  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  const DaySelector({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final days = [
      'Pzt',
      'Sal',
      'Çar',
      'Per',
      'Cum',
      'Cmt',
      'Paz',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(7, (index) {
          final isSelected = index == selectedDay;
          final isToday = index == DateTime.now().weekday - 1;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onDaySelected(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : isToday
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : isToday
                            ? AppColors.primary.withOpacity(0.5)
                            : AppColors.border,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      days[index],
                      style: AppTypography.bodySmall.copyWith(
                        color: isSelected
                            ? Colors.white
                            : isToday
                                ? AppColors.primary
                                : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    if (isToday) ...[
                      const SizedBox(height: 2),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
