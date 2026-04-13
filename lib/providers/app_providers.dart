import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ayah_model.dart';
import '../models/user_model.dart';
import '../services/quran_api_service.dart';
import '../services/audio_service.dart';
import '../services/db_service.dart';

// ============================================================
// SERVICES
// ============================================================

final quranApiProvider = Provider<QuranApiService>((ref) {
  return QuranApiService();
});

final audioServiceProvider = Provider<NurPathAudioService>((ref) {
  final service = NurPathAudioService();
  ref.onDispose(service.dispose);
  return service;
});

// ============================================================
// USER / PROFILE
// ============================================================

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  return DbService.instance.getUser();
});

final currentStreakProvider = Provider<int>((ref) {
  final user = ref.watch(userProfileProvider).valueOrNull;
  return user?.currentStreak ?? 0;
});

// ============================================================
// QURAN DATA
// ============================================================

final surahListProvider = FutureProvider<List<SurahData>>((ref) async {
  final api = ref.watch(quranApiProvider);
  return api.fetchSurahList();
});

final surahProvider =
    FutureProvider.family<SurahWithTranslation, int>((ref, surahNumber) async {
  final api = ref.watch(quranApiProvider);
  return api.fetchSurah(surahNumber);
});

final dailyAyahProvider = FutureProvider<AyahData>((ref) async {
  final api = ref.watch(quranApiProvider);
  return api.fetchRandomAyah();
});

// Currently selected surah/ayah
final selectedSurahProvider = StateProvider<int>((ref) => 1);
final selectedAyahProvider = StateProvider<int>((ref) => 1);

// ============================================================
// AUDIO
// ============================================================

final isPlayingProvider = StateProvider<bool>((ref) => false);
final playbackSpeedProvider = StateProvider<double>((ref) => 1.0);
final audioProgressProvider = StateProvider<double>((ref) => 0.0);
final currentReciterProvider = StateProvider<String>((ref) => 'Mishary Rashid Alafasy');

// ============================================================
// JOURNEYS
// ============================================================

final journeysProvider = FutureProvider<List<ThematicJourney>>((ref) async {
  return DbService.instance.getAllJourneys();
});

final activeJourneyProvider = FutureProvider<ThematicJourney?>((ref) async {
  return DbService.instance.getActiveJourney();
});

// ============================================================
// JOURNAL / REFLECT
// ============================================================

final journalEntriesProvider = FutureProvider<List<JournalEntry>>((ref) async {
  return DbService.instance.getJournalEntries();
});

final reflectionPromptProvider =
    FutureProvider.family<ReflectionPrompt, ReflectionRequest>(
        (ref, request) async {
  final api = ref.watch(quranApiProvider);
  return api.generateReflectionPrompt(
    arabicAyah: request.arabicAyah,
    translation: request.translation,
    surahRef: request.surahRef,
  );
});

// ============================================================
// SRS / MEMORIZE
// ============================================================

final srsCardsProvider = FutureProvider<List<SRSCard>>((ref) async {
  return DbService.instance.getDueSRSCards();
});

// ============================================================
// DAILY PROGRESS
// ============================================================

final todayProgressProvider = FutureProvider<DailyProgress>((ref) async {
  return DbService.instance.getTodayProgress();
});

final weekProgressProvider = FutureProvider<List<DailyProgress>>((ref) async {
  return DbService.instance.getWeekProgress();
});

// ============================================================
// UI STATE
// ============================================================

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
final isWordByWordProvider = StateProvider<bool>((ref) => false);
final selectedDeedProvider = StateProvider<String?>((ref) => null);

// ============================================================
// HELPER CLASSES
// ============================================================

class ReflectionRequest {
  final String arabicAyah;
  final String translation;
  final String surahRef;

  const ReflectionRequest({
    required this.arabicAyah,
    required this.translation,
    required this.surahRef,
  });

  @override
  bool operator ==(Object other) =>
      other is ReflectionRequest && other.surahRef == surahRef;

  @override
  int get hashCode => surahRef.hashCode;
}
