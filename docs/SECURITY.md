# Rafeeq (رَفِيقْ) — Security & Privacy Architecture

> **Security Posture**: Production Hardened with Cloud Least-Privilege  
> **Audited Modules**: Firebase Options, Firestore Rules, Local Database, Network Endpoints  

---

## 1. Security Review & Threat Assessment

### 1. Cloud Firestore Rules Audit (`firestore.rules`)
- **Status**: ✅ **PASS (Hardened)**
- **Audit Findings**:
  - `memorials`: Read is restricted to public entries or the authenticated creator. Create and update enforce exact authenticated `userId` matching (`request.resource.data.userId == request.auth.uid`).
  - **Type & Length Validation**: `deceasedName` is strictly limited to non-empty strings of $\le 120$ characters, mitigating denial-of-service or database payload inflation.
  - **Counter Bounds**: All spiritual counts (`prayerCount`, `duaCount`, `khatmahCount`, `tasbeehCount`) must be non-negative integers ($\ge 0$).
  - `rewards`: Read is public; creation is strictly authenticated with field bounds (`count` $\le 100$, `points` $\le 1000$); updates and deletes are explicitly rejected (`allow update, delete: if false;`), ensuring an immutable audit trail.

### 2. Firebase Client Keys (`lib/firebase_options.dart`)
- **Status**: ✅ **VERIFIED SAFE**
- **Assessment**: The `apiKey` values present in `firebase_options.dart` (Web and Android) are standard Firebase client identifiers intended for application bundle distribution. They identify the project to Google APIs and are protected by Google Cloud HTTP referrer restrictions, Android package SHA-1 fingerprint restrictions, and Firestore Security Rules.
- **Action Item**: macOS configuration currently contains placeholder strings (`REPLACE_WITH_MACOS_API_KEY`), which is safe since macOS is not a target production release at this stage.

### 3. Local Data Privacy & Encryption
- **Isar Database (Android)**: Stored in the app's internal sandbox (`/data/user/0/com.dailyislamicwidget.daily_islamic_widget/app_flutter/`). Inaccessible to non-root external applications.
- **Web Storage**: SharedPreferences data in browser `localStorage` is scoped to the origin domain (`rafiqfamily-5c8ed.web.app`).

### 4. Network Communications (Transit Security)
- All remote API endpoints (ShiaAPI, EveryAyah recitation CDN, Firebase Auth/Firestore) communicate strictly over **HTTPS / TLS 1.3**.
- Plaintext HTTP (`cleartextTrafficPermitted`) is disabled in Android release configurations.

---

## 2. Hardening Invariants for AI Agents

1. **Never Log Sensitive Information**: Prohibit printing user authentication tokens, email addresses, or coordinates to console output in production builds.
2. **Never Commit Secrets**: Do not commit private `.keystore` files, Google Service Account JSON keys, or production `.env` credentials to Git.
3. **Validate All Dynamic Data**: Incoming network payloads from external APIs must be validated before storing into local collections.
