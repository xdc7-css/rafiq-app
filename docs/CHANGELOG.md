# Rafeeq (رَفِيقْ) — Engineering Changelog

All notable changes to the architecture, infrastructure, and technical foundation of Project Rafeeq will be documented here.

---

## [3.5.0] — 2026-09-05

### Added
- **AI Agent Engineering Workflow**: Integrated official `find-skills` and established `.agents/skills/` containing 13 specialized skills (Flutter architecture, responsive layout, widget testing, UI/UX Pro Max, design system, Firestore security auditor, code review, performance optimization, and security hardening).
- **Engineering Constitution (`AGENTS.md`)**: Created permanent engineering guidelines, coding rules, RTL Arabic constraints, and testing protocols.
- **Comprehensive Documentation Suite (`docs/`)**:
  - `PRODUCT_BRIEF.md`: Core product vision, user personas, and scope taxonomy.
  - `MVP.md`: Capabilities breakdown with states, offline handling, and acceptance criteria.
  - `ARCHITECTURE.md`: Layered system design, cross-platform database duality, and audio pipeline.
  - `DATA_ARCHITECTURE.md`: Isar 16-collection schema, Hive cache, and Firestore models.
  - `DESIGN_SYSTEM.md`: Midnight Navy & Royal Gold color tokens, typography, and state matrix.
  - `UX.md`: Interaction design, RTL navigation, and touch target standards.
  - `QURAN_ARCHITECTURE.md`: SVG vector Mushaf engine and background recitation pipeline.
  - `QIBLA_ARCHITECTURE.md`: Great Circle mathematical formulas and sensor fusion stream.
  - `WIDGET_ARCHITECTURE.md`: Android AppWidget RemoteViews and background synchronization.
  - `ANDROID.md`: Kotlin Gradle DSL, permissions rationale, desugaring, and Proguard rules.
  - `TESTING.md`: Practical testing pyramid and execution guidelines.
  - `SECURITY.md`: Security review and Firestore rule compliance report.

### Changed
- Refreshed codebase audit benchmarks: Flutter 3.44.1, Dart 3.12.1.
- Validated test suites: 100% pass rate on unit and SVG parse tests.
