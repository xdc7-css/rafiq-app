# Deployment Guide

## Required GitHub secrets
- `FIREBASE_SERVICE_ACCOUNT`
- `FIREBASE_PROJECT_ID`
- `SHOREBIRD_TOKEN`

## Release flow
1. Merge changes into `main`.
2. GitHub Actions runs analysis, tests, Android builds, and a web build.
3. A GitHub Release is created for tagged versions.
4. Firebase Hosting deploys the web build automatically.
5. The website fetches the latest release metadata from GitHub Releases.
