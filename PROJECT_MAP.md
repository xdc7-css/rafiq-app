# Project Map

## Runtime targets
- Android
- Web
- Firebase Hosting
- Shorebird

## Release automation
- CI workflow: .github/workflows/ci.yml
- Release workflow: .github/workflows/release.yml
- Hosting config: firebase.json
- Shorebird config: shorebird.yaml

## Deployment notes
- Web deploys to Firebase Hosting after pushes to main.
- GitHub Releases publish the Android APK and AAB.
- The web app reads release metadata from the GitHub Releases API.
