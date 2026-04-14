// Plain Dart models — no Isar dependency, fully web-compatible.

class UserProfile {
  String name;
  String? lastName;
  String language;
  bool onboardingComplete;
  DateTime? joinedAt;

  // Goals
  int dailyAyahGoal;
  bool nightlyReflectionGoal;
  bool deepStudyGoal;

  // Streak
  int currentStreak;
  int longestStreak;
  DateTime? lastActiveDate;

  // Faith Score
  int faithScore;
  double quranEngagement;
  double heartReflection;
  double salahAlignment;
  double actsOfKindness;

  // Settings
  bool offlineMode;
  bool bismillahOption;
  bool guiltFreeReminders;
  String reciterName;
  double playbackSpeed;
  bool wordByWordEnabled;

  UserProfile({
    this.name = 'Hassan',
    this.lastName,
    this.language = 'en',
    this.onboardingComplete = false,
    this.joinedAt,
    this.dailyAyahGoal = 5,
    this.nightlyReflectionGoal = true,
    this.deepStudyGoal = false,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActiveDate,
    this.faithScore = 0,
    this.quranEngagement = 0.0,
    this.heartReflection = 0.0,
    this.salahAlignment = 0.0,
    this.actsOfKindness = 0.0,
    this.offlineMode = false,
    this.bismillahOption = true,
    this.guiltFreeReminders = true,
    this.reciterName = 'Mishary Rashid Alafasy',
    this.playbackSpeed = 1.0,
    this.wordByWordEnabled = false,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'lastName': lastName,
        'language': language,
        'onboardingComplete': onboardingComplete,
        'joinedAt': joinedAt?.toIso8601String(),
        'dailyAyahGoal': dailyAyahGoal,
        'nightlyReflectionGoal': nightlyReflectionGoal,
        'deepStudyGoal': deepStudyGoal,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastActiveDate': lastActiveDate?.toIso8601String(),
        'faithScore': faithScore,
        'quranEngagement': quranEngagement,
        'heartReflection': heartReflection,
        'salahAlignment': salahAlignment,
        'actsOfKindness': actsOfKindness,
        'offlineMode': offlineMode,
        'bismillahOption': bismillahOption,
        'guiltFreeReminders': guiltFreeReminders,
        'reciterName': reciterName,
        'playbackSpeed': playbackSpeed,
        'wordByWordEnabled': wordByWordEnabled,
      };

  factory UserProfile.fromMap(Map<dynamic, dynamic> m) => UserProfile(
        name: (m['name'] as String?) ?? 'Hassan',
        lastName: m['lastName'] as String?,
        language: (m['language'] as String?) ?? 'en',
        onboardingComplete: (m['onboardingComplete'] as bool?) ?? false,
        joinedAt: m['joinedAt'] != null
            ? DateTime.tryParse(m['joinedAt'] as String)
            : null,
        dailyAyahGoal: (m['dailyAyahGoal'] as int?) ?? 5,
        nightlyReflectionGoal: (m['nightlyReflectionGoal'] as bool?) ?? true,
        deepStudyGoal: (m['deepStudyGoal'] as bool?) ?? false,
        currentStreak: (m['currentStreak'] as int?) ?? 0,
        longestStreak: (m['longestStreak'] as int?) ?? 0,
        lastActiveDate: m['lastActiveDate'] != null
            ? DateTime.tryParse(m['lastActiveDate'] as String)
            : null,
        faithScore: (m['faithScore'] as int?) ?? 0,
        quranEngagement: ((m['quranEngagement'] as num?) ?? 0.0).toDouble(),
        heartReflection: ((m['heartReflection'] as num?) ?? 0.0).toDouble(),
        salahAlignment: ((m['salahAlignment'] as num?) ?? 0.0).toDouble(),
        actsOfKindness: ((m['actsOfKindness'] as num?) ?? 0.0).toDouble(),
        offlineMode: (m['offlineMode'] as bool?) ?? false,
        bismillahOption: (m['bismillahOption'] as bool?) ?? true,
        guiltFreeReminders: (m['guiltFreeReminders'] as bool?) ?? true,
        reciterName:
            (m['reciterName'] as String?) ?? 'Mishary Rashid Alafasy',
        playbackSpeed: ((m['playbackSpeed'] as num?) ?? 1.0).toDouble(),
        wordByWordEnabled: (m['wordByWordEnabled'] as bool?) ?? false,
      );

  UserProfile copyWith({
    String? name,
    int? faithScore,
    double? quranEngagement,
    double? heartReflection,
    double? salahAlignment,
    double? actsOfKindness,
    int? currentStreak,
    bool? offlineMode,
    bool? onboardingComplete,
    int? dailyAyahGoal,
    String? language,
  }) =>
      UserProfile(
        name: name ?? this.name,
        lastName: lastName,
        language: language ?? this.language,
        onboardingComplete: onboardingComplete ?? this.onboardingComplete,
        joinedAt: joinedAt,
        dailyAyahGoal: dailyAyahGoal ?? this.dailyAyahGoal,
        nightlyReflectionGoal: nightlyReflectionGoal,
        deepStudyGoal: deepStudyGoal,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak,
        faithScore: faithScore ?? this.faithScore,
        quranEngagement: quranEngagement ?? this.quranEngagement,
        heartReflection: heartReflection ?? this.heartReflection,
        salahAlignment: salahAlignment ?? this.salahAlignment,
        actsOfKindness: actsOfKindness ?? this.actsOfKindness,
        offlineMode: offlineMode ?? this.offlineMode,
        bismillahOption: bismillahOption,
        guiltFreeReminders: guiltFreeReminders,
        reciterName: reciterName,
        playbackSpeed: playbackSpeed,
        wordByWordEnabled: wordByWordEnabled,
      );
}

class JournalEntry {
  final String id;
  final DateTime createdAt;
  final String prompt;
  final String content;
  final String? linkedDeed;
  final String? surahRef;
  final String? arabicAyah;
  final bool isSaved;
  final List<String> tags;

  JournalEntry({
    String? id,
    required this.createdAt,
    required this.prompt,
    required this.content,
    this.linkedDeed,
    this.surahRef,
    this.arabicAyah,
    this.isSaved = false,
    this.tags = const [],
  }) : id = id ?? '${createdAt.millisecondsSinceEpoch}';

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'prompt': prompt,
        'content': content,
        'linkedDeed': linkedDeed,
        'surahRef': surahRef,
        'arabicAyah': arabicAyah,
        'isSaved': isSaved,
        'tags': tags,
      };

  factory JournalEntry.fromMap(Map<dynamic, dynamic> m) => JournalEntry(
        id: m['id'] as String?,
        createdAt: DateTime.parse(m['createdAt'] as String),
        prompt: (m['prompt'] as String?) ?? '',
        content: (m['content'] as String?) ?? '',
        linkedDeed: m['linkedDeed'] as String?,
        surahRef: m['surahRef'] as String?,
        arabicAyah: m['arabicAyah'] as String?,
        isSaved: (m['isSaved'] as bool?) ?? false,
        tags: (m['tags'] as List?)?.cast<String>() ?? [],
      );
}

class SRSCard {
  final String id; // "$surahNumber:$ayahNumber"
  final int surahNumber;
  final int ayahNumber;
  final String arabicText;
  final String translation;
  int repetitions;
  double easeFactor;
  int interval;
  DateTime? nextReviewDate;
  DateTime? lastReviewDate;
  bool isMastered;
  double retentionStrength;

  SRSCard({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabicText,
    required this.translation,
    this.repetitions = 0,
    this.easeFactor = 2.5,
    this.interval = 1,
    this.nextReviewDate,
    this.lastReviewDate,
    this.isMastered = false,
    this.retentionStrength = 0.0,
  }) : id = '$surahNumber:$ayahNumber';

  Map<String, dynamic> toMap() => {
        'id': id,
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'arabicText': arabicText,
        'translation': translation,
        'repetitions': repetitions,
        'easeFactor': easeFactor,
        'interval': interval,
        'nextReviewDate': nextReviewDate?.toIso8601String(),
        'lastReviewDate': lastReviewDate?.toIso8601String(),
        'isMastered': isMastered,
        'retentionStrength': retentionStrength,
      };

  factory SRSCard.fromMap(Map<dynamic, dynamic> m) => SRSCard(
        surahNumber: m['surahNumber'] as int,
        ayahNumber: m['ayahNumber'] as int,
        arabicText: (m['arabicText'] as String?) ?? '',
        translation: (m['translation'] as String?) ?? '',
        repetitions: (m['repetitions'] as int?) ?? 0,
        easeFactor: ((m['easeFactor'] as num?) ?? 2.5).toDouble(),
        interval: (m['interval'] as int?) ?? 1,
        nextReviewDate: m['nextReviewDate'] != null
            ? DateTime.tryParse(m['nextReviewDate'] as String)
            : null,
        lastReviewDate: m['lastReviewDate'] != null
            ? DateTime.tryParse(m['lastReviewDate'] as String)
            : null,
        isMastered: (m['isMastered'] as bool?) ?? false,
        retentionStrength:
            ((m['retentionStrength'] as num?) ?? 0.0).toDouble(),
      );
}

class ThematicJourney {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String surahReference;
  final int totalDays;
  final List<String> dailyLessons;
  int completedDays;
  bool isActive;
  DateTime? startedAt;
  String? imageAsset;

  ThematicJourney({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.surahReference,
    required this.totalDays,
    this.description = '',
    this.dailyLessons = const [],
    this.completedDays = 0,
    this.isActive = false,
    this.startedAt,
    this.imageAsset,
  });

  double get progress => totalDays > 0 ? completedDays / totalDays : 0.0;

  /// The lesson for today (current day), or the last one if complete.
  String get todayLesson {
    final idx = (completedDays).clamp(0, dailyLessons.length - 1);
    return dailyLessons.isNotEmpty ? dailyLessons[idx] : '';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'surahReference': surahReference,
        'totalDays': totalDays,
        'dailyLessons': dailyLessons,
        'completedDays': completedDays,
        'isActive': isActive,
        'startedAt': startedAt?.toIso8601String(),
        'imageAsset': imageAsset,
      };

  factory ThematicJourney.fromMap(Map<dynamic, dynamic> m) => ThematicJourney(
        id: (m['id'] as String?) ?? '',
        title: (m['title'] as String?) ?? '',
        subtitle: (m['subtitle'] as String?) ?? '',
        description: (m['description'] as String?) ?? '',
        surahReference: (m['surahReference'] as String?) ?? '',
        totalDays: (m['totalDays'] as int?) ?? 0,
        dailyLessons: (m['dailyLessons'] as List?)?.map((e) => e.toString()).toList() ?? [],
        completedDays: (m['completedDays'] as int?) ?? 0,
        isActive: (m['isActive'] as bool?) ?? false,
        startedAt: m['startedAt'] != null
            ? DateTime.tryParse(m['startedAt'] as String)
            : null,
        imageAsset: m['imageAsset'] as String?,
      );
}

class DailyProgress {
  final String id; // date string "yyyy-MM-dd"
  final DateTime date;
  int ayahsRead;
  bool reflectionDone;
  bool salahDone;
  int deedsCount;
  int tasbihCount;
  int faithScore;

  DailyProgress({
    required this.date,
    this.ayahsRead = 0,
    this.reflectionDone = false,
    this.salahDone = false,
    this.deedsCount = 0,
    this.tasbihCount = 0,
    this.faithScore = 0,
  }) : id =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'ayahsRead': ayahsRead,
        'reflectionDone': reflectionDone,
        'salahDone': salahDone,
        'deedsCount': deedsCount,
        'tasbihCount': tasbihCount,
        'faithScore': faithScore,
      };

  factory DailyProgress.fromMap(Map<dynamic, dynamic> m) => DailyProgress(
        date: DateTime.parse(m['date'] as String),
        ayahsRead: (m['ayahsRead'] as int?) ?? 0,
        reflectionDone: (m['reflectionDone'] as bool?) ?? false,
        salahDone: (m['salahDone'] as bool?) ?? false,
        deedsCount: (m['deedsCount'] as int?) ?? 0,
        tasbihCount: (m['tasbihCount'] as int?) ?? 0,
        faithScore: (m['faithScore'] as int?) ?? 0,
      );
}
