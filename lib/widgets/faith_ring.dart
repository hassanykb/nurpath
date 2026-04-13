import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum RingType { quran, heart, salah, kindness, score }

class FaithRing extends StatelessWidget {
  final double percent; // 0.0 to 1.0
  final RingType type;
  final double radius;
  final bool showLabel;
  final String? labelOverride;
  final double lineWidth;
  final Widget? centerWidget;

  const FaithRing({
    super.key,
    required this.percent,
    required this.type,
    this.radius = 60,
    this.showLabel = true,
    this.labelOverride,
    this.lineWidth = 8,
    this.centerWidget,
  });

  Color get ringColor {
    switch (type) {
      case RingType.quran:
        return AppColors.ringQuran;
      case RingType.heart:
        return AppColors.ringHeart;
      case RingType.salah:
        return AppColors.ringSalah;
      case RingType.kindness:
        return AppColors.ringKindness;
      case RingType.score:
        return AppColors.ringScore;
    }
  }

  String get defaultLabel {
    switch (type) {
      case RingType.quran:
        return 'Quran';
      case RingType.heart:
        return 'Heart';
      case RingType.salah:
        return 'Salah';
      case RingType.kindness:
        return 'Kindness';
      case RingType.score:
        return 'Faith Score';
    }
  }

  IconData get icon {
    switch (type) {
      case RingType.quran:
        return Icons.menu_book_rounded;
      case RingType.heart:
        return Icons.favorite_rounded;
      case RingType.salah:
        return Icons.mosque_rounded;
      case RingType.kindness:
        return Icons.volunteer_activism_rounded;
      case RingType.score:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = labelOverride ?? defaultLabel;
    final percentText = '${(percent * 100).round()}%';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: radius,
          lineWidth: lineWidth,
          percent: percent.clamp(0.0, 1.0),
          center: centerWidget ??
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: radius * 0.35, color: ringColor),
                  const SizedBox(height: 2),
                  Text(
                    percentText,
                    style: AppTypography.scoreSmall.copyWith(
                      fontSize: radius * 0.28,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
          progressColor: ringColor,
          backgroundColor: AppColors.divider,
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 1200,
          curve: Curves.easeOutCubic,
        ),
        if (showLabel) ...[
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Large central score ring for the Faith Score dashboard
class ScoreRing extends StatelessWidget {
  final int score; // 0 to 100
  final String scoreLabel;

  const ScoreRing({
    super.key,
    required this.score,
    this.scoreLabel = 'Balanced Iman',
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 90,
      lineWidth: 12,
      percent: score / 100.0,
      center: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.mosque_rounded,
            size: 28,
            color: AppColors.gold,
          ),
          const SizedBox(height: 4),
          Text(
            '$score',
            style: AppTypography.scoreDisplay.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '/100',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            scoreLabel,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.gold,
            ),
          ),
        ],
      ),
      progressColor: AppColors.gold,
      backgroundColor: AppColors.divider,
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animationDuration: 1500,
      curve: Curves.easeOutCubic,
      linearGradient: const LinearGradient(
        colors: [AppColors.goldDark, AppColors.gold, AppColors.goldLight],
      ),
    );
  }
}
