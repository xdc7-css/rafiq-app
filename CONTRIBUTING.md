<div align="center">

# Contributing to رَفيِقْ

**Thank you for your interest in contributing!**

</div>

---

## 📋 Before You Start

1. Read the [Code of Conduct](CODE_OF_CONDUCT.md)
2. Check existing [issues](https://github.com/Daily-Islamic-Widget/rafeeq/issues) and [pull requests](https://github.com/Daily-Islamic-Widget/rafeeq/pulls)
3. For large changes, open an issue first to discuss your approach

## 🚀 Quick Start

```bash
# 1. Fork the repository
# 2. Clone your fork
git clone https://github.com/your-username/rafeeq.git
cd rafeeq

# 3. Install dependencies
flutter pub get

# 4. Create a feature branch
git checkout -b feature/amazing-feature

# 5. Make your changes
# 6. Run tests
flutter test

# 7. Run analyzer
flutter analyze

# 8. Commit and push
git commit -m "feat: add amazing feature"
git push origin feature/amazing-feature

# 9. Open a Pull Request
```

## 🔀 Branch Strategy

| Branch | Purpose |
|--------|---------|
| `master` | Production-ready code |
| `develop` | Integration branch |
| `feature/*` | New features |
| `fix/*` | Bug fixes |
| `hotfix/*` | Critical production fixes |

## 📝 Commit Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

| Prefix | Description |
|--------|-------------|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `docs:` | Documentation |
| `style:` | Code style (formatting, etc.) |
| `refactor:` | Code refactoring |
| `perf:` | Performance improvement |
| `test:` | Adding/updating tests |
| `chore:` | Build process or tooling |
| `ci:` | CI/CD changes |
| `rtl:` | RTL/Arabic text changes |

### Examples

```
feat: add Quran bookmark sync
fix: correct prayer time calculation for high latitudes
docs: update installation instructions
perf: optimize SVG rendering performance
rtl: improve Arabic text line breaking
```

## 🏗️ Architecture

We use **Feature-First Clean Architecture**:

```
lib/features/<feature>/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repository/
├── domain/
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

## 🎨 Code Style

- Follow [Effective Dart](https://dart.dev/effective-dart) guidelines
- Use `flutter format .` before committing
- All code must pass `flutter analyze` with no issues
- RTL text handling must be tested with Arabic content
- Widget tests required for new UI components

## 🌍 Localization

When adding new user-facing strings:
1. Add to `lib/core/arabic_strings.dart` for Arabic
2. Add English equivalent in the English locale
3. Test with both `ar` and `en` locales
4. Verify RTL layout works correctly

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/widget_test.dart
```

## 📱 Platform-Specific Guidelines

### Android
- Min SDK: 21
- Target SDK: 36
- Test home screen widgets on real devices
- Verify notification behavior with Do Not Disturb

### iOS
- Test on both iPhone and iPad
- Verify Dynamic Type support
- Test with VoiceOver enabled

### Web
- Test responsive layouts
- Verify CanvasKit renderer performance
- Test keyboard navigation

## 🤝 Pull Request Process

1. **Update documentation** if you changed APIs or added features
2. **Add tests** for new functionality
3. **Ensure CI passes** - all checks must be green
4. **Request review** from maintainers
5. **Respond to feedback** promptly and courteously
6. **Squash commits** if requested before merge

## ❓ Questions?

Open a [Discussion](https://github.com/Daily-Islamic-Widget/rafeeq/discussions) for general questions.

---

<div align="center">

**جزاكم الله خيراً**

*May Allah reward you for your contributions*

</div>
