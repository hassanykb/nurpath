import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                      Text(
                        'Build v1.1.2 • Bismillah',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 8,
                          color: AppColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
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
                    onPressed: () {
                      // Immediate visual feedback to confirm taps work
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening notifications...'),
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                      _showNotificationsSheet(context);
                    },
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
                        onShare: () => _shareAyah(context, ayah.arabicText, ayah.translation,
                            'Surah ${ayah.surahNumber}:${ayah.ayahNumber}'),
                        onAsk: () => _showAskAyahSheet(
                          context,
                          arabic: ayah.arabicText,
                          translation: ayah.translation,
                          ref: '${ayah.surahNumber}:${ayah.ayahNumber}',
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                      loading: () => _AyahCardSkeleton(onRetry: () => ref.invalidate(dailyAyahProvider)),
                      error: (e, _) => AyahCard(
                        arabic: 'فَٱذْكُرُونِىٓ أَذْكُرْكُمْ وَٱشْكُرُوا۟ لِى وَلَا تَكْفُرُونِ',
                        translation:
                            'So remember Me; I will remember you. And be grateful to Me and do not deny Me.',
                        surahName: 'Al-Baqarah',
                        surahNumber: 2,
                        ayahNumber: 152,
                        isPlaying: isPlaying,
                        onPlay: () => togglePlay(2, 152),
                        onAsk: () => _showAskAyahSheet(
                          context,
                          arabic: 'فَٱذْكُرُونِىٓ أَذْكُرْكُمْ وَٱشْكُرُوا۟ لِى وَلَا تَكْفُرُونِ',
                          translation:
                              'So remember Me; I will remember you. And be grateful to Me and do not deny Me.',
                          ref: '2:152',
                        ),
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

  void _showNotificationsSheet(BuildContext context) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications', style: AppTypography.headlineMedium),
            const SizedBox(height: 16),
            const _NotifTile(
              icon: Icons.wb_sunny_rounded,
              color: AppColors.gold,
              title: 'Daily Verse Ready',
              body: 'Your Verse of the Day has been loaded. Take a moment to reflect.',
              time: 'Now',
            ),
            const SizedBox(height: 10),
            const _NotifTile(
              icon: Icons.psychology_rounded,
              color: AppColors.emerald,
              title: 'Memorization Review',
              body: 'You have cards due for review today. Keep your streak alive!',
              time: 'Today',
            ),
            const SizedBox(height: 10),
            const _NotifTile(
              icon: Icons.route_rounded,
              color: AppColors.ringSalah,
              title: 'Journey Reminder',
              body: 'Continue your spiritual journey — one day at a time.',
              time: 'Yesterday',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAskAyahSheet(
    BuildContext context, {
    required String arabic,
    required String translation,
    required String ref,
  }) {
    if (!mounted) return;
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.emerald, size: 20),
                const SizedBox(width: 8),
                Text('Ask about this Ayah', style: AppTypography.headlineMedium),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              ref,
              style: AppTypography.surahRef,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bgCardElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider, width: 0.5),
              ),
              child: Text(
                translation,
                style: AppTypography.bodySmall.copyWith(height: 1.6),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              maxLines: 3,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'e.g. What does this ayah teach about gratitude?',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textDisabled),
                filled: true,
                fillColor: AppColors.bgCardElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.go('/reflect');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Ask'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareAyah(BuildContext context, String arabic, String translation, String ref) {
    if (!mounted) return;
    final copyText = '$arabic\n\n$translation\n\n— $ref';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$translation" — $ref', style: AppTypography.bodySmall),
        backgroundColor: AppColors.bgCardElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Copy',
          textColor: AppColors.gold,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: copyText));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copied to clipboard', style: AppTypography.bodySmall),
                backgroundColor: AppColors.bgCardElevated,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
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
  final VoidCallback? onRetry;
  const _AyahCardSkeleton({this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _ShimmerBox(
          child: Container(
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withOpacity(0.2), width: 0.5),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.gold,
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh, size: 14, color: AppColors.gold),
                    label: Text(
                      'Retry if stuck',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.gold),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  final Widget child;
  const _ShimmerBox({required this.child});

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) => Opacity(opacity: _anim.value, child: child),
      child: widget.child,
    );
  }
}

class _NotifTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;

  const _NotifTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCardElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: AppTypography.titleMedium),
                    const Spacer(),
                    Text(time,
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.textMuted, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(body,
                    style: AppTypography.bodySmall.copyWith(height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
