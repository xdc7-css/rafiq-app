# Security Policy — Rafeeq (رَفِيقْ)

This document details security practices, vulnerability reporting procedures, secret management policies, and runtime permission models for the Rafeeq open-source repository.

---

## 1. Supported Versions

Security patches and active maintenance are provided for the following releases:

| Version | Status | Notes |
| :--- | :--- | :--- |
| `3.x` | Supported | Current active development branch |
| `2.x` | Maintenance only | Critical security patches only |
| `< 2.0` | Unsupported | End-of-life |

---

## 2. Reporting a Vulnerability

We take the security of Rafeeq and our users' spiritual and personal data seriously.

If you discover a potential security vulnerability (e.g., secret leak, authentication flaw, insecure network endpoint, or permission escalation):

1. **Do NOT open a public GitHub issue.**
2. Send a private report via **GitHub Security Advisories** (recommended) or email the lead maintainers directly.
3. Include in your report:
   - Type of vulnerability (e.g., data leak, rule bypass, memory corruption)
   - Step-by-step reproduction instructions or proof of concept
   - Impact assessment
   - Suggested remediation if known

### Response Timeline
- **Initial Acknowledgement**: Within 48 hours.
- **Triage & Severity Assessment**: Within 5 business days.
- **Fix & Disclosure**: Coordinated release within 30 days of validation.

---

## 3. Secrets Management & Environment Configuration

### Rule: Zero Secrets in Version Control
The following items **MUST NEVER** be committed to Git:
- Production keystores (`*.jks`, `*.keystore`)
- Private keys and certificates (`*.p12`, `*.p8`, `*.pem`, `*.key`)
- Service account credential JSON files (`*service-account*.json`)
- API keys with administrative privileges
- Local environment files containing sensitive tokens (`.env`, `.env.local`)

### Runtime Configuration via `--dart-define`
External service credentials (such as `RAPID_API_KEY`) must be passed into the Flutter build securely at compilation time:

```powershell
flutter run --dart-define=RAPID_API_KEY=your_key_here
```

A template configuration is provided in [`.env.example`](file:///.env.example).

---

## 4. Firebase Security & Client Keys

- **Client Identifiers**: Firebase client API keys located in `google-services.json` and `firebase_options.dart` are application identifiers, not administrative secrets. Their permissions are strictly constrained by Firestore Security Rules.
- **Firestore Security Rules**: All read/write operations to Firestore must adhere to [`firestore.rules`](file:///firestore.rules). Rules enforce authentication checks, user ID ownership matching, document schema validation, string length limits, and non-negative counters.
- **Cloud Functions**: Server-side functions execute with least-privilege service accounts and sanitize all client inputs.

---

## 5. Local Data Privacy & Offline-First

- All user data (bookmarks, reading position, dhikr counts, khatmah progress) is stored locally on-device by default.
- No personal data or identifiable worship analytics are transmitted to third-party tracking services or ad networks.
- Network operations are strictly limited to verified religious data endpoints (e.g., ShiaAPI hadith sync, prayer calculations, remote audio streams).

---

## 6. Pre-Commit Security Checklist for Contributors

Before submitting any Pull Request:
- [ ] Run `git status` and verify no generated credentials or `.env` files are staged.
- [ ] Verify no secrets or sensitive debug logs are present in code diffs.
- [ ] Ensure all network requests use HTTPS.
- [ ] Run `flutter analyze` and ensure zero warnings or errors.
- [ ] Run `flutter test` to ensure full test suite passes.

