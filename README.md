# NurPath — Quran Companion App

A production-ready, cross-platform Flutter app for Quran learning, reflection, and spiritual growth.

## Features
- **Learn Mode** — Arabic + Translation side-by-side, word-by-word, audio recitation
- **Reflect & Grow** — AI-assisted reflection with authentic Tafseer, private journal, deed linking
- **Faith Score** — Quran Engagement, Heart Reflection, Salah Alignment, Acts of Kindness rings
- **Thematic Journeys** — Curated multi-day spiritual journeys (Healing the Heart, Building Patience, etc.)
- **Memorize Mode** — SRS flashcard system, tajweed recording, retention meter
- **Profile/Me** — Goals, streak calendar, family sharing, settings

## Tech Stack
- Flutter 3.24+
- Riverpod 2.5 (state management)
- Isar (local DB — offline-first)
- just_audio + audio_service (recitation)
- fl_chart (Faith Score sparklines)
- percent_indicator (faith rings)
- go_router (navigation)
- flutter_animate (animations)

## APIs
- **Quran data**: https://api.alquran.cloud/v1 (Arabic: quran-uthmani, English: en.sahih)
- **Prayer times**: https://api.aladhan.com (auto-pause audio)

## Getting Started

```bash
# Install dependencies
flutter pub get

# Generate Isar + Riverpod code
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

## Fonts
Place these font files in `assets/fonts/`:
- `Amiri-Regular.ttf` — https://fonts.google.com/specimen/Amiri
- `Amiri-Bold.ttf`
- `AmiriQuran-Regular.ttf` — https://github.com/alif-type/amiri

## Project Structure
```
lib/
├── main.dart
├── theme/
│   ├── app_colors.dart       # Emerald + Gold palette
│   ├── app_typography.dart   # Inter + Amiri fonts
│   └── app_theme.dart        # Dark theme (MaterialApp)
├── models/                   # Isar collections + DTOs
├── services/                 # QuranAPI, Audio, DB
├── providers/                # Riverpod providers
├── navigation/               # GoRouter
├── screens/
│   ├── onboarding/
│   ├── home/
│   ├── learn/
│   ├── reflect/
│   ├── faith_score/
│   ├── journeys/
│   ├── profile/
│   ├── memorize/
│   └── quran/
└── widgets/                  # Shared widgets
```
