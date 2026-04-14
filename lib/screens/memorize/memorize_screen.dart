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

class MemorizeScreen extends ConsumerStatefulWidget {
  const MemorizeScreen({super.key});

  @override
  ConsumerState<MemorizeScreen> createState() => _MemorizeScreenState();
}

class _MemorizeScreenState extends ConsumerState<MemorizeScreen> {
  int _currentSurah = 1;
  bool _isRecording = false;
  final Set<String> _revealedCards = {};



  @override
  Widget build(BuildContext context) {
    final srsCardsAsync = ref.watch(srsCardsProvider);

    return srsCardsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(child: CircularProgressIndicator(color: AppColors.emerald)),
      ),
      error: (e, st) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(child: Text('Error loading cards: $e')),
      ),
      data: (cards) {
        // Build sets of mastered cards based on actual DB initial state + current session flips
        final dbMastered = cards.where((c) => c.isMastered).map((c) => c.id).toSet();
        final allMasteredIds = {...dbMastered, ..._revealedCards};
        final total = cards.length;
        final mastered = allMasteredIds.length;

        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          body: GeometricPatternBackground(
            color: AppColors.goldDark,
            opacity: 0.03,
            child: SafeArea(
              child: Column(
                children: [
                  // ── Header ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      children: [
                        const BackButton(color: AppColors.textPrimary),
                        const Spacer(),
                        Text(
                          'Memorize - Surah Al-Fatiha',
                          style: AppTypography.headlineSmall,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined,
                              color: AppColors.textSecondary, size: 20),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  // ── Juz Selector ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _JuzChip(label: 'Juz', isSelected: false),
                        const SizedBox(width: 8),
                        _JuzChip(label: 'Juz 1: 1-7', isSelected: true),
                        const SizedBox(width: 8),
                        _JuzChip(label: 'Ard', isSelected: false),
                      ],
                    ),
                  ),

                  // ── Cards Grid ────────────────────────────────
                  Expanded(
                    child: Stack(
                      children: [
                        // Audio play button (left)
                        Positioned(
                          left: 8,
                          top: 0,
                          bottom: 100,
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.bgCard,
                                border: Border.all(
                                    color: AppColors.divider, width: 0.5),
                              ),
                              child: const Icon(
                                Icons.volume_up_rounded,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        // Cards grid
                        Padding(
                          padding: const EdgeInsets.fromLTRB(56, 8, 16, 8),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: cards.length,
                            itemBuilder: (ctx, i) {
                              final card = cards[i];
                              final isRevealed = allMasteredIds.contains(card.id);
                              
                              return _SRSCard(
                                arabic: card.arabicText,
                                isRevealed: isRevealed,
                                onReveal: () async {
                                  setState(() {
                                    if (isRevealed) {
                                      _revealedCards.remove(card.id);
                                    } else {
                                      _revealedCards.add(card.id);
                                    }
                                  });
                                  
                                  // Did we just master it? Give points!
                                  if (!isRevealed) {
                                    await DbService.instance.addFaithPoints(score: 1, quran: 0.05);
                                    ref.invalidate(userProfileProvider);
                                  }

                                  card.isMastered = !isRevealed;
                                  await DbService.instance.saveSRSCard(card);
                                  ref.invalidate(srsCardsProvider);
                                },
                              ).animate().fadeIn(
                                    delay: Duration(milliseconds: i * 60),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

              // ── Progress Bar ──────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Mastered $mastered/$total ayahs',
                      style: AppTypography.labelSmall,
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: AppColors.textMuted)),
                    const SizedBox(width: 8),
                    Text(
                      'Next review in 2 days',
                      style: AppTypography.labelSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: total > 0 ? mastered / total : 0,
                    backgroundColor: AppColors.divider,
                    color: AppColors.gold,
                    minHeight: 4,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── Record Button ──────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => setState(() => _isRecording = !_isRecording),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: _isRecording
                          ? AppColors.error
                          : AppColors.bgCardElevated,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _isRecording
                            ? AppColors.error
                            : AppColors.divider,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isRecording
                              ? Icons.stop_rounded
                              : Icons.volume_up_rounded,
                          color: _isRecording
                              ? Colors.white
                              : AppColors.textSecondary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isRecording
                              ? 'Stop Recording'
                              : 'Record & Get Gentle Feedback',
                          style: AppTypography.labelMedium.copyWith(
                            color: _isRecording
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── Retention Meter ────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: NurPathCard(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      // Left badge
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.bgCardElevated,
                          border: Border.all(
                              color: AppColors.gold.withOpacity(0.3),
                              width: 1),
                        ),
                        child: const Center(
                          child: Text('🏠', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fort',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.gold,
                              ),
                            ),
                            Text(
                              'Retention Strength:',
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 9,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: mastered / total.clamp(1, total),
                                backgroundColor: AppColors.divider,
                                color: AppColors.gold,
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Right badge
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.bgCardElevated,
                          border: Border.all(
                              color: AppColors.textMuted.withOpacity(0.3),
                              width: 1),
                        ),
                        child: const Center(
                          child: Text('📱', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ), // Column
        ), // SafeArea
      ), // GeometricPatternBackground
    ); // Scaffold
  },
);
  }
}

class _SRSCard extends StatelessWidget {
  final String arabic;
  final bool isRevealed;
  final VoidCallback onReveal;

  const _SRSCard({
    required this.arabic,
    required this.isRevealed,
    required this.onReveal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onReveal,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isRevealed
              ? AppColors.bgCardElevated
              : const Color(0xFFF5EFD6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRevealed ? AppColors.divider : const Color(0xFFD4B87A),
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Arabic (always visible)
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 6, 4),
              child: Text(
                arabic,
                style: const TextStyle(
                  fontFamily: 'AmiriQuran',
                  fontSize: 13,
                  color: Color(0xFF1A1A1A),
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Reveal / Tap indicator
            Text(
              isRevealed ? '✓' : 'Reveal',
              style: AppTypography.labelSmall.copyWith(
                color: isRevealed ? AppColors.emerald : const Color(0xFF8A6A2A),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JuzChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _JuzChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.bgCardElevated : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? AppColors.divider : Colors.transparent,
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
        ),
      ),
    );
  }
}
