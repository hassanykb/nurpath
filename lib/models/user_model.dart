import 'package:isar/isar.dart';

part 'user_model.g.dart';

@collection
class UserProfile {
  Id id = 1; // singleton

  String name = 'Hassan';
  String? lastName;
  String language = 'en';
  bool onboardingComplete = false;
  DateTime? joinedAt;

  // Goals
  int dailyAyahGoal = 5;
  bool nightlyReflectionGoal = true;
  bool deepStudyGoal = false;

  // Streak
  int currentStreak = 0;
  int longestStreak = 0;
  DateTime? lastActiveDate;

  // Faith Score
  int faithScore = 0;
  double quranEngagement = 0.0;
  double heartReflection = 0.0;
  double salahAlignment = 0.0;
  double actsOfKindness = 0.0;

  // Settings
  bool offlineMode = false;
  bool bismillahOption = true;
  bool guiltFreeReminders = true;
  String reciterName = 'Mishary Rashid Alafasy';
  double playbackSpeed = 1.0;
  bool wordByWordEnabled = false;
}

@collection
class JournalEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime createdAt;

  late String prompt;
  late String content;
  String? linkedDeed; // Charity, Prayer, Kindness, etc.
  String? surahRef; // e.g. "Al-Baqarah 2:152"
  String? arabicAyah;
  bool isSaved = false;
  List<String> tags = [];
}

@collection
class SRSCard {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('ayahNumber')])
  late int surahNumber;
  late int ayahNumber;

  late String arabicText;
  late String translation;

  // SRS fields
  int repetitions = 0;
  double easeFactor = 2.5;
  int interval = 1; // days
  DateTime? nextReviewDate;
  DateTime? lastReviewDate;
  bool isMastered = false;
  double retentionStrength = 0.0;
}

@collection
class ThematicJourney {
  Id id = Isar.autoIncrement;

  late String title;
  late String subtitle;
  late String surahReference;
  late int totalDays;
  int completedDays = 0;
  bool isActive = false;
  DateTime? startedAt;
  String? imageAsset;

  double get progress =>
      totalDays > 0 ? completedDays / totalDays : 0.0;
}

@collection
class DailyProgress {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date;

  int ayahsRead = 0;
  bool reflectionDone = false;
  bool salahDone = false;
  int deedsCount = 0;
  int tasbihCount = 0;
  int faithScore = 0;
}
