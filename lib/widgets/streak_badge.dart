import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class StreakBadge extends StatelessWidget {
  final int days;
  final bool isActive;

  const StreakBadge({
    super.key,
    required this.days,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: isActive ? AppColors.goldGradient : null,
        color: isActive ? null : AppColors.bgCardElevated,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.shadowGold.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🔥',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 4),
          Text(
            '$days Day${days != 1 ? 's' : ''}',
            style: AppTypography.labelLarge.copyWith(
              color: isActive ? AppColors.textOnGold : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyStreakCalendar extends StatelessWidget {
  final List<bool> daysCompleted; // 7 days, true = completed
  final List<String> dayLabels;

  const WeeklyStreakCalendar({
    super.key,
    required this.daysCompleted,
    this.dayLabels = const ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        daysCompleted.length.clamp(0, 7),
        (i) {
          final label = i < dayLabels.length ? dayLabels[i] : '';
          final completed = daysCompleted[i];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: completed
                      ? AppColors.gold.withOpacity(0.15)
                      : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: completed ? AppColors.gold : AppColors.divider,
                    width: completed ? 1.5 : 0.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    completed ? '🔥' : '',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
