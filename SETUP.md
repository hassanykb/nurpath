# NurPath — First-Run Setup Guide

Follow these steps to get the app running:

## 1. Install Flutter SDK (if not already installed)
```bash
brew install flutter     # macOS with Homebrew
flutter doctor           # verify environment
```

## 2. Install dependencies
```bash
cd "Vibe projects/nurpath"
flutter pub get
```

## 3. Add Required Fonts
Download and place in `assets/fonts/`:
- **Amiri-Regular.ttf** — https://fonts.google.com/specimen/Amiri (download zip)
- **Amiri-Bold.ttf** — same package above
- **AmiriQuran-Regular.ttf** — https://github.com/alif-type/amiri/releases (download AmiriQuran-Regular.ttf)

## 4. Create Asset Directories
```bash
mkdir -p assets/fonts assets/images assets/icons assets/animations assets/audio
# Add placeholder files to avoid pubspec asset errors:
touch assets/images/.gitkeep
touch assets/icons/.gitkeep
touch assets/animations/.gitkeep
touch assets/audio/.gitkeep
```

## 5. Regenerate Isar + Riverpod Code
```bash
dart run build_runner build --delete-conflicting-outputs
```
> ⚠️ The `.g.dart` stub files included are for IDE reference only.
> Always regenerate with build_runner before building.

## 6. Run the App
```bash
flutter run                # picks a connected device/simulator
flutter run -d ios         # iOS Simulator
flutter run -d android     # Android Emulator
```

## 7. Internet Permissions
The app fetches Quran data from alquran.cloud. Ensure permissions:
- **Android**: `android/app/src/main/AndroidManifest.xml` — Internet permission is already declared
- **iOS**: No additional config needed for HTTPS

## Common Issues

### "Cannot find fonts"
→ Run step 3 and 4. Font files must exist at the declared paths.

### "IsarError: Schema mismatch"
→ Delete the app and reinstall: `flutter run --no-restore`

### "build_runner conflicts"
→ `dart run build_runner build --delete-conflicting-outputs`

### Blank screen on launch
→ Check that `assets/fonts/AmiriQuran-Regular.ttf` exists.
   App will crash at boot if declared font files are missing.

## Notes
- The app defaults to **dark mode** (offline-first, no ads)
- Onboarding runs once; after completion it routes to `/home`
- Faith Score seeded with Hassan's profile (82/100)
- All thematic journeys are seeded in Isar on first launch
