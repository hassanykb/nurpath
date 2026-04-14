import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'nurpath_card.dart';

class AyahCard extends StatelessWidget {
  final String arabic;
  final String translation;
  final String surahName;
  final int surahNumber;
  final int ayahNumber;
  final bool showBookmark;
  final bool isBookmarked;
  final VoidCallback? onBookmark;
  final VoidCallback? onPlay;
  final VoidCallback? onShare;
  final VoidCallback? onAsk;
  final bool isPlaying;

  const AyahCard({
    super.key,
    required this.arabic,
    required this.translation,
    required this.surahName,
    required this.surahNumber,
    required this.ayahNumber,
    this.showBookmark = true,
    this.isBookmarked = false,
    this.onBookmark,
    this.onPlay,
    this.onShare,
    this.onAsk,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return GoldBorderCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Surah reference header ──────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.emerald.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  '$surahName : $ayahNumber',
                  style: AppTypography.surahRef,
                ),
              ),
              const Spacer(),
              if (showBookmark)
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
                    size: 20,
                    color: isBookmarked ? AppColors.gold : AppColors.textMuted,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: onBookmark,
                ),
              if (onPlay != null)
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                    size: 20,
                    color: AppColors.emerald,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: onPlay,
                ),
              if (onShare != null)
                IconButton(
                  icon: const Icon(Icons.share_rounded, size: 18, color: AppColors.textMuted),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: onShare,
                ),
            ],
          ),
          const SizedBox(height: 16),
          const _BismillahDivider(),
          const SizedBox(height: 16),
          // ── Arabic text ──────────────────────────────────────
          Text(
            arabic,
            style: AppTypography.arabicLarge,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 16),
          Container(height: 0.5, color: AppColors.divider),
          const SizedBox(height: 12),
          // ── Translation ──────────────────────────────────────
          Text(translation, style: AppTypography.bodyMedium),
          // ── Ask about this Ayah ──────────────────────────────
          if (onAsk != null) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onAsk,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.emerald.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.auto_awesome, size: 15, color: AppColors.emerald),
                    const SizedBox(width: 8),
                    Text(
                      'Ask about this Ayah',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.emerald),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BismillahDivider extends StatelessWidget {
  const _BismillahDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 0.5, color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.auto_awesome, size: 12, color: AppColors.gold.withOpacity(0.6)),
        ),
        Expanded(child: Container(height: 0.5, color: AppColors.divider)),
      ],
    );
  }
}

/// Mini inline ayah for lists
class AyahListTile extends StatelessWidget {
  final int ayahNumber;
  final String arabic;
  final String translation;
  final bool isActive;
  final VoidCallback? onTap;

  const AyahListTile({
    super.key,
    required this.ayahNumber,
    required this.arabic,
    required this.translation,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.emerald.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: AppColors.emerald.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.emerald : AppColors.bgCardElevated,
                border: Border.all(
                  color: isActive ? AppColors.emerald : AppColors.divider,
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  '$ayahNumber',
                  style: AppTypography.labelSmall.copyWith(
                    color: isActive ? Colors.white : AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    arabic,
                    style: AppTypography.arabicSmall,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    translation,
                    style: AppTypography.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
