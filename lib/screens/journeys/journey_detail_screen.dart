import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../models/user_model.dart';
import '../../providers/app_providers.dart';
import '../../services/db_service.dart';
import '../../widgets/geometric_pattern.dart';
import '../../widgets/nurpath_card.dart';

class JourneyDetailScreen extends ConsumerWidget {
  final ThematicJourney journey;

  const JourneyDetailScreen({super.key, required this.journey});

  List<Color> get _gradientColors {
    final id = journey.id;
    if (id == 'healing-heart') return [AppColors.emerald, AppColors.emeraldDeep];
    if (id == 'building-patience') return [const Color(0xFF2C4A6B), const Color(0xFF1A2E44)];
    if (id == 'gratitude-daily') return [const Color(0xFF3D5A3E), AppColors.emeraldDeep];
    return [const Color(0xFF4A3728), const Color(0xFF2A1F18)];
  }

  String get _emoji {
    final id = journey.id;
    if (id == 'healing-heart') return '🕌';
    if (id == 'building-patience') return '🤲';
    if (id == 'gratitude-daily') return '🌿';
    return '📖';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pct = journey.progress;
    final remaining = journey.totalDays - journey.completedDays;
    final isComplete = journey.completedDays >= journey.totalDays;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: GeometricPatternBackground(
        child: CustomScrollView(
          slivers: [
            // ── Hero Header ──────────────────────────────────
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: _gradientColors.last,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _gradientColors,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: GeometricPatternPainter(opacity: 0.07),
                        ),
                      ),
                      // Progress bar at very bottom
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: LinearProgressIndicator(
                          value: pct,
                          backgroundColor: Colors.black.withOpacity(0.25),
                          color: AppColors.gold,
                          minHeight: 4,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            // Big emoji circle
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.25),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _emoji,
                                  style: const TextStyle(fontSize: 40),
                                ),
                              ),
                            ).animate().scale(duration: 400.ms, curve: Curves.easeOut),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                journey.title,
                                style: AppTypography.headlineLarge.copyWith(
                                  color: Colors.white,
                                  fontFamily: 'Amiri',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              journey.surahReference,
                              style: AppTypography.surahRef.copyWith(
                                color: AppColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // ── Progress Summary ──────────────────────────
                  _ProgressSummaryRow(
                    completedDays: journey.completedDays,
                    totalDays: journey.totalDays,
                    pct: pct,
                    remaining: remaining,
                    isComplete: isComplete,
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 20),

                  // ── Description ───────────────────────────────
                  if (journey.description.isNotEmpty) ...[
                    Text('About This Journey', style: AppTypography.headlineSmall),
                    const SizedBox(height: 8),
                    NurPathCard(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        journey.description,
                        style: AppTypography.bodyMedium.copyWith(height: 1.6),
                      ),
                    ).animate().fadeIn(delay: 150.ms),
                    const SizedBox(height: 20),
                  ],

                  // ── Today's Lesson ────────────────────────────
                  if (journey.dailyLessons.isNotEmpty && !isComplete) ...[
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny_rounded,
                            color: AppColors.gold, size: 18),
                        const SizedBox(width: 8),
                        Text("Today's Focus", style: AppTypography.headlineSmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.gold.withOpacity(0.12),
                            AppColors.bgCard,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.gold.withOpacity(0.35),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Text(
                        journey.todayLesson,
                        style: AppTypography.bodyMedium.copyWith(height: 1.7),
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 20),
                  ],

                  if (isComplete) ...[
                    NurPathCard(
                      padding: const EdgeInsets.all(18),
                      backgroundColor: AppColors.emerald.withOpacity(0.1),
                      child: Row(
                        children: [
                          const Text('🎉', style: TextStyle(fontSize: 28)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Journey Complete!',
                                    style: AppTypography.titleMedium.copyWith(
                                      color: AppColors.emerald,
                                    )),
                                const SizedBox(height: 4),
                                Text(
                                  'Alhamdulillah! You have completed all ${journey.totalDays} days. May Allah accept it.',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 20),
                  ],

                  // ── All Lessons Timeline ──────────────────────
                  Text('Full Programme', style: AppTypography.headlineSmall),
                  const SizedBox(height: 10),
                  ...journey.dailyLessons.asMap().entries.map((entry) {
                    final i = entry.key;
                    final lesson = entry.value;
                    final isDone = i < journey.completedDays;
                    final isCurrent = i == journey.completedDays && !isComplete;
                    return _LessonTile(
                      index: i,
                      lesson: lesson,
                      isDone: isDone,
                      isCurrent: isCurrent,
                    ).animate().fadeIn(delay: Duration(milliseconds: 250 + i * 30));
                  }),

                  const SizedBox(height: 28),

                  // ── CTA Button ────────────────────────────────
                  if (!isComplete)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _continueJourney(context, ref),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: journey.isActive
                              ? AppColors.gold
                              : AppColors.emerald,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          journey.isActive
                              ? 'Mark Day ${journey.completedDays + 1} Complete ✓'
                              : 'Begin Journey — Bismillah 🤲',
                          style: AppTypography.labelLarge.copyWith(
                            color: journey.isActive
                                ? AppColors.textOnGold
                                : Colors.white,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 350.ms),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _continueJourney(BuildContext context, WidgetRef ref) async {
    String msg;
    if (!journey.isActive) {
      journey.isActive = true;
      if (journey.startedAt == null) journey.startedAt = DateTime.now();
      msg = 'Started! Bismillah — your journey begins. 🤲';
    } else if (journey.completedDays < journey.totalDays) {
      journey.completedDays++;
      await DbService.instance.addFaithPoints(score: 5, quran: 0.1, kindness: 0.05);
      ref.invalidate(userProfileProvider);
      if (journey.completedDays == journey.totalDays) {
        msg = 'Alhamdulillah! Journey complete 🎉';
      } else {
        msg = 'Day ${journey.completedDays} complete! Keep going 🌟';
      }
    } else {
      msg = 'You have completed this journey. MashaAllah ✨';
    }

    await DbService.instance.saveJourney(journey);
    ref.invalidate(journeysProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: AppTypography.bodyMedium),
          backgroundColor: AppColors.bgCardElevated,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      // Pop back so the list refreshes
      Navigator.of(context).pop();
    }
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _ProgressSummaryRow extends StatelessWidget {
  final int completedDays;
  final int totalDays;
  final double pct;
  final int remaining;
  final bool isComplete;

  const _ProgressSummaryRow({
    required this.completedDays,
    required this.totalDays,
    required this.pct,
    required this.remaining,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    return NurPathCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatChip(
                value: '$completedDays',
                label: 'Days Done',
                color: AppColors.emerald,
              ),
              _StatChip(
                value: '$totalDays',
                label: 'Total Days',
                color: AppColors.textSecondary,
              ),
              _StatChip(
                value: isComplete ? '✓' : '$remaining',
                label: isComplete ? 'Complete' : 'Remaining',
                color: isComplete ? AppColors.gold : AppColors.ringSalah,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppColors.divider,
              color: AppColors.gold,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(pct * 100).toStringAsFixed(0)}% complete',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatChip({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.headlineLarge.copyWith(color: color),
        ),
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
      ],
    );
  }
}

class _LessonTile extends StatelessWidget {
  final int index;
  final String lesson;
  final bool isDone;
  final bool isCurrent;

  const _LessonTile({
    required this.index,
    required this.lesson,
    required this.isDone,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline node
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? AppColors.emerald
                      : isCurrent
                          ? AppColors.gold
                          : AppColors.bgCardElevated,
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.gold
                        : isDone
                            ? AppColors.emerald
                            : AppColors.divider,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check_rounded,
                          size: 14, color: Colors.white)
                      : Text(
                          '${index + 1}',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 10,
                            color: isCurrent
                                ? AppColors.textOnGold
                                : AppColors.textMuted,
                          ),
                        ),
                ),
              ),
              if (index < 29)
                Container(
                  width: 1,
                  height: 24,
                  color: isDone ? AppColors.emerald.withOpacity(0.4) : AppColors.divider,
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                padding: isCurrent
                    ? const EdgeInsets.all(12)
                    : EdgeInsets.zero,
                decoration: isCurrent
                    ? BoxDecoration(
                        color: AppColors.gold.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.gold.withOpacity(0.25),
                          width: 1,
                        ),
                      )
                    : null,
                child: Text(
                  lesson,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDone
                        ? AppColors.textMuted
                        : isCurrent
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                    height: 1.5,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
