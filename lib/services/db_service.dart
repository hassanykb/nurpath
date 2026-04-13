import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/ayah_model.dart';
import '../models/user_model.dart';

class DbService {
  static DbService? _instance;
  static DbService get instance => _instance!;

  late Isar _isar;
  Isar get isar => _isar;

  DbService._();

  static Future<DbService> init() async {
    if (_instance != null) return _instance!;
    _instance = DbService._();
    await _instance!._open();
    return _instance!;
  }

  Future<void> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        AyahModelSchema,
        SurahModelSchema,
        UserProfileSchema,
        JournalEntrySchema,
        SRSCardSchema,
        ThematicJourneySchema,
        DailyProgressSchema,
      ],
      directory: dir.path,
      name: 'nurpath_db',
    );

    // Seed default journeys if empty
    await _seedDefaultData();
  }

  Future<void> _seedDefaultData() async {
    final count = await _isar.thematicJourneys.count();
    if (count == 0) {
      await _isar.writeTxn(() async {
        await _isar.thematicJourneys.putAll([
          ThematicJourney()
            ..title = 'Healing the Heart in Trials'
            ..subtitle = 'Surah Yusuf'
            ..surahReference = 'Surah Yusuf (12)'
            ..totalDays = 7
            ..completedDays = 3,
          ThematicJourney()
            ..title = 'Building Patience as a Parent'
            ..subtitle = '14 days'
            ..surahReference = 'Various Surahs'
            ..totalDays = 14
            ..completedDays = 0,
          ThematicJourney()
            ..title = 'Gratitude in Daily Life'
            ..subtitle = 'Al-Baqarah Verses'
            ..surahReference = 'Al-Baqarah (2)'
            ..totalDays = 10
            ..completedDays = 0,
          ThematicJourney()
            ..title = 'Stories of the Prophets'
            ..subtitle = 'Prophets for Today'
            ..surahReference = 'Multiple Surahs'
            ..totalDays = 30
            ..completedDays = 0,
        ]);
      });
    }

    // Create default user if not exists
    final user = await _isar.userProfiles.get(1);
    if (user == null) {
      await _isar.writeTxn(() async {
        await _isar.userProfiles.put(
          UserProfile()
            ..id = 1
            ..name = 'Hassan'
            ..joinedAt = DateTime.now()
            ..currentStreak = 7
            ..longestStreak = 12
            ..faithScore = 82
            ..quranEngagement = 0.95
            ..heartReflection = 0.75
            ..salahAlignment = 0.70
            ..actsOfKindness = 0.88
            ..dailyAyahGoal = 5
            ..offlineMode = true
            ..onboardingComplete = false,
        );
      });
    }
  }

  // ---- User ----
  Future<UserProfile?> getUser() => _isar.userProfiles.get(1);

  Future<void> saveUser(UserProfile user) async {
    await _isar.writeTxn(() => _isar.userProfiles.put(user));
  }

  // ---- Journal ----
  Future<List<JournalEntry>> getJournalEntries({int limit = 20}) {
    return _isar.journalEntrys
        .where()
        .sortByCreatedAtDesc()
        .limit(limit)
        .findAll();
  }

  Future<void> saveJournalEntry(JournalEntry entry) async {
    await _isar.writeTxn(() => _isar.journalEntrys.put(entry));
  }

  // ---- SRS ----
  Future<List<SRSCard>> getDueSRSCards() {
    final now = DateTime.now();
    return _isar.sRSCards
        .filter()
        .nextReviewDateLessThan(now)
        .or()
        .nextReviewDateIsNull()
        .findAll();
  }

  Future<void> saveSRSCard(SRSCard card) async {
    await _isar.writeTxn(() => _isar.sRSCards.put(card));
  }

  // ---- Journeys ----
  Future<List<ThematicJourney>> getAllJourneys() =>
      _isar.thematicJourneys.where().findAll();

  Future<ThematicJourney?> getActiveJourney() =>
      _isar.thematicJourneys.filter().isActiveEqualTo(true).findFirst();

  Future<void> saveJourney(ThematicJourney journey) async {
    await _isar.writeTxn(() => _isar.thematicJourneys.put(journey));
  }

  // ---- Daily Progress ----
  Future<DailyProgress> getTodayProgress() async {
    final today = _dateOnly(DateTime.now());
    var progress = await _isar.dailyProgresss
        .filter()
        .dateEqualTo(today)
        .findFirst();
    if (progress == null) {
      progress = DailyProgress()..date = today;
      await _isar.writeTxn(() => _isar.dailyProgresss.put(progress!));
    }
    return progress;
  }

  Future<List<DailyProgress>> getWeekProgress() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _isar.dailyProgresss
        .filter()
        .dateGreaterThan(weekAgo)
        .sortByDate()
        .findAll();
  }

  Future<void> saveDailyProgress(DailyProgress progress) async {
    await _isar.writeTxn(() => _isar.dailyProgresss.put(progress));
  }

  DateTime _dateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);
}
