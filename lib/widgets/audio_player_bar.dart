import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AudioPlayerBar extends StatelessWidget {
  final bool isPlaying;
  final double progress; // 0.0 to 1.0
  final String reciterName;
  final String surahName;
  final double playbackSpeed;
  final List<String> availableSpeedOptions;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final ValueChanged<double> onSpeedChange;
  final ValueChanged<double> onSeek;

  const AudioPlayerBar({
    super.key,
    required this.isPlaying,
    required this.progress,
    required this.reciterName,
    required this.surahName,
    required this.playbackSpeed,
    required this.onPlayPause,
    required this.onNext,
    required this.onSpeedChange,
    required this.onSeek,
    this.availableSpeedOptions = const ['0.5x', '0.75x', '1x', '1.5x', '2x'],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCardElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Seeker
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: onSeek,
              activeColor: AppColors.emerald,
              inactiveColor: AppColors.divider,
            ),
          ),
          const SizedBox(height: 8),
          // Controls row
          Row(
            children: [
              // Play/Pause + Next
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 32,
                  color: AppColors.emerald,
                ),
                onPressed: onPlayPause,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next_rounded, size: 28, color: AppColors.textSecondary),
                onPressed: onNext,
              ),
              const SizedBox(width: 8),
              // Speed chips
              ...[0.5, 0.75, 1.0, 1.5, 2.0].map((speed) {
                final label = speed == speed.truncateToDouble()
                    ? '${speed.toInt()}x'
                    : '${speed}x';
                final isSelected = playbackSpeed == speed;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => onSpeedChange(speed),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.emerald : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.emerald : AppColors.divider,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        label,
                        style: AppTypography.labelSmall.copyWith(
                          color: isSelected ? Colors.white : AppColors.textMuted,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const Spacer(),
              // Reciter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                constraints: const BoxConstraints(maxWidth: 60),
                child: Icon(
                  Icons.loop_rounded,
                  size: 20,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Reciter selector
          Row(
            children: [
              Expanded(
                child: _ReciterChip(
                  name: reciterName,
                  isSelected: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ReciterChip(
                  name: 'Abdul Rahman Al-Sudais',
                  isSelected: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Tafseer row
          Row(
            children: [
              _TafseerChip(label: 'Reciter', isDropdown: true),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.emerald,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        'Ask About This Ayah',
                        style: AppTypography.labelMedium.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReciterChip extends StatelessWidget {
  final String name;
  final bool isSelected;

  const _ReciterChip({required this.name, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.bgSurface : AppColors.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColors.emerald.withOpacity(0.4) : AppColors.divider,
          width: 0.5,
        ),
      ),
      child: Text(
        name,
        style: AppTypography.labelSmall.copyWith(
          color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
          fontSize: 10,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TafseerChip extends StatelessWidget {
  final String label;
  final bool isDropdown;

  const _TafseerChip({required this.label, this.isDropdown = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTypography.labelSmall),
          if (isDropdown) ...[
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.textMuted),
          ],
        ],
      ),
    );
  }
}
