// Plain Dart models — no Isar dependency, fully web-compatible.

class AyahModel {
  final String id; // "$surahNumber:$ayahNumber"
  final int surahNumber;
  final int ayahNumber;
  final String arabicText;
  final String translation;
  final String transliteration;
  bool isBookmarked;
  bool isRead;
  DateTime? lastReadAt;
  String? audioUrl;

  AyahModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabicText,
    required this.translation,
    this.transliteration = '',
    this.isBookmarked = false,
    this.isRead = false,
    this.lastReadAt,
    this.audioUrl,
  }) : id = '$surahNumber:$ayahNumber';

  Map<String, dynamic> toMap() => {
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'arabicText': arabicText,
        'translation': translation,
        'transliteration': transliteration,
        'isBookmarked': isBookmarked,
        'isRead': isRead,
        'lastReadAt': lastReadAt?.toIso8601String(),
        'audioUrl': audioUrl,
      };

  factory AyahModel.fromMap(Map<dynamic, dynamic> m) => AyahModel(
        surahNumber: m['surahNumber'] as int,
        ayahNumber: m['ayahNumber'] as int,
        arabicText: m['arabicText'] as String,
        translation: m['translation'] as String,
        transliteration: (m['transliteration'] as String?) ?? '',
        isBookmarked: (m['isBookmarked'] as bool?) ?? false,
        isRead: (m['isRead'] as bool?) ?? false,
        lastReadAt: m['lastReadAt'] != null
            ? DateTime.tryParse(m['lastReadAt'] as String)
            : null,
        audioUrl: m['audioUrl'] as String?,
      );
}

class SurahModel {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTransliteration;
  final String revelationType;
  final int ayahCount;
  double readProgress;

  SurahModel({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTransliteration,
    required this.revelationType,
    required this.ayahCount,
    this.readProgress = 0.0,
  });
}

// ── API DTOs ──────────────────────────────────────────────────────────────────

class AyahData {
  final int surahNumber;
  final int ayahNumber;
  final String arabicText;
  final String translation;

  const AyahData({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabicText,
    required this.translation,
  });

  factory AyahData.fromJson(Map<String, dynamic> json,
      {String? translationText}) {
    return AyahData(
      surahNumber: json['surah']?['number'] ?? 0,
      ayahNumber: json['numberInSurah'] ?? 0,
      arabicText: json['text'] ?? '',
      translation: translationText ?? '',
    );
  }
}

class SurahData {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTransliteration;
  final String revelationType;
  final int ayahCount;
  final List<AyahData> ayahs;

  const SurahData({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTransliteration,
    required this.revelationType,
    required this.ayahCount,
    this.ayahs = const [],
  });

  factory SurahData.fromJson(Map<String, dynamic> json) {
    return SurahData(
      number: json['number'] ?? 0,
      nameArabic: json['name'] ?? '',
      nameEnglish: json['englishName'] ?? '',
      nameTransliteration: json['englishNameTranslation'] ?? '',
      revelationType: json['revelationType'] ?? '',
      ayahCount: json['numberOfAyahs'] ?? 0,
    );
  }
}
