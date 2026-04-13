import 'package:isar/isar.dart';

part 'ayah_model.g.dart';

@collection
class AyahModel {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('ayahNumber')])
  late int surahNumber;

  late int ayahNumber;
  late String arabicText;
  late String translation;
  late String transliteration;

  @Index()
  bool isBookmarked = false;

  bool isRead = false;
  DateTime? lastReadAt;
  String? audioUrl;
}

@collection
class SurahModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int number;

  late String nameArabic;
  late String nameEnglish;
  late String nameTransliteration;
  late String revelationType; // Meccan / Medinan
  late int ayahCount;
  String? description;
  double readProgress = 0.0;
}

// Plain data class for API responses (not persisted)
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

  factory AyahData.fromJson(Map<String, dynamic> json, {String? translationText}) {
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
