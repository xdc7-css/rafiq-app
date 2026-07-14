# Rafiq

A premium Islamic companion app built with Flutter, designed for Quran reading, prayer times, qibla guidance, hadith, adhkar, and daily reminders.

## Highlights
- Flutter mobile app with Android, web, and desktop support
- Offline-first content and local storage
- Rich Quran and prayer time experience
- Firebase Hosting deployment for web
- Shorebird-ready release flow for Android

## Quick start
```bash
git clone https://github.com/xdc7-css/rafiq-app.git
cd rafiq-app
flutter pub get
flutter run
```

## Core commands
```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
flutter build appbundle
flutter build web
shorebird release android
```

## Deployment
This repository is configured for automated CI/CD:
- pushes to `main` trigger analysis, tests, Android builds, and a web build
- tags like `v1.2.3` trigger a GitHub Release and attach APK/AAB artifacts
- the web app is deployed to Firebase Hosting automatically

### Required GitHub secrets
- `FIREBASE_SERVICE_ACCOUNT`
- `FIREBASE_PROJECT_ID`
- `SHOREBIRD_TOKEN`

## Project docs
- [docs/PROJECT_MAP.md](docs/PROJECT_MAP.md)
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)
- [docs/RELEASE_PROCESS.md](docs/RELEASE_PROCESS.md)

## Repository automation
- CI: GitHub Actions on every push and pull request
- Web deploy: Firebase Hosting on pushes to main
- Release artifacts: APK and App Bundle attached to GitHub Releases
- Manual Shorebird release workflow available in GitHub Actions

## License
This project is licensed under the MIT License.

