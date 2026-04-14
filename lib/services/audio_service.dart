import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

class NurPathAudioService {
  static final NurPathAudioService _instance = NurPathAudioService._internal();
  factory NurPathAudioService() => _instance;
  NurPathAudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  static const Map<String, String> reciters = {
    'Mishary Rashid Alafasy': 'Alafasy_128kbps',
    'Abdul Rahman Al-Sudais': 'Abdurrahmaan_As-Sudais_192kbps',
    'Mahmoud Khalil Al-Husary': 'Husary_128kbps',
    'Abu Bakr Al-Shatri': 'Abu_Bakr_Ash-Shaatree_128kbps',
  };

  String _currentReciter = 'Alafasy_128kbps';
  String _currentReciterName = 'Mishary Rashid Alafasy';

  AudioPlayer get player => _player;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  bool get isPlaying => _player.playing;

  void setReciter(String reciterName) {
    _currentReciterName = reciterName;
    _currentReciter = reciters[reciterName] ?? 'Alafasy_128kbps';
  }

  String _buildAudioUrl(int surahNumber, int ayahNumber) {
    // CDN format: https://everyayah.com/data/{reciter}/{surah}{ayah}.mp3
    final paddedSurah = surahNumber.toString().padLeft(3, '0');
    final paddedAyah = ayahNumber.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/$_currentReciter/$paddedSurah$paddedAyah.mp3';
  }

  Future<void> playAyah(int surahNumber, int ayahNumber) async {
    try {
      final url = _buildAudioUrl(surahNumber, ayahNumber);
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      debugPrint('[Audio] Error playing ayah: $e');
    }
  }

  Future<void> playSurah(int surahNumber, {int startAyah = 1}) async {
    try {
      // Build playlist for all ayahs
      // In a real app we'd know the count from DB
      final playlist = AudioSource.uri(
        Uri.parse(_buildAudioUrl(surahNumber, startAyah)),
      );
      await _player.setAudioSource(playlist);
      await _player.play();
    } catch (e) {
      debugPrint('[Audio] Error playing surah: $e');
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  void dispose() {
    _player.dispose();
  }

  double get currentProgress {
    final pos = _player.position.inMilliseconds;
    final dur = _player.duration?.inMilliseconds ?? 1;
    return dur > 0 ? pos / dur : 0.0;
  }

  String formatDuration(Duration? d) {
    if (d == null) return '0:00';
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
