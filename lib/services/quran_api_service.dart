import 'package:dio/dio.dart';
import '../models/ayah_model.dart';

class QuranApiService {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  static const String _arabicEdition = 'quran-uthmani';
  static const String _englishEdition = 'en.sahih';

  late final Dio _dio;

  QuranApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );
    _dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      logPrint: (obj) => debugLog(obj.toString()),
    ));
  }

  void debugLog(String msg) {
    // ignore in production
    assert(() {
      // ignore: avoid_print
      print('[QuranAPI] $msg');
      return true;
    }());
  }

  // Fetch all surahs list
  Future<List<SurahData>> fetchSurahList() async {
    try {
      final response = await _dio.get('/surah');
      final data = response.data as Map<String, dynamic>;
      final list = data['data'] as List;
      return list
          .map((e) => SurahData.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw QuranApiException('Failed to fetch surah list: $e');
    }
  }

  // Fetch a specific surah with Arabic + English
  Future<SurahWithTranslation> fetchSurah(int surahNumber) async {
    try {
      final responses = await Future.wait([
        _dio.get('/surah/$surahNumber/$_arabicEdition'),
        _dio.get('/surah/$surahNumber/$_englishEdition'),
      ]);

      final arabicData = responses[0].data as Map<String, dynamic>;
      final englishData = responses[1].data as Map<String, dynamic>;

      final arabicSurah = arabicData['data'] as Map<String, dynamic>;
      final englishSurah = englishData['data'] as Map<String, dynamic>;

      final arabicAyahs = (arabicSurah['ayahs'] as List)
          .cast<Map<String, dynamic>>();
      final englishAyahs = (englishSurah['ayahs'] as List)
          .cast<Map<String, dynamic>>();

      final ayahs = List.generate(arabicAyahs.length, (i) {
        return AyahData(
          surahNumber: surahNumber,
          ayahNumber: arabicAyahs[i]['numberInSurah'] as int,
          arabicText: arabicAyahs[i]['text'] as String,
          translation: englishAyahs[i]['text'] as String,
        );
      });

      return SurahWithTranslation(
        surahData: SurahData.fromJson(arabicSurah),
        ayahs: ayahs,
      );
    } catch (e) {
      throw QuranApiException('Failed to fetch surah $surahNumber: $e');
    }
  }

  // Fetch a random ayah for the daily verse
  Future<AyahData> fetchRandomAyah() async {
    try {
      // Random surah 1-114, random ayah
      final surahNum = DateTime.now().millisecondsSinceEpoch % 114 + 1;
      final response = await _dio.get('/surah/$surahNum/$_arabicEdition');
      final englishResponse = await _dio.get('/surah/$surahNum/$_englishEdition');

      final arabicAyahs = (response.data['data']['ayahs'] as List)
          .cast<Map<String, dynamic>>();
      final englishAyahs = (englishResponse.data['data']['ayahs'] as List)
          .cast<Map<String, dynamic>>();

      final idx = DateTime.now().day % arabicAyahs.length;
      return AyahData(
        surahNumber: surahNum,
        ayahNumber: arabicAyahs[idx]['numberInSurah'] as int,
        arabicText: arabicAyahs[idx]['text'] as String,
        translation: englishAyahs[idx]['text'] as String,
      );
    } catch (e) {
      // Return a well-known fallback
      return const AyahData(
        surahNumber: 2,
        ayahNumber: 152,
        arabicText: 'فَٱذْكُرُونِىٓ أَذْكُرْكُمْ وَٱشْكُرُوا۟ لِى وَلَا تَكْفُرُونِ',
        translation:
            'So remember Me; I will remember you. And be grateful to Me and do not deny Me.',
      );
    }
  }

  // Fetch prayer times
  Future<Map<String, String>> fetchPrayerTimes({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final today = DateTime.now();
      final dateStr =
          '${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}';

      final response = await Dio().get(
        'https://api.aladhan.com/v1/timings/$dateStr',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'method': 2,
        },
      );

      final timings = response.data['data']['timings'] as Map<String, dynamic>;
      return timings.map((k, v) => MapEntry(k, v.toString()));
    } catch (e) {
      return {
        'Fajr': '05:30',
        'Dhuhr': '12:30',
        'Asr': '15:45',
        'Maghrib': '18:20',
        'Isha': '20:00',
      };
    }
  }

  // Simulate AI reflection endpoint
  Future<ReflectionPrompt> generateReflectionPrompt({
    required String arabicAyah,
    required String translation,
    required String surahRef,
  }) async {
    // Simulated response with authentic Islamic reflection template
    await Future.delayed(const Duration(milliseconds: 600));
    return ReflectionPrompt(
      question:
          'How can you apply "${translation.length > 60 ? translation.substring(0, 60) + '...' : translation}" in your work today? Write your intention.',
      tafseeerCitation: 'Ibn Kathir on $surahRef',
      linkedDeeds: ['Charity', 'Prayer', 'Kindness', 'Gratitude'],
    );
  }
}

class SurahWithTranslation {
  final SurahData surahData;
  final List<AyahData> ayahs;

  const SurahWithTranslation({
    required this.surahData,
    required this.ayahs,
  });
}

class ReflectionPrompt {
  final String question;
  final String tafseeerCitation;
  final List<String> linkedDeeds;

  const ReflectionPrompt({
    required this.question,
    required this.tafseeerCitation,
    required this.linkedDeeds,
  });
}

class QuranApiException implements Exception {
  final String message;
  const QuranApiException(this.message);

  @override
  String toString() => 'QuranApiException: $message';
}
