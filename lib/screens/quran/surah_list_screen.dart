import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../providers/app_providers.dart';
import '../../widgets/geometric_pattern.dart';

class SurahListScreen extends ConsumerWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahListAsync = ref.watch(surahListProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: GeometricPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Text('Quran', style: AppTypography.displaySmall),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.search_rounded,
                          color: AppColors.textSecondary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: surahListAsync.when(
                  data: (surahs) => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: surahs.length,
                    itemBuilder: (ctx, i) {
                      final s = surahs[i];
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
                        onTap: () => context.go('/learn/surah/${s.number}'),
                      );
                    },
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.emerald),
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
