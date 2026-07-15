#!/usr/bin/env bash
set -euo pipefail

flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter build apk --release
flutter build appbundle --release
flutter build web --release
