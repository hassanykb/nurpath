import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/app_providers.dart';
import '../../models/ayah_model.dart';
import '../../services/audio_service.dart';
import '../../widgets/nurpath_card.dart';
import '../../widgets/audio_player_bar.dart';
import '../../widgets/geometric_pattern.dart';

class LearnScreen extends ConsumerStatefulWidget {
  final int? initialSurahNumber;

  const LearnScreen({super.key, this.initialSurahNumber});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _currentSurahNumber;
  int _currentAyahIndex = 0;
  bool _isPlayerVisible = true;
  bool _wordByWord = false;

  @override
  void initState() {
    super.initState();
    _currentSurahNumber = widget.initialSurahNumber ?? 1;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahAsync =
        ref.watch(surahProvider(_currentSurahNumber));
    final isPlaying = ref.watch(isPlayingProvider);
    final speed = ref.watch(playbackSpeedProvider);
    final progress = ref.watch(audioProgressProvider);
    final reciter = ref.watch(currentReciterProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: GeometricPatternBackground(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────
            _LearnHeader(
              surahNumber: _currentSurahNumber,
              surahAsync: surahAsync,
              onSurahSelect: () => _showSurahPicker(context),
            ),

            // ── Tab Bar ─────────────────────────────────────────
            Container(
              color: AppColors.bgPrimary,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Read'),
                  Tab(text: 'Word by Word'),
                ],
                labelStyle: AppTypography.labelLarge,
                unselectedLabelStyle: AppTypography.labelMedium,
                labelColor: AppColors.gold,
                unselectedLabelColor: AppColors.textMuted,
                indicatorColor: AppColors.gold,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),

            // ── Ayah Content ────────────────────────────────────
            Expanded(
              child: surahAsync.when(
                data: (surahData) => TabBarView(
                  controller: _tabController,
                  children: [
                    _ReadTab(
                      ayahs: surahData.ayahs,
                      currentIndex: _currentAyahIndex,
                      onAyahTap: (i) => setState(
                        () => _currentAyahIndex = i,
                      ),
                      onPlayAyah: (ayah) => _playAyah(ayah),
                    ),
                    _WordByWordTab(
                      ayah: surahData.ayahs.isNotEmpty
                          ? surahData.ayahs[_currentAyahIndex]
                          : null,
                    ),
                  ],
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.emerald,
                  ),
                ),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off_rounded,
                          color: AppColors.textMuted, size: 48),
                      const SizedBox(height: 12),
                      Text('Could not load Surah',
                          style: AppTypography.bodyMedium),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => ref.refresh(
                            surahProvider(_currentSurahNumber)),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Audio Player ────────────────────────────────────
            if (_isPlayerVisible)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: AudioPlayerBar(
                  isPlaying: isPlaying,
                  progress: progress,
                  reciterName: reciter,
                  surahName: 'Surah $_currentSurahNumber',
                  playbackSpeed: speed,
                  onPlayPause: () => _togglePlay(),
                  onNext: () => _nextAyah(),
                  onSpeedChange: (s) =>
                      ref.read(playbackSpeedProvider.notifier).state = s,
                  onSeek: (p) =>
                      ref.read(audioProgressProvider.notifier).state = p,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _togglePlay() {
    final audio = ref.read(audioServiceProvider);
    final isPlaying = ref.read(isPlayingProvider);
    if (isPlaying) {
      audio.pause();
      ref.read(isPlayingProvider.notifier).state = false;
    } else {
      audio.playAyah(_currentSurahNumber, _currentAyahIndex + 1);
      ref.read(isPlayingProvider.notifier).state = true;
    }
  }

  void _playAyah(AyahData ayah) {
    final audio = ref.read(audioServiceProvider);
    audio.playAyah(ayah.surahNumber, ayah.ayahNumber);
    ref.read(isPlayingProvider.notifier).state = true;
  }

  void _nextAyah() {
    final surahData = ref.read(surahProvider(_currentSurahNumber)).valueOrNull;
    if (surahData != null &&
        _currentAyahIndex < surahData.ayahs.length - 1) {
      setState(() => _currentAyahIndex++);
      _playAyah(surahData.ayahs[_currentAyahIndex]);
    }
  }

  void _showSurahPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _SurahPickerSheet(
        currentSurah: _currentSurahNumber,
        onSelect: (n) {
          setState(() {
            _currentSurahNumber = n;
            _currentAyahIndex = 0;
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }
}

// ─── Sub-widgets ───────────────────────────────────────────────────────────────

class _LearnHeader extends StatelessWidget {
  final int surahNumber;
  final AsyncValue<SurahWithTranslation> surahAsync;
  final VoidCallback onSurahSelect;

  const _LearnHeader({
    required this.surahNumber,
    required this.surahAsync,
    required this.onSurahSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded,
                  color: AppColors.textPrimary),
              onPressed: () => context.go('/home'),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onSurahSelect,
                child: Column(
                  children: [
                    surahAsync.when(
                      data: (data) => Text(
                        data.surahData.nameEnglish,
                        style: AppTypography.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      loading: () => Text(
                        'Surah $surahNumber',
                        style: AppTypography.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      error: (_, __) => Text(
                        'Surah $surahNumber',
                        style: AppTypography.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      'Ayah 1 of ${surahAsync.valueOrNull?.surahData.ayahCount ?? '?'}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border_rounded,
                  color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadTab extends StatelessWidget {
  final List<AyahData> ayahs;
  final int currentIndex;
  final ValueChanged<int> onAyahTap;
  final ValueChanged<AyahData> onPlayAyah;

  const _ReadTab({
    required this.ayahs,
    required this.currentIndex,
    required this.onAyahTap,
    required this.onPlayAyah,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: ayahs.length,
      itemBuilder: (ctx, i) {
        final ayah = ayahs[i];
        final isActive = i == currentIndex;
        return GestureDetector(
          onTap: () => onAyahTap(i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.emerald.withOpacity(0.08)
                  : AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive
                    ? AppColors.emerald.withOpacity(0.4)
                    : AppColors.divider,
                width: isActive ? 1.5 : 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ayah number bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      // Number badge
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? AppColors.emerald
                              : AppColors.bgCardElevated,
                          border: Border.all(
                            color: isActive
                                ? AppColors.emerald
                                : AppColors.divider,
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${ayah.ayahNumber}',
                            style: AppTypography.labelSmall.copyWith(
                              color: isActive
                                  ? Colors.white
                                  : AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.play_circle_outline,
                          size: 20,
                          color: isActive
                              ? AppColors.emerald
                              : AppColors.textMuted,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                            minWidth: 32, minHeight: 32),
                        onPressed: () => onPlayAyah(ayah),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.bookmark_border_rounded,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                            minWidth: 28, minHeight: 28),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                // Arabic text
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    ayah.arabicText,
                    style: AppTypography.arabicMedium,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                // Divider
                Container(
                  height: 0.5,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: AppColors.divider,
                ),
                // Translation
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                  child: Text(
                    ayah.translation,
                    style: AppTypography.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WordByWordTab extends StatelessWidget {
  final AyahData? ayah;

  const _WordByWordTab({this.ayah});

  @override
  Widget build(BuildContext context) {
    if (ayah == null) {
      return const Center(
        child: Text('Select an ayah to see word-by-word breakdown'),
      );
    }

    // Split Arabic text into words
    final arabicWords = ayah!.arabicText.split(' ')
        .where((w) => w.isNotEmpty)
        .toList();
    final translationWords = ayah!.translation.split(' ')
        .where((w) => w.isNotEmpty)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full arabic on top
          NurPathCard(
            padding: const EdgeInsets.all(16),
            child: Text(
              ayah!.arabicText,
              style: AppTypography.arabicLarge,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 16),
          Text('Word by Word', style: AppTypography.headlineSmall),
          const SizedBox(height: 12),
          // Words grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: arabicWords.asMap().entries.map((entry) {
              final i = entry.key;
              final word = entry.value;
              final engWord = i < translationWords.length
                  ? translationWords[i]
                  : '';
              return _WordCard(arabic: word, english: engWord);
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Translation
          NurPathCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Translation', style: AppTypography.titleMedium),
                const SizedBox(height: 8),
                Text(ayah!.translation, style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  final String arabic;
  final String english;

  const _WordCard({required this.arabic, required this.english});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            arabic,
            style: AppTypography.arabicMedium.copyWith(fontSize: 18),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 4),
          Text(
            english,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.gold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahPickerSheet extends ConsumerWidget {
  final int currentSurah;
  final ValueChanged<int> onSelect;

  const _SurahPickerSheet({
    required this.currentSurah,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahListAsync = ref.watch(surahListProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text('Choose Surah', style: AppTypography.headlineMedium),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: surahListAsync.when(
                data: (surahs) => ListView.builder(
                  controller: scrollController,
                  itemCount: surahs.length,
                  itemBuilder: (ctx, i) {
                    final s = surahs[i];
                    final isSelected = s.number == currentSurah;
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.emerald
                              : AppColors.bgCardElevated,
                        ),
                        child: Center(
                          child: Text(
                            '${s.number}',
                            style: AppTypography.labelMedium.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        s.nameEnglish,
                        style: AppTypography.titleMedium,
                      ),
                      subtitle: Text(
                        '${s.nameTransliteration} · ${s.ayahCount} ayahs',
                        style: AppTypography.bodySmall,
                      ),
                      trailing: Text(
                        s.nameArabic,
                        style: AppTypography.arabicSmall.copyWith(
                          fontSize: 14,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      onTap: () => onSelect(s.number),
                    );
                  },
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.emerald),
                ),
                error: (e, _) => Center(
                  child: Text('Failed to load surahs', style: AppTypography.bodyMedium),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
