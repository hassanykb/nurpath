import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/app_providers.dart';
import '../../widgets/geometric_pattern.dart';
import '../../widgets/nurpath_card.dart';
import '../../widgets/faith_ring.dart';
import '../../widgets/streak_badge.dart';

class FaithScoreScreen extends ConsumerWidget {
  const FaithScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);
    final weekAsync = ref.watch(weekProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: GeometricPatternBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── AppBar ─────────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.bgPrimary,
                leading: const BackButton(color: AppColors.textPrimary),
                title: Text(
                  'Faith Score',
                  style: AppTypography.headlineMedium,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded,
                        color: AppColors.textSecondary),
                    onPressed: () => ref.refresh(userProfileProvider),
                  ),
                ],
              ),

              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Streak + Score Headline ────────────────
                    userAsync.when(
                      data: (user) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreakBadge(days: user?.currentStreak ?? 0),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your Faith Journey - ${user?.currentStreak ?? 0} Day Streak ✨',
                            style: AppTypography.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 24),

                    // ── Central Score Ring ─────────────────────
                    userAsync.when(
                      data: (user) => Center(
                        child: ScoreRing(
                          score: user?.faithScore ?? 0,
                          scoreLabel: _scoreLabel(user?.faithScore ?? 0),
                        ),
                      ),
                      loading: () => const SizedBox(height: 180),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 24),

                    // ── 4 Mini Rings ───────────────────────────
                    userAsync.when(
                      data: (user) => NurPathCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                FaithRing(
                                  percent: user?.quranEngagement ?? 0,
                                  type: RingType.quran,
                                  radius: 52,
                                  lineWidth: 7,
                                  labelOverride: 'Quran\nEngagement',
                                ),
                                FaithRing(
                                  percent: user?.heartReflection ?? 0,
                                  type: RingType.heart,
                                  radius: 52,
                                  lineWidth: 7,
                                  labelOverride: 'Heart\nReflection',
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                FaithRing(
                                  percent: user?.salahAlignment ?? 0,
                                  type: RingType.salah,
                                  radius: 52,
                                  lineWidth: 7,
                                  labelOverride: 'Salah\nAlignment',
                                ),
                                FaithRing(
                                  percent: user?.actsOfKindness ?? 0,
                                  type: RingType.kindness,
                                  radius: 52,
                                  lineWidth: 7,
                                  labelOverride: 'Acts of\nKindness',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      loading: () => const SizedBox(height: 200),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 20),

                    // ── Weekly Sparkline Chart ─────────────────
                    weekAsync.when(
                      data: (weekData) => _WeeklyChart(weekData: weekData),
                      loading: () => const SizedBox(height: 100),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),

                    // ── Insights Card ──────────────────────────
                    userAsync.when(
                      data: (user) => _InsightsCard(
                        quranPct: user?.quranEngagement ?? 0,
                        salahPct: user?.salahAlignment ?? 0,
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _scoreLabel(int score) {
    if (score >= 90) return 'Strong Iman';
    if (score >= 75) return 'Balanced Iman';
    if (score >= 50) return 'Growing Iman';
    return 'Building Iman';
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<dynamic> weekData;

  const _WeeklyChart({required this.weekData});

  @override
  Widget build(BuildContext context) {
    final spots = List.generate(7, (i) {
      final score =
          i < weekData.length ? weekData[i].faithScore.toDouble() : 0.0;
      return FlSpot(i.toDouble(), score);
    });

    return NurPathCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('7-Day Faith Trend', style: AppTypography.headlineSmall),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mo','Tu','We','Th','Fr','Sa','Su'];
                        final i = value.toInt();
                        if (i >= 0 && i < days.length) {
                          return Text(
                            days[i],
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 9,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.gold,
                    barWidth: 2.5,
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.gold.withOpacity(0.1),
                    ),
                    dotData: FlDotData(
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                        radius: 3,
                        color: AppColors.gold,
                        strokeWidth: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightsCard extends StatelessWidget {
  final double quranPct;
  final double salahPct;

  const _InsightsCard({
    required this.quranPct,
    required this.salahPct,
  });

  @override
  Widget build(BuildContext context) {
    final strength = quranPct > salahPct ? 'Quran Engagement' : 'Acts of Kindness';
    final grow = salahPct < 0.8 ? 'Consistent night prayer' : 'Heart reflection depth';

    return NurPathCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: AppColors.bgCardElevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline_rounded,
                  color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Text('This Week\'s Insights', style: AppTypography.titleMedium),
            ],
          ),
          const SizedBox(height: 10),
          _InsightRow(
            icon: Icons.star_rounded,
            color: AppColors.gold,
            label: 'Your strength this week:',
            value: 'Gratitude from Al-Baqarah.',
          ),
          const SizedBox(height: 6),
          _InsightRow(
            icon: Icons.trending_up_rounded,
            color: AppColors.emerald,
            label: 'Area to grow:',
            value: 'Consistent night prayer.',
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _InsightRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTypography.bodySmall,
              children: [
                TextSpan(
                  text: '$label ',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
