import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/app_providers.dart';
import '../../models/user_model.dart';
import '../../services/db_service.dart';
import '../../widgets/geometric_pattern.dart';
import '../../widgets/nurpath_card.dart';

class JourneysScreen extends ConsumerWidget {
  const JourneysScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeysAsync = ref.watch(journeysProvider);

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
                title: Text(
                  'Choose Your\nSpiritual Path to Grow',
                  style: AppTypography.displaySmall.copyWith(
                    fontFamily: 'Amiri',
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                centerTitle: true,
                actions: [
                  // Filter
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text('Thematic',
                            style: AppTypography.labelSmall),
                        const Icon(Icons.keyboard_arrow_down,
                            size: 14, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ],
              ),

              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Filter row ─────────────────────────────
                    Row(
                      children: [
                        const Spacer(),
                        // Fp badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.bgCardElevated,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('Fp 10',
                              style: AppTypography.labelMedium),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.divider, width: 0.5),
                          ),
                          child: const Icon(Icons.chevron_left,
                              color: AppColors.textMuted, size: 20),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.divider, width: 0.5),
                          ),
                          child: const Icon(Icons.sync_rounded,
                              color: AppColors.textMuted, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),

              // ── Journey Cards Grid ─────────────────────────
              journeysAsync.when(
                data: (journeys) => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _JourneyCard(
                        journey: journeys[i],
                        index: i,
                        onStart: () => _startJourney(ctx, ref, journeys[i]),
                      ).animate().fadeIn(
                            delay: Duration(milliseconds: i * 80),
                          ),
                      childCount: journeys.length,
                    ),
                  ),
                ),
                loading: () => const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.emerald),
                  ),
                ),
                error: (_, __) => const SliverFillRemaining(
                  child: Center(child: Text('Could not load journeys')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startJourney(
    BuildContext context,
    WidgetRef ref,
    ThematicJourney journey,
  ) async {
    String msg = '';
    if (!journey.isActive) {
      journey.isActive = true;
      if (journey.startedAt == null) journey.startedAt = DateTime.now();
      msg = 'Started: ${journey.title}. Bismillah! 🤲';
    } else {
      if (journey.completedDays < journey.totalDays) {
        journey.completedDays++;
        
        // Give faith points for journey progress!
        await DbService.instance.addFaithPoints(score: 5, quran: 0.1, kindness: 0.05);
        ref.invalidate(userProfileProvider);

        if (journey.completedDays == journey.totalDays) {
          msg = 'Alhamdulillah! You completed: ${journey.title} 🎉';
        } else {
          msg = 'Day ${journey.completedDays} completed! Keep going. 🌟';
        }
      } else {
        msg = 'You have already completed this journey! MashaAllah. ✨';
      }
    }
    
    await DbService.instance.saveJourney(journey);
    ref.invalidate(journeysProvider);

    if (context.mounted && msg.isNotEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: AppTypography.bodyMedium,
          ),
          backgroundColor: AppColors.bgCardElevated,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}

class _JourneyCard extends StatelessWidget {
  final ThematicJourney journey;
  final int index;
  final VoidCallback onStart;

  const _JourneyCard({
    required this.journey,
    required this.index,
    required this.onStart,
  });

  // Gradient variation by index
  List<Color> get _gradientColors {
    switch (index % 4) {
      case 0:
        return [AppColors.emerald, AppColors.emeraldDeep];
      case 1:
        return [const Color(0xFF2C4A6B), const Color(0xFF1A2E44)];
      case 2:
        return [const Color(0xFF3D5A3E), AppColors.emeraldDeep];
      default:
        return [const Color(0xFF4A3728), const Color(0xFF2A1F18)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return NurPathCard(
      showBorder: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image / Gradient header
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _gradientColors,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  // Geometric overlay
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GeometricPatternPainter(opacity: 0.08),
                    ),
                  ),
                  // Days badge
                  if (journey.totalDays > 0)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${journey.totalDays} days',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  // Progress indicator if started
                  if (journey.completedDays > 0)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: LinearProgressIndicator(
                        value: journey.progress,
                        backgroundColor: Colors.black.withOpacity(0.3),
                        color: AppColors.gold,
                        minHeight: 3,
                      ),
                    ),
                  // Center icon
                  Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _journeyEmoji(index),
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  journey.title,
                  style: AppTypography.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  journey.surahReference,
                  style: AppTypography.surahRef.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: journey.isActive
                          ? AppColors.gold
                          : AppColors.emerald,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      journey.isActive ? 'Continue' : 'Start Journey',
                      style: AppTypography.labelSmall.copyWith(
                        color: journey.isActive
                            ? AppColors.textOnGold
                            : Colors.white,
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
    );
  }

  String _journeyEmoji(int index) {
    const emojis = ['🕌', '🤲', '🌿', '📖'];
    return emojis[index % emojis.length];
  }
}

