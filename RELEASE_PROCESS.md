# Release Process

## Standard release
1. Update version metadata in pubspec.yaml.
2. Commit and push to main.
3. Create a Git tag matching `vX.Y.Z`.
4. Push the tag.
5. GitHub Actions creates a GitHub Release with APK/AAB assets and deploys the web build.

## Manual fallback
- Run `flutter pub get`
- Run `flutter analyze`
- Run `flutter test`
- Run `flutter build apk --release`
- Run `flutter build appbundle --release`
- Run `flutter build web --release`
