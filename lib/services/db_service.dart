import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

/// Web-compatible local storage using Hive.
/// Replaces Isar which is native-only (iOS/Android/desktop).
class DbService {
  static DbService? _instance;
  static DbService get instance => _instance!;

  static const _userBox = 'user';
  static const _journalBox = 'journal';
  static const _srsBox = 'srs';
  static const _journeysBox = 'journeys';
  static const _progressBox = 'progress';

  DbService._();

  static Future<DbService> init() async {
    if (_instance != null) return _instance!;
    _instance = DbService._();
    await _instance!._open();
    return _instance!;
  }

  Future<void> _open() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(_userBox),
      Hive.openBox(_journalBox),
      Hive.openBox(_srsBox),
      Hive.openBox(_journeysBox),
      Hive.openBox(_progressBox),
    ]);
    await _seedDefaultData();
  }

  Future<void> _seedDefaultData() async {
    final journeysBox = Hive.box(_journeysBox);
    if (journeysBox.isEmpty) {
      final defaults = [
        ThematicJourney(
          id: 'healing-heart',
          title: 'Healing the Heart in Trials',
          subtitle: 'Surah Yusuf',
          surahReference: 'Surah Yusuf (12)',
          totalDays: 7,
          completedDays: 3,
        ),
        ThematicJourney(
          id: 'building-patience',
          title: 'Building Patience as a Parent',
          subtitle: '14 days',
          surahReference: 'Various Surahs',
          totalDays: 14,
        ),
        ThematicJourney(
          id: 'gratitude-daily',
          title: 'Gratitude in Daily Life',
          subtitle: 'Al-Baqarah Verses',
          surahReference: 'Al-Baqarah (2)',
          totalDays: 10,
        ),
        ThematicJourney(
          id: 'prophets-stories',
          title: 'Stories of the Prophets',
          subtitle: 'Prophets for Today',
          surahReference: 'Multiple Surahs',
          totalDays: 30,
        ),
      ];
      for (final j in defaults) {
        await journeysBox.put(j.id, j.toMap());
      }
    }

    final userBox = Hive.box(_userBox);
    if (!userBox.containsKey('profile')) {
      await userBox.put(
        'profile',
        UserProfile(
          name: 'Hassan',
          joinedAt: DateTime.now(),
          currentStreak: 7,
          longestStreak: 12,
          faithScore: 82,
          quranEngagement: 0.95,
          heartReflection: 0.75,
          salahAlignment: 0.70,
          actsOfKindness: 0.88,
          dailyAyahGoal: 5,
          offlineMode: true,
          onboardingComplete: false,
        ).toMap(),
      );
    }

    final srsBox = Hive.box(_srsBox);
    if (srsBox.isEmpty) {
      final srsDefaults = [
        SRSCard(surahNumber: 1, ayahNumber: 1, arabicText: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ', translation: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.', isMastered: false, retentionStrength: 0.2),
        SRSCard(surahNumber: 1, ayahNumber: 2, arabicText: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ', translation: 'All praise is due to Allah, Lord of the worlds.', isMastered: false, retentionStrength: 0.5),
        SRSCard(surahNumber: 1, ayahNumber: 3, arabicText: 'ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ', translation: 'The Entirely Merciful, the Especially Merciful.', isMastered: true, retentionStrength: 0.95),
        SRSCard(surahNumber: 1, ayahNumber: 4, arabicText: 'مَـٰلِكِ يَوْمِ ٱلدِّينِ', translation: 'Sovereign of the Day of Recompense.', isMastered: false, retentionStrength: 0.1),
        SRSCard(surahNumber: 1, ayahNumber: 5, arabicText: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', translation: 'It is You we worship and You we ask for help.', isMastered: false, retentionStrength: 0.3),
        SRSCard(surahNumber: 1, ayahNumber: 6, arabicText: 'ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ', translation: 'Guide us to the straight path.', isMastered: true, retentionStrength: 0.8),
        SRSCard(surahNumber: 1, ayahNumber: 7, arabicText: 'صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ', translation: 'The path of those upon whom You have bestowed favor, not of those who have earned anger or gone astray.', isMastered: false, retentionStrength: 0.0),
      ];
      for (final card in srsDefaults) {
        await srsBox.put(card.id, card.toMap());
      }
    }
  }

  // ── User ──────────────────────────────────────────────────────────────────

  Future<UserProfile?> getUser() async {
    final box = Hive.box(_userBox);
    final data = box.get('profile');
    if (data == null) return null;
    return UserProfile.fromMap(data as Map);
  }

  Future<void> saveUser(UserProfile user) async {
    await Hive.box(_userBox).put('profile', user.toMap());
  }

  // ── Journal ───────────────────────────────────────────────────────────────

  Future<List<JournalEntry>> getJournalEntries({int limit = 20}) async {
    final box = Hive.box(_journalBox);
    final entries = box.values
        .map((e) => JournalEntry.fromMap(e as Map))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries.take(limit).toList();
  }

  Future<void> saveJournalEntry(JournalEntry entry) async {
    await Hive.box(_journalBox).put(entry.id, entry.toMap());
  }

  // ── SRS ───────────────────────────────────────────────────────────────────

  Future<List<SRSCard>> getDueSRSCards() async {
    final now = DateTime.now();
    final box = Hive.box(_srsBox);
    return box.values
        .map((e) => SRSCard.fromMap(e as Map))
        .where((c) =>
            c.nextReviewDate == null || c.nextReviewDate!.isBefore(now))
        .toList();
  }

  Future<void> saveSRSCard(SRSCard card) async {
    await Hive.box(_srsBox).put(card.id, card.toMap());
  }

  // ── Journeys ──────────────────────────────────────────────────────────────

  Future<List<ThematicJourney>> getAllJourneys() async {
    final box = Hive.box(_journeysBox);
    return box.values
        .map((e) => ThematicJourney.fromMap(e as Map))
        .toList();
  }

  Future<ThematicJourney?> getActiveJourney() async {
    final all = await getAllJourneys();
    try {
      return all.firstWhere((j) => j.isActive);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveJourney(ThematicJourney journey) async {
    await Hive.box(_journeysBox).put(journey.id, journey.toMap());
  }

  // ── Daily Progress ────────────────────────────────────────────────────────

  Future<DailyProgress> getTodayProgress() async {
    final today = DailyProgress(date: _dateOnly(DateTime.now()));
    final box = Hive.box(_progressBox);
    final data = box.get(today.id);
    if (data == null) {
      await box.put(today.id, today.toMap());
      return today;
    }
    return DailyProgress.fromMap(data as Map);
  }

  Future<List<DailyProgress>> getWeekProgress() async {
    final box = Hive.box(_progressBox);
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return box.values
        .map((e) => DailyProgress.fromMap(e as Map))
        .where((p) => p.date.isAfter(weekAgo))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> saveDailyProgress(DailyProgress progress) async {
    await Hive.box(_progressBox).put(progress.id, progress.toMap());
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}
