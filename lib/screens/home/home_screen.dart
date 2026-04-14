import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/app_providers.dart';
import '../../widgets/geometric_pattern.dart';
import '../../widgets/nurpath_card.dart';
import '../../widgets/faith_ring.dart';
import '../../widgets/streak_badge.dart';
import '../../widgets/ayah_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);
    final dailyAyahAsync = ref.watch(dailyAyahProvider);
    final journeysAsync = ref.watch(journeysProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: GeometricPatternBackground(
        child: CustomScrollView(
          slivers: [
            // ── App Bar ──────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 0,
              pinned: true,
              backgroundColor: AppColors.bgPrimary.withOpacity(0.95),
              title: Row(
                children: [
                  // NurPath logo text
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Nur',
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.gold,
                            fontFamily: 'Amiri',
                            fontSize: 22,
                          ),
                        ),
                        TextSpan(
                          text: 'Path',
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Streak badge
                  userAsync.when(
                    data: (user) => StreakBadge(days: user?.currentStreak ?? 0),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 8),
                  // Notification bell
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),

                  // ── Greeting ──────────────────────────────────
                  userAsync.when(
                    data: (user) => _GreetingSection(name: user?.name ?? 'Friend'),
                    loading: () => const _GreetingSkeleton(),
                    error: (_, __) => const _GreetingSection(name: 'Friend'),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

                  const SizedBox(height: 20),

                  // ── Active Journey Banner ─────────────────────
                  journeysAsync.when(
                    data: (journeys) {
                      final active = journeys
                          .where((j) => j.completedDays > 0)
                          .toList();
                      if (active.isEmpty) return const SizedBox.shrink();
                      final j = active.first;
                      return _ActiveJourneyBanner(
                        title: j.title,
                        day: j.completedDays,
                        totalDays: j.totalDays,
                        progress: j.progress,
                      ).animate().fadeIn(delay: 100.ms);
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 20),

                  // ── Faith Score Mini Row ──────────────────────
                  userAsync.when(
                    data: (user) => _FaithScoreMiniRow(
                      faithScore: user?.faithScore ?? 0,
                      quranPct: user?.quranEngagement ?? 0,
                      heartPct: user?.heartReflection ?? 0,
                      salahPct: user?.salahAlignment ?? 0,
                      kindnessPct: user?.actsOfKindness ?? 0,
                    ).animate().fadeIn(delay: 200.ms),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 24),

                  // ── Daily Ayah ────────────────────────────────
                  _SectionHeader(
                    title: 'Verse of the Day',
                    actionLabel: 'Reflect',
                    onAction: () => context.go('/reflect'),
                  ),
                  const SizedBox(height: 12),
                  Consumer(builder: (context, ref, child) {
                    final isPlaying = ref.watch(isPlayingProvider);
                    
                    void togglePlay(int s, int a) {
                      final audio = ref.read(audioServiceProvider);
                      if (isPlaying) {
                        audio.pause();
                        ref.read(isPlayingProvider.notifier).state = false;
                      } else {
                        audio.playAyah(s, a);
                        ref.read(isPlayingProvider.notifier).state = true;
                      }
                    }

                    return dailyAyahAsync.when(
                      data: (ayah) => AyahCard(
                        arabic: ayah.arabicText,
                        translation: ayah.translation,
                        surahName: 'Surah ${ayah.surahNumber}',
                        surahNumber: ayah.surahNumber,
                        ayahNumber: ayah.ayahNumber,
                        isPlaying: isPlaying,
                        onPlay: () => togglePlay(ayah.surahNumber, ayah.ayahNumber),
                        onShare: () {},
                      ).animate().fadeIn(delay: 300.ms),
                      loading: () => const _AyahCardSkeleton(),
                      error: (e, _) => AyahCard(
                        arabic: 'فَٱذْكُرُونِىٓ أَذْكُرْكُمْ وَٱشْكُرُوا۟ لِى وَلَا تَكْفُرُونِ',
                        translation:
                            'So remember Me; I will remember you. And be grateful to Me and do not deny Me.',
                        surahName: 'Al-Baqarah',
                        surahNumber: 2,
                        ayahNumber: 152,
                        isPlaying: isPlaying,
                        onPlay: () => togglePlay(2, 152),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // ── Quick Actions ────────────────────────────
                  _SectionHeader(title: 'Quick Access'),
                  const SizedBox(height: 12),
                  _QuickActionsGrid(
                    actions: [
                      _QuickAction(
                        icon: Icons.menu_book_rounded,
                        label: 'Quran',
                        color: AppColors.emerald,
                        onTap: () => context.go('/learn'),
                      ),
                      _QuickAction(
                        icon: Icons.auto_awesome,
                        label: 'Reflect',
                        color: AppColors.gold,
                        onTap: () => context.go('/reflect'),
                      ),
                      _QuickAction(
                        icon: Icons.route_rounded,
                        label: 'Journeys',
                        color: AppColors.ringSalah,
                        onTap: () => context.go('/journeys'),
                      ),
                      _QuickAction(
                        icon: Icons.psychology_rounded,
                        label: 'Memorize',
                        color: AppColors.ringKindness,
                        onTap: () => context.go('/memorize'),
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 24),

                  // ── Thematic Journeys ─────────────────────────
                  _SectionHeader(
                    title: 'Spiritual Journeys',
                    actionLabel: 'View All',
                    onAction: () => context.go('/journeys'),
                  ),
                  const SizedBox(height: 12),
                  journeysAsync.when(
                    data: (journeys) => _JourneysPreviewRow(
                      journeys: journeys.take(2).toList(),
                    ).animate().fadeIn(delay: 500.ms),
                    loading: () => const SizedBox(height: 120),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _GreetingSection extends StatelessWidget {
  final String name;

  const _GreetingSection({required this.name});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'السلام عليكم',
          style: AppTypography.arabicSmall.copyWith(
            color: AppColors.gold.withOpacity(0.8),
            fontSize: 16,
          ),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 4),
        Text(
          '$_greeting, $name',
          style: AppTypography.displaySmall,
        ),
        const SizedBox(height: 4),
        Text(
          'May your heart find peace today.',
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }
}

class _ActiveJourneyBanner extends StatelessWidget {
  final String title;
  final int day;
  final int totalDays;
  final double progress;

  const _ActiveJourneyBanner({
    required this.title,
    required this.day,
    required this.totalDays,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return EmeraldGradientCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Day $day of $title',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}% complete',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              color: AppColors.gold,
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _FaithScoreMiniRow extends StatelessWidget {
  final int faithScore;
  final double quranPct;
  final double heartPct;
  final double salahPct;
  final double kindnessPct;

  const _FaithScoreMiniRow({
    required this.faithScore,
    required this.quranPct,
    required this.heartPct,
    required this.salahPct,
    required this.kindnessPct,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/faith-score'),
      child: NurPathCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ScoreRing(score: faithScore),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FaithRing(
                        percent: quranPct,
                        type: RingType.quran,
                        radius: 32,
                        lineWidth: 5,
                        labelOverride: 'Quran',
                      ),
                      FaithRing(
                        percent: heartPct,
                        type: RingType.heart,
                        radius: 32,
                        lineWidth: 5,
                        labelOverride: 'Heart',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FaithRing(
                        percent: salahPct,
                        type: RingType.salah,
                        radius: 32,
                        lineWidth: 5,
                        labelOverride: 'Salah',
                      ),
                      FaithRing(
                        percent: kindnessPct,
                        type: RingType.kindness,
                        radius: 32,
                        lineWidth: 5,
                        labelOverride: 'Deeds',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTypography.headlineSmall),
        const Spacer(),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.gold,
              ),
            ),
          ),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final List<_QuickAction> actions;

  const _QuickActionsGrid({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: action.onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: action.color.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(action.icon, color: action.color, size: 26),
                    const SizedBox(height: 6),
                    Text(
                      action.label,
                      style: AppTypography.labelSmall.copyWith(
                        color: action.color,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _JourneysPreviewRow extends StatelessWidget {
  final List<dynamic> journeys;

  const _JourneysPreviewRow({required this.journeys});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: journeys.asMap().entries.map((entry) {
        final j = entry.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: entry.key == 0 ? 8 : 0),
            child: NurPathCard(
              onTap: () => context.go('/journeys'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gradient header
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.emeraldGradient,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${j.totalDays} days',
                              style: AppTypography.labelSmall.copyWith(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          j.title,
                          style: AppTypography.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          j.surahReference,
                          style: AppTypography.surahRef,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.go('/journeys'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.emerald,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Start Journey',
                              style: AppTypography.labelSmall.copyWith(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Skeleton loaders
class _GreetingSkeleton extends StatelessWidget {
  const _GreetingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 14,
          width: 80,
          decoration: BoxDecoration(
            color: AppColors.bgCardElevated,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 22,
          width: 200,
          decoration: BoxDecoration(
            color: AppColors.bgCardElevated,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class _AyahCardSkeleton extends StatelessWidget {
  const _AyahCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
    );
  }
}
