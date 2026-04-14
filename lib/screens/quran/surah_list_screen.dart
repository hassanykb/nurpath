import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/app_providers.dart';
import '../../widgets/geometric_pattern.dart';

class SurahListScreen extends ConsumerStatefulWidget {
  const SurahListScreen({super.key});

  @override
  ConsumerState<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends ConsumerState<SurahListScreen> {
  bool _searching = false;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahListAsync = ref.watch(surahListProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: GeometricPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── Header / Search bar ────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: _searching
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              style: AppTypography.bodyMedium,
                              decoration: InputDecoration(
                                hintText: 'Search surah name or number…',
                                hintStyle: AppTypography.bodyMedium
                                    .copyWith(color: AppColors.textDisabled),
                                filled: true,
                                fillColor: AppColors.bgCardElevated,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                prefixIcon: const Icon(Icons.search_rounded,
                                    color: AppColors.textMuted),
                              ),
                              onChanged: (v) =>
                                  setState(() => _query = v.toLowerCase().trim()),
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.textSecondary),
                            onPressed: () => setState(() {
                              _searching = false;
                              _query = '';
                              _searchController.clear();
                            }),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Text('Quran', style: AppTypography.displaySmall),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.search_rounded,
                                color: AppColors.textSecondary),
                            onPressed: () =>
                                setState(() => _searching = true),
                          ),
                        ],
                      ),
              ),

              // ── Surah List ────────────────────────────────────
              Expanded(
                child: surahListAsync.when(
                  data: (surahs) {
                    final filtered = _query.isEmpty
                        ? surahs
                        : surahs.where((s) {
                            return s.nameEnglish
                                    .toLowerCase()
                                    .contains(_query) ||
                                s.nameTransliteration
                                    .toLowerCase()
                                    .contains(_query) ||
                                s.number.toString() == _query;
                          }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.search_off_rounded,
                                color: AppColors.textMuted, size: 48),
                            const SizedBox(height: 12),
                            Text('No surahs match "$_query"',
                                style: AppTypography.bodyMedium),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final s = filtered[i];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 4),
                          leading: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.bgCardElevated,
                              border: Border.all(
                                  color: AppColors.divider, width: 0.5),
                            ),
                            child: Center(
                              child: Text(
                                '${s.number}',
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.gold,
                                ),
                              ),
                            ),
                          ),
                          title: Text(s.nameEnglish,
                              style: AppTypography.titleMedium),
                          subtitle: Text(
                            '${s.nameTransliteration} · ${s.ayahCount} ayahs',
                            style: AppTypography.bodySmall,
                          ),
                          trailing: Text(
                            s.nameArabic,
                            style: AppTypography.arabicSmall.copyWith(
                              fontSize: 16,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          onTap: () =>
                              context.go('/learn/surah/${s.number}'),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.emerald),
                  ),
                  error: (_, __) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_off_rounded,
                            color: AppColors.textMuted, size: 48),
                        const SizedBox(height: 12),
                        Text('Could not load Surahs',
                            style: AppTypography.bodyMedium),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => ref.refresh(surahListProvider),
                          child: const Text('Retry'),
                        ),
                      ],
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
}
