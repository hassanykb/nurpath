import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/app_providers.dart';
import '../../models/user_model.dart';
import '../../models/ayah_model.dart';
import '../../services/db_service.dart';
import '../../widgets/geometric_pattern.dart';
import '../../widgets/nurpath_card.dart';

class ReflectScreen extends ConsumerStatefulWidget {
  const ReflectScreen({super.key});

  @override
  ConsumerState<ReflectScreen> createState() => _ReflectScreenState();
}

class _ReflectScreenState extends ConsumerState<ReflectScreen> {
  final TextEditingController _journalController = TextEditingController();
  String? _selectedDeed;
  bool _isSaving = false;
  bool _showDeedDropdown = false;

  static const List<String> _deeds = [
    'Charity',
    'Prayer',
    'Kindness',
    'Gratitude',
    'Family',
    'Community',
  ];

  static const _sampleAyah = (
    arabic:
        'فَٱذْكُرُونِىٓ أَذْكُرْكُمْ وَٱشْكُرُوا۟ لِى وَلَا تَكْفُرُونِ',
    translation:
        'So remember Me; I will remember you. And be grateful to Me and do not deny Me.',
    ref: 'Al-Baqarah 2:152',
  );

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journalAsync = ref.watch(journalEntriesProvider);
    final dailyAyahAsync = ref.watch(dailyAyahProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: GeometricPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Text('Reflect & Grow', style: AppTypography.displaySmall),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.history_rounded,
                          color: AppColors.textSecondary),
                      onPressed: () =>
                          _showJournalHistory(context, journalAsync),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: dailyAyahAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.emerald),
                  ),
                  error: (_, __) => SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _buildContent(
                      journalAsync: journalAsync,
                      arabic: _sampleAyah.arabic,
                      translation: _sampleAyah.translation,
                      surahRef: _sampleAyah.ref,
                    ),
                  ),
                  data: (AyahData ayahData) => SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _buildContent(
                      journalAsync: journalAsync,
                      arabic: ayahData.arabicText,
                      translation: ayahData.translation,
                      surahRef:
                          '${ayahData.surahNumber}:${ayahData.ayahNumber}',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required AsyncValue<List<JournalEntry>> journalAsync,
    required String arabic,
    required String translation,
    required String surahRef,
  }) {
    final req = ReflectionRequest(
      arabicAyah: arabic,
      translation: translation,
      surahRef: surahRef,
    );
    final promptAsync = ref.watch(reflectionPromptProvider(req));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Ayah Card ─────────────────────────────
        _ReflectAyahCard(
          arabic: arabic,
          translation: translation,
          surahRef: surahRef,
        ),
        const SizedBox(height: 20),

        // ── Reflection Prompt ─────────────────────
        promptAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: AppColors.emerald),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (prompt) => _ReflectionPromptCard(
            prompt: prompt.question,
            tafseeerRef: prompt.tafseeerCitation,
          ),
        ),
        const SizedBox(height: 16),

        // ── Journal Editor ────────────────────────
        _JournalEditor(
          controller: _journalController,
          onVoiceInput: _startVoiceInput,
        ),
        const SizedBox(height: 12),

        // ── Deed Linker ───────────────────────────
        _DeedLinker(
          selectedDeed: _selectedDeed,
          deeds: _deeds,
          showDropdown: _showDeedDropdown,
          onToggleDropdown: () =>
              setState(() => _showDeedDropdown = !_showDeedDropdown),
          onSelectDeed: (d) => setState(() {
            _selectedDeed = d;
            _showDeedDropdown = false;
          }),
        ),
        const SizedBox(height: 16),

        // ── Timeline ──────────────────────────────
        _JournalTimeline(journalAsync: journalAsync),
        const SizedBox(height: 20),

        // ── Actions ───────────────────────────────
        Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Save & Apply'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: _getNextPrompt,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.emerald, width: 1),
                ),
                child: Text(
                  'Get Next Prompt',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.emerald,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _saveEntry() async {
    if (_journalController.text.trim().isEmpty) return;
    setState(() => _isSaving = true);

    // Read current ayah info from provider
    final ayahDataAsync = ref.read(dailyAyahProvider);
    final ayahData = ayahDataAsync.valueOrNull;
    final arabic = ayahData?.arabicText ?? _sampleAyah.arabic;
    final translation = ayahData?.translation ?? _sampleAyah.translation;
    final refText = ayahData != null
        ? '${ayahData.surahNumber}:${ayahData.ayahNumber}'
        : _sampleAyah.ref;

    final req = ReflectionRequest(
      arabicAyah: arabic,
      translation: translation,
      surahRef: refText,
    );
    final promptAsync = ref.read(reflectionPromptProvider(req));
    final prompt = promptAsync.valueOrNull?.question ?? 'Daily Reflection';

    await DbService.instance.saveJournalEntry(
      JournalEntry(
        createdAt: DateTime.now(),
        prompt: prompt,
        content: _journalController.text.trim(),
        linkedDeed: _selectedDeed,
        surahRef: refText,
        arabicAyah: arabic,
        isSaved: true,
      ),
    );

    // Award faith points for reflecting!
    await DbService.instance.addFaithPoints(score: 2, heart: 0.1);
    ref.invalidate(userProfileProvider);
    ref.invalidate(journalEntriesProvider);

    setState(() => _isSaving = false);
    _journalController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reflection saved. May Allah accept it. 🤲',
            style: AppTypography.bodyMedium,
          ),
          backgroundColor: AppColors.bgCardElevated,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _getNextPrompt() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Loading next reflection prompt…')),
    );
  }

  void _startVoiceInput() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice input coming soon…')),
    );
  }

  void _showJournalHistory(
      BuildContext context, AsyncValue<List<JournalEntry>> entries) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text('Journal History', style: AppTypography.headlineMedium),
            ),
            Expanded(
              child: entries.when(
                data: (list) => list.isEmpty
                    ? Center(
                        child: Text('No entries yet',
                            style: AppTypography.bodyMedium),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: list.length,
                        itemBuilder: (ctx, i) {
                          final e = list[i];
                          return NurPathCard(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      e.surahRef ?? '',
                                      style: AppTypography.surahRef,
                                    ),
                                    const Spacer(),
                                    Text(
                                      _formatDate(e.createdAt),
                                      style: AppTypography.bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(e.content,
                                    style: AppTypography.bodyMedium,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis),
                                if (e.linkedDeed != null) ...[
                                  const SizedBox(height: 6),
                                  _DeedChip(label: e.linkedDeed!),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (_, __) =>
                    const Center(child: Text('Could not load entries')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────────────────

class _ReflectAyahCard extends StatelessWidget {
  final String arabic;
  final String translation;
  final String surahRef;

  const _ReflectAyahCard({
    required this.arabic,
    required this.translation,
    required this.surahRef,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.emeraldDark, AppColors.bgCard],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.emerald.withOpacity(0.3), width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Reflect on ${surahRef.split(' ').take(2).join(' ')}',
            style: AppTypography.goldHeadline.copyWith(fontFamily: 'Amiri'),
          ),
          Text(surahRef, style: AppTypography.surahRef),
          const SizedBox(height: 16),
          Text(
            arabic,
            style: AppTypography.arabicLarge,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.emerald.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'AI-generated reflection with personal, meaningful, authentic Tafseer',
              style: AppTypography.bodySmall.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReflectionPromptCard extends StatelessWidget {
  final String prompt;
  final String tafseeerRef;

  const _ReflectionPromptCard({
    required this.prompt,
    required this.tafseeerRef,
  });

  @override
  Widget build(BuildContext context) {
    return NurPathCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.emerald, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  prompt,
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('— $tafseeerRef', style: AppTypography.surahRef),
        ],
      ),
    );
  }
}

class _JournalEditor extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onVoiceInput;

  const _JournalEditor({
    required this.controller,
    required this.onVoiceInput,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            maxLines: 5,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Private digital journal entry…',
              hintStyle:
                  AppTypography.bodyMedium.copyWith(color: AppColors.textDisabled),
              border: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: onVoiceInput,
                child: Row(
                  children: [
                    const Icon(Icons.mic_rounded,
                        size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      'Voice-to-Text',
                      style: AppTypography.labelSmall
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.bgCardElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.volume_up_rounded,
                        size: 14, color: AppColors.emerald),
                    const SizedBox(width: 4),
                    Text(
                      '3 Text',
                      style: AppTypography.labelSmall
                          .copyWith(color: AppColors.emerald),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.keyboard_arrow_down,
                        size: 14, color: AppColors.textMuted),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeedLinker extends StatelessWidget {
  final String? selectedDeed;
  final List<String> deeds;
  final bool showDropdown;
  final VoidCallback onToggleDropdown;
  final ValueChanged<String> onSelectDeed;

  const _DeedLinker({
    required this.selectedDeed,
    required this.deeds,
    required this.showDropdown,
    required this.onToggleDropdown,
    required this.onSelectDeed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: NurPathCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Text('Save reflection', style: AppTypography.labelMedium),
                    const SizedBox(width: 6),
                    const Icon(Icons.diamond_rounded,
                        size: 14, color: AppColors.gold),
                    const SizedBox(width: 3),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.emerald,
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onToggleDropdown,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.divider, width: 0.5),
                ),
                child: Row(
                  children: [
                    Text(
                      selectedDeed ?? 'Link to Deed',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down,
                        size: 16, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (showDropdown) ...[
          const SizedBox(height: 8),
          NurPathCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: deeds.map((deed) {
                final isSelected = deed == selectedDeed;
                return InkWell(
                  onTap: () => onSelectDeed(deed),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Text(deed, style: AppTypography.bodyMedium),
                        const Spacer(),
                        if (isSelected)
                          const Icon(Icons.check_rounded,
                              size: 16, color: AppColors.emerald),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

class _JournalTimeline extends StatelessWidget {
  final AsyncValue<List<JournalEntry>> journalAsync;

  const _JournalTimeline({required this.journalAsync});

  @override
  Widget build(BuildContext context) {
    return journalAsync.when(
      data: (entries) {
        if (entries.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Reflections', style: AppTypography.headlineSmall),
            const SizedBox(height: 10),
            ...entries.take(3).map((e) => _TimelineEntry(entry: e)),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  final JournalEntry entry;

  const _TimelineEntry({required this.entry});

  @override
  Widget build(BuildContext context) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dateStr =
        '${months[entry.createdAt.month - 1]} ${entry.createdAt.day} '
        '${entry.createdAt.hour}:${entry.createdAt.minute.toString().padLeft(2, '0')}h';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 16, color: AppColors.textMuted),
              Container(width: 1, height: 32, color: AppColors.divider),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
                Text(
                  entry.surahRef ?? '',
                  style: AppTypography.surahRef.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeedChip extends StatelessWidget {
  final String label;

  const _DeedChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.gold.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.gold,
          fontSize: 10,
        ),
      ),
    );
  }
}
