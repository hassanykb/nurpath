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
  static const _bookmarksBox = 'bookmarks';

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
      Hive.openBox(_bookmarksBox),
    ]);
    await _seedDefaultData();
  }

  Future<void> _seedDefaultData() async {
    final journeysBox = Hive.box(_journeysBox);
    // Always reseed to pick up new fields (description, dailyLessons)
    final defaults = [
      ThematicJourney(
        id: 'healing-heart',
        title: 'Healing the Heart in Trials',
        subtitle: 'Surah Yusuf',
        surahReference: 'Surah Yusuf (12)',
        category: 'Healing',
        totalDays: 7,
        completedDays: 3,
        description:
            'Prophet Yusuf (AS) endured jealousy, imprisonment, and separation — yet he never lost hope in Allah. This 7-day journey walks through his story to help you find patience and trust when life feels overwhelming.',
        dailyLessons: [
          'Day 1 — The Dream: Read Yusuf 12:4-6. Reflect on a dream or goal you hold. How do you trust Allah with it?',
          'Day 2 — The Betrayal: Read 12:7-18. When others wrong you, how can you respond with Sabr (patience)?',
          'Day 3 — The Test of Temptation: Read 12:23-29. What desires pull you away from your values? Name one you will resist today.',
          'Day 4 — The Prison: Read 12:36-42. In your hardest moment, how did (or can) faith sustain you?',
          'Day 5 — The Forgotten Friend: Read 12:42. Has Allah delayed something for you? Write a du\'a of trust.',
          'Day 6 — The Interpretation: Read 12:43-49. Reflect on a problem you are facing. What wisdom might Allah be teaching you through it?',
          'Day 7 — The Reunion: Read 12:93-101. Who in your life needs your forgiveness today? Take one step toward it.',
        ],
      ),
      ThematicJourney(
        id: 'building-patience',
        title: 'Building Patience as a Parent',
        subtitle: 'Parenting with Sabr',
        surahReference: 'Various Surahs',
        category: 'Parenting',
        totalDays: 14,
        description:
            'Parenting is one of Allah\'s greatest tests and greatest gifts. This 14-day program draws on Quranic wisdom about raising children with love, boundaries, and deep trust in Allah\'s plan for your family.',
        dailyLessons: [
          'Day 1 — Gratitude for the Gift: Read Al-Kahf 18:46. Your children are a Trust from Allah. Journal: What do you love most about them today?',
          'Day 2 — Prophet Ibrahim & His Son: Read As-Saffat 37:100-111. How do you involve your children in dua?',
          'Day 3 — The Du\'a of Patience: Memorise "Rabbi hab li min al-salihin" (37:100). Recite it 10 times.',
          'Day 4 — Anger & Control: Read Al-Imran 3:134. Identify one parenting trigger. Plan your calm response in advance.',
          'Day 5 — Luqman\'s Wisdom Part 1: Read Luqman 31:13-15. Avoid shirk in all your teachings.',
          'Day 6 — Luqman\'s Wisdom Part 2: Read 31:16-19. How do you model humility for your children?',
          'Day 7 — The Weekend Rest: Rest, play, and connect. No lesson — just presence.',
          'Day 8 — Consistency in Salah: Read 20:132. How do you encourage salah without forcing it?',
          'Day 9 — The Difficult Child: Read Al-Baqarah 2:155. Every hard moment is a test. Make du\'a for your child by name.',
          'Day 10 — Stories Before Bed: Share a Prophet\'s story tonight. Which story will you choose?',
          'Day 11 — Forgiving Your Children: Read Al-Baqarah 2:286. Write down one expectation you will release.',
          'Day 12 — Nurturing Fitrah: Read Ar-Rum 30:30. What activities strengthen your child\'s natural faith?',
          'Day 13 — Du\'a for Righteous Children: Recite "Rabbana hab lana min azwajina…" (25:74) 33 times.',
          'Day 14 — Completion: Write a letter to your child about your hopes for their spiritual life.',
        ],
      ),
      ThematicJourney(
        id: 'gratitude-daily',
        title: 'Gratitude in Daily Life',
        subtitle: 'The Power of Shukr',
        surahReference: 'Al-Baqarah (2)',
        category: 'Gratitude',
        totalDays: 10,
        description:
            'Allah promises: "If you are grateful, I will surely increase you." This 10-day journey trains your heart to notice, name, and express gratitude through Quranic reflection and daily practical acts of shukr.',
        dailyLessons: [
          'Day 1 — The Promise: Read Ibrahim 14:7. Write 5 things you are grateful for right now.',
          'Day 2 — Alhamdulillah: Read Al-Fatiha 1:2. How often do you truly pause on this word? Recite it slowly 33 times.',
          'Day 3 — Gratitude Through Difficulty: Read Al-Baqarah 2:152-157. Can you thank Allah even for a hardship?',
          'Day 4 — The Eyes & the Ears: Read An-Nahl 16:78. Spend 5 minutes in sensory gratitude — list what you see, hear, and feel.',
          'Day 5 — Gratitude in Abundance: Read Saba 34:13-15. How do you use your blessings to serve others?',
          'Day 6 — The Tongue of Gratitude: Replace one complaint today with a praise. Track how many you catch.',
          'Day 7 — Friday Gratitude: Read Al-Jumu\'ah 62:10. After Jumu\'ah, perform one act of sadaqah.',
          'Day 8 — Gratitude for Health: Read Al-Insan 76:1-3. Make du\'a for someone who is ill.',
          'Day 9 — Sharing Gratitude: Thank one person in your life with specific words today.',
          'Day 10 — The Grateful Heart: Read Az-Zumar 39:66. Write your personal "Alhamdulillah letter" to Allah.',
        ],
      ),
      ThematicJourney(
        id: 'prophets-stories',
        title: 'Stories of the Prophets',
        subtitle: 'Lessons for Today',
        surahReference: 'Multiple Surahs',
        category: 'Prophets',
        totalDays: 30,
        description:
            'The Quran calls stories of the Prophets "the best of stories." This 30-day journey visits 10 major Prophets — 3 days per Prophet — drawing timeless lessons for modern life from each of their tests, triumphs, and character.',
        dailyLessons: [
          'Day 1 — Adam (AS): Read Al-Baqarah 2:30-37. Reflect on the nature of human error and tawbah (repentance).',
          'Day 2 — Adam (AS): What does it mean to be Allah\'s khalifah on earth? How do you live that today?',
          'Day 3 — Adam (AS): Read 2:38. Write a personal du\'a asking for guidance when you feel lost.',
          'Day 4 — Nuh (AS): Read Hud 11:25-48. Nuh preached for 950 years. What long-term effort requires your patience?',
          'Day 5 — Nuh (AS): Read 71:5-20. How do you give da\'wah through your character, not just your words?',
          'Day 6 — Nuh (AS): Make du\'a for a family member who is struggling spiritually.',
          'Day 7 — Ibrahim (AS): Read Al-Anbiya 21:51-71. How do you respond when your beliefs are challenged?',
          'Day 8 — Ibrahim (AS): Read As-Saffat 37:83-113. What sacrifice is Allah asking of you right now?',
          'Day 9 — Ibrahim (AS): Read Ibrahim 14:35-41. Memorise his du\'a for himself and his children.',
          'Day 10 — Musa (AS): Read Al-Qasas 28:2-35. Musa feared public speaking. What weakness do you offer to Allah?',
          'Day 11 — Musa (AS): Read 20:25-36. Use the du\'a "Rabbi ishrah li sadri" in your salah today.',
          'Day 12 — Musa (AS): Read 28:56. Only Allah guides hearts. Release worry about those you love.',
          'Day 13 — Isa (AS): Read Maryam 19:29-34. Isa spoke from the cradle. What gift has Allah given you?',
          'Day 14 — Isa (AS): Read Al-Ma\'idah 5:110-115. Gratitude for miracles we overlook daily.',
          'Day 15 — Isa (AS): Perform an unexpected act of kindness for someone today — anonymously.',
          'Day 16 — Yusuf (AS): Read Yusuf 12:1-20. Betrayal from family. How do you forgive close ones?',
          'Day 17 — Yusuf (AS): Read 12:56-57. Success after hardship. What "door" has Allah recently opened for you?',
          'Day 18 — Yusuf (AS): Read 12:87. "Do not despair of the mercy of Allah." Write this on something visible.',
          'Day 19 — Dawud (AS): Read Sad 38:17-26. Dawud was a king and a poet. How do you combine worldly work with worship?',
          'Day 20 — Dawud (AS): Recite Tasbeeh 100 times today, as Dawud glorified Allah constantly.',
          'Day 21 — Dawud (AS): Read Al-Anbiya 21:78-80. What skill has Allah given you to serve the ummah?',
          'Day 22 — Sulayman (AS): Read An-Naml 27:15-19. Power and humility can coexist. Reflect on your leadership.',
          'Day 23 — Sulayman (AS): Read 27:40-44. Gratitude for resources. How do you use your wealth/position for good?',
          'Day 24 — Sulayman (AS): Make du\'a for Muslim leaders around the world.',
          'Day 25 — Ayyub (AS): Read Al-Anbiya 21:83-84. Ayyub\'s loss was complete. What loss tests your faith most?',
          'Day 26 — Ayyub (AS): Read 38:41-44. His cure came through supplication. Make a heartfelt du\'a for healing.',
          'Day 27 — Ayyub (AS): Visit or call someone who is suffering today.',
          'Day 28 — Muhammad ﷺ: Read Al-Ahzab 33:21. How do you embody his sunnah in your daily habits?',
          'Day 29 — Muhammad ﷺ: Read Ad-Duha 93:1-11. Allah never abandoned him. Write about a moment you felt Allah\'s care.',
          'Day 30 — Muhammad ﷺ: Read Al-Anbiya 21:107. Commit to one lasting sunnah going forward. Announce it to yourself.',
        ],
      ),
    ];
    // Clear and reseed so updated fields persist
    await journeysBox.clear();
    for (final j in defaults) {
      await journeysBox.put(j.id, j.toMap());
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

  Future<void> addFaithPoints({
    int score = 0,
    double quran = 0.0,
    double heart = 0.0,
    double salah = 0.0,
    double kindness = 0.0,
  }) async {
    final user = await getUser();
    if (user != null) {
      user.faithScore += score;
      if (user.faithScore > 100) user.faithScore = 100;
      
      user.quranEngagement = (user.quranEngagement + quran).clamp(0.0, 1.0);
      user.heartReflection = (user.heartReflection + heart).clamp(0.0, 1.0);
      user.salahAlignment = (user.salahAlignment + salah).clamp(0.0, 1.0);
      user.actsOfKindness = (user.actsOfKindness + kindness).clamp(0.0, 1.0);
      
      await saveUser(user);
    }
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

  // ── Bookmarks ─────────────────────────────────────────────────────────────

  Future<bool> isBookmarked(int surahNumber, int ayahNumber) async {
    final box = Hive.box(_bookmarksBox);
    return box.containsKey('$surahNumber:$ayahNumber');
  }

  /// Returns the full set of bookmarked keys ('surahNumber:ayahNumber').
  Set<String> getBookmarkedKeys() {
    return Hive.box(_bookmarksBox).keys.cast<String>().toSet();
  }

  Future<void> toggleBookmark({
    required int surahNumber,
    required int ayahNumber,
    required String arabicText,
    required String translation,
  }) async {
    final box = Hive.box(_bookmarksBox);
    final key = '$surahNumber:$ayahNumber';
    if (box.containsKey(key)) {
      await box.delete(key);
    } else {
      await box.put(key, {
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'arabicText': arabicText,
        'translation': translation,
        'bookmarkedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<List<Map<dynamic, dynamic>>> getBookmarks() async {
    final box = Hive.box(_bookmarksBox);
    return box.values.cast<Map<dynamic, dynamic>>().toList()
      ..sort((a, b) => (b['bookmarkedAt'] as String)
          .compareTo(a['bookmarkedAt'] as String));
  }
}
