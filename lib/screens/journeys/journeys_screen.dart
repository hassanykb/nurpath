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
import 'journey_detail_screen.dart';

class JourneysScreen extends ConsumerStatefulWidget {
  const JourneysScreen({super.key});

  @override
  ConsumerState<JourneysScreen> createState() => _JourneysScreenState();
}

class _JourneysScreenState extends ConsumerState<JourneysScreen> {
  String _selectedCategory = 'All';

  static const List<String> _categories = [
    'All',
    'Healing',
    'Parenting',
    'Gratitude',
    'Prophets',
  ];

  @override
  Widget build(BuildContext context) {
    final journeysAsync = ref.watch(journeysProvider);
    final userAsync = ref.watch(userProfileProvider);
    final faithPoints = userAsync.valueOrNull?.faithScore ?? 0;

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
                  GestureDetector(
                    onTap: () => _showCategoryPicker(context),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _selectedCategory != 'All'
                            ? AppColors.emerald.withOpacity(0.2)
                            : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedCategory != 'All'
                              ? AppColors.emerald.withOpacity(0.5)
                              : AppColors.divider,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedCategory,
                            style: AppTypography.labelSmall.copyWith(
                              color: _selectedCategory != 'All'
                                  ? AppColors.emerald
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down,
                              size: 14, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Filter chips + Fp badge + sync ─────────
                    Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _categories.map((cat) {
                                final isSelected = cat == _selectedCategory;
                                return GestureDetector(
                                  onTap: () => setState(
                                      () => _selectedCategory = cat),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.emerald
                                          : AppColors.bgCardElevated,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.emerald
                                            : AppColors.divider,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      cat,
                                      style: AppTypography.labelSmall
                                          .copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Real faith points badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.gold.withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 12, color: AppColors.gold),
                              const SizedBox(width: 3),
                              Text(
                                '$faithPoints fp',
                                style: AppTypography.labelSmall
                                    .copyWith(color: AppColors.gold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Refresh button
                        GestureDetector(
                          onTap: () {
                            ref.invalidate(journeysProvider);
                            ref.invalidate(userProfileProvider);
                          },
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.divider, width: 0.5),
                            ),
                            child: const Icon(Icons.sync_rounded,
                                color: AppColors.textMuted, size: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),

              // ── Journey Cards Grid ─────────────────────────
              journeysAsync.when(
                data: (journeys) {
                  final filtered = _selectedCategory == 'All'
                      ? journeys
                      : journeys
                          .where((j) => j.category == _selectedCategory)
                          .toList();

                  if (filtered.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.explore_off_rounded,
                                color: AppColors.textMuted, size: 48),
                            const SizedBox(height: 12),
                            Text('No $_selectedCategory journeys yet',
                                style: AppTypography.bodyMedium),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () =>
                                  setState(() => _selectedCategory = 'All'),
                              child: Text('Show All',
                                  style: AppTypography.labelMedium
                                      .copyWith(color: AppColors.gold)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
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
                          journey: filtered[i],
                          index: journeys.indexOf(filtered[i]),
                          onTap: () => Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) =>
                                  JourneyDetailScreen(journey: filtered[i]),
                            ),
                          ).then((_) {
                            ref.invalidate(journeysProvider);
                            ref.invalidate(userProfileProvider);
                          }),
                          onStart: () =>
                              _startJourney(ctx, ref, filtered[i]),
                        ).animate().fadeIn(
                              delay: Duration(milliseconds: i * 80),
                            ),
                        childCount: filtered.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(
                    child:
                        CircularProgressIndicator(color: AppColors.emerald),
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

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by Category',
                style: AppTypography.headlineMedium),
            const SizedBox(height: 12),
            ..._categories.map((cat) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(cat, style: AppTypography.bodyMedium),
                  trailing: _selectedCategory == cat
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.emerald, size: 18)
                      : null,
                  onTap: () {
                    setState(() => _selectedCategory = cat);
                    Navigator.pop(ctx);
                  },
                )),
          ],
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
        await DbService.instance
            .addFaithPoints(score: 5, quran: 0.1, kindness: 0.05);
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
          content: Text(msg, style: AppTypography.bodyMedium),
          backgroundColor: AppColors.bgCardElevated,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}

class _JourneyCard extends StatelessWidget {
  final ThematicJourney journey;
  final int index;
  final VoidCallback onStart;
  final VoidCallback onTap;

  const _JourneyCard({
    required this.journey,
    required this.index,
    required this.onStart,
    required this.onTap,
  });

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
    return GestureDetector(
      onTap: onTap,
      child: NurPathCard(
        showBorder: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _gradientColors,
                  ),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: GeometricPatternPainter(opacity: 0.08),
                      ),
                    ),
                    // Category chip
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          journey.category,
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                    // Days badge
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
                    if (journey.completedDays > 0)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: LinearProgressIndicator(
                          value: journey.progress,
                          backgroundColor:
                              Colors.black.withOpacity(0.3),
                          color: AppColors.gold,
                          minHeight: 3,
                        ),
                      ),
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
                  if (journey.isActive && journey.completedDays > 0) ...[
                    const SizedBox(height: 3),
                    Text(
                      'Day ${journey.completedDays}/${journey.totalDays}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.gold,
                        fontSize: 9,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onStart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: journey.isActive
                            ? AppColors.gold
                            : AppColors.emerald,
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
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
      ),
    );
  }

  String _journeyEmoji(int index) {
    const emojis = ['🕌', '🤲', '🌿', '📖'];
    return emojis[index % emojis.length];
  }
}
