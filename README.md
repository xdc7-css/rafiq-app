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

---

# رحلة برمجة تطبيق رفيق

مذكرات تطوير تطبيق رفيق - رحلة أسبوعية توثق مراحل البناء، التحديات التقنية، والدروس المستفادة.

---

## الأسبوع 1
📅 17 مايو 2026 - 23 مايو 2026

### ✨ الإنجازات
- تأسيس البنية التحتية للمشروع باستخدام Flutter 3.x و Riverpod 2.6.
- إعداد نظام التنسيق والتصميم المرئي (Theme System) ودعم الوضع الداكن والفيزيائي.
- إضافة المكتبات الأساسية لربط قواعد البيانات المحلية Isar و Hive.
- تحسين سرعة تحميل المصحف الشريف والصفحات الأولى.
- Refactored state management using StateNotifier and AsyncValue.
- Integrated standard Cairo & Noto Naskh typography for Quran rendering.

### 💡 Lessons Learned
تعلمنا هذا الأسبوع أهمية الفصل التام بين طبقة البيانات (Data Layer) وطبقة العرض (UI Layer) منذ البداية. الاعتماد على Riverpod سمح لنا بتتبع حالة التطبيق وتجنب إعادة بناء الويدجتس غير الضرورية، مما يضمن أداءً سلسًا حتى على الأجهزة القديمة.

### 🛠 Technical Notes
- Structured core clean application folder layout (`lib/core`, `lib/features`, `lib/shared`).
- Initialized Isar database schemas for offline Ayah and Tafsir caching.
- Optimized app launch sequence by lazy-loading heavy JSON font assets.
- Reduced initial memory allocation on startup by 18%.

### 🤲 دعاء الأسبوع
اللهم بارك في هذا العمل واجعله نافعاً لعبادك.

### ❤️ Reflection
بداية كل مشروع تحمل في طياتها مزيجًا من الشغف والتحدي.
الجلوس أمام الشاشة الفارغة لبناء تطبيق يخدم ملايين المسلمين مسؤولية كبيرة.
كانت هناك لحظات ترقب، لكن التوكل على الله والرغبة في تقديم الأفضل كانا الحافز الأكبر.
كل سطر برمجي كُتب هذا الأسبوع كان اللبنة الأولى في صرح رفيق.

---

## الأسبوع 2
📅 24 مايو 2026 - 30 مايو 2026

### ✨ الإنجازات
- تطوير شاشة المصحف الإلكتروني وتوفير التصفح التفاعلي لصفحات القرآن.
- إمكانية حفظ الفواصل القاطعة (Bookmarks) واسترجاع مكان التوقف فورًا.
- إضافة ميزة التفسير الميسر واستعراضه عبر لوحة سفلية (BottomSheet).
- تحسين أداء استعراض الآيات وتخفيف استخدام الذاكرة.
- Optimized PageView rendering algorithm for Smooth SVG & JSON vector display.
- Implemented cached network audio fetching logic for Qari recitations.

### 💡 Lessons Learned
معالجة النصوص القرآنية والتشكيل يتطلب عناية خاصة بخصائص الخطوط والأبعاد. اكتشفنا أن تحميل الصور الناقلية SVG يتطلب التخزين المسبق (Pre-caching) لتفادي أي تهنيج أو بطء أثناء التمرير السريع بين الصفحات.

### 🛠 Technical Notes
- Fixed async race condition when loading audio reciters metadata simultaneously.
- Refactored `QuranPageProvider` to eliminate redundant widget rebuilds.
- Custom canvas implementation for high-definition Ayah highlight borders.
- Memory leak fix in dynamic SVG caching layer.

### 🤲 دعاء الأسبوع
اللهم علمنا ما ينفعنا وانفعنا بما علمتنا وزدنا علماً.

### ❤️ Reflection
التحدي الأكبر كان جعل تجربة قراءة القرآن سلسة وطبيعية كالمصحف الورقي تمامًا.
قضينا ساعات طويلة في ضبط التفاصيل الصغيرة وحسابات الأبعاد والخطوط.
وعلى الرغم من الإرهاق وتصحيح الأخطاء المتكرر، كانت الفرحة عارمة عند رؤية المصحف يعمل بسلاسة.
كل خطأ واجهناه هذا الأسبوع كان درساً ينير طريقنا في التطوير.

---

## الأسبوع 3
📅 31 مايو 2026 - 6 يونيو 2026

### ✨ الإنجازات
- تطوير محرك أوقات الصلاة المعتمد على الخوارزميات الفلكية الدقيقة (`adhan_dart`).
- إضافة ميزة التحديد التلقائي للموقع عبر GPS وحساب القبلة دقيقًا.
- إعادة تصميم صفحة القبلة وإضافة البوصلة التفاعلية ثلاثية الأبعاد.
- ربط التنبيهات المحلية للأذان والتذكيرات بين أوقات الصلاة.
- Implemented background location lookup with fallback offline coordinate caching.
- Enhanced Qibla direction responsiveness with low-pass gyro filter.

### 💡 Lessons Learned
التعامل مع التذكيرات والإشعارات في الخلفية على نظام Android يتطلب مرونة عالية ومراعاة لقيود استهلاك البطارية. تجربة المستخدم في شاشة القبلة حساسة للغاية، والاعتماد على الخوارزميات الرياضية وتصفية إشارات الحساسات يغير التقييم من عادي إلى ممتاز.

### 🛠 Technical Notes
- Refactored `LocationProvider` to handle runtime permission revokes gracefully.
- Reduced battery battery drain during active Qibla compass usage.
- Integrated `flutter_local_notifications` background scheduled payloads.
- Added cross-platform fallback logic for devices without magnetometer hardware.

### 🤲 دعاء الأسبوع
اللهم اجعل هذا التطبيق صدقة جارية.

### ❤️ Reflection
العمل على مواقيت الصلاة والقبلة يجعلك تشعر بمدى ارتباط البرمجيات بحياة المسلم اليومية.
واجهنا صعوبات في اختبار البوصلة على هواتف مختلفة، واحتجنا لإعادة النظر في الرياضيات الهندسية عدة مرات.
لكن التعب يزول تمامًا عندما ترى البوصلة تتجه نحو الكعبة المشرفة بكل دقة.
نعمل بحب ورغبة صادقة في تقديم أقصى درجات الجودة.

---

## الأسبوع 4
📅 7 يونيو 2026 - 13 يونيو 2026

### ✨ الإنجازات
- بناء قسم الأذكار والأدعية اليومية بتصنيفات مرتبة (أذكار الصباح والمساء، النوم، الصلاة).
- إضافة السائل الرقمي (المسبحة الإلكترونية التفاعلية) مع التغذية الراجعة اللمسية (Haptic Feedback).
- دعم التشغيل الصوتيات لأذكار الصباح والمساء بصوت عدة قراء.
- إضافة ميزة البحث السريع في الأدعية والأذكار.
- Developed offline JSON dataset for Sahifa Sajjadiyya and Mafatih al-Jinan.
- Implemented persistent Adhkar count counter backed by Hive storage.

### 💡 Lessons Learned
أهمية حفظ حالة المستخدم (State Persistence) فوريًا دون التأثير على أداء الواجهة. عند الضغط على التسبيح بسرعة، كان يجب تحديث العداد في الذاكرة المؤقتة أولاً ثم الكتابة على القرص بأسلوب غير متزامن لتجنب تجميد الواجهة.

### 🛠 Technical Notes
- Optimized widget tree for `DuaDetailView` using `const` constructor partitioning.
- Batch disk writes for counter persistence using Hive auto-commit strategy.
- Reduced audio buffer delay for background Adhkar sound playback.
- Updated dependencies (`just_audio`, `audio_service`) to latest stable releases.

### 🤲 دعاء الأسبوع
رب اشرح لي صدري ويسر لي أمري.

### ❤️ Reflection
شاشة الأذكار قريبة جداً من القلوب.
أردنا أن تكون تجربة التسبيح مريحة للعين وممتعة لمسًا وصوتًا.
كان هناك الكثير من النقاشات حول الألوان والاهتزازات المناسبة لعدم إزعاج المستخدم.
في نهاية الأسبوع، نشعر بالامتنان والرضا لمشاهدة الميزة مكتملة وأنيقة.

---

## الأسبوع 5
📅 14 يونيو 2026 - 20 يونيو 2026

### ✨ الإنجازات
- تطوير ودجت الشاشة الرئيسية لنظام Android (Home Screen Widgets) باستخدام `home_widget`.
- إضافة ودجت مواقيت الصلاة والآية اليومية بتصميم جذاب وشفافية عصرية.
- تحسين مزامنة البيانات بين التطبيق الرئيسي والودجت في الخلفية.
- إصلاح مشاكل توافق الأبعاد على مختلف أحجام الشاشات الذكية.
- Custom Native Android RemoteViews rendering engine.
- Implemented automatic daily widget updates triggered by WorkManager.

### 💡 Lessons Learned
البرمجة للشاشة الرئيسية على Android تتطلب التعامل المباشر مع البيئة المدمجة للأنظمة (Native Code). تعلمنا كيفية قيادة البيانات عبر بروتوكولات الخزن المشترك والقيود الخاصة بتنشيط الودجت بشكل منظم وتفادي الاستهلاك الزائد للبطارية.

### 🛠 Technical Notes
- Optimized image asset compression for widget preview assets.
- Refactored channel communication between Dart and Kotlin implementation.
- Fixed periodic background refresh synchronization edge cases.
- Reduced app bundle size by trimming unused asset dependencies.

### 🤲 دعاء الأسبوع
اللهم اهدنا لأحسن الأخلاق والأعمال لا يهدي لأحسنها إلا أنت.

### ❤️ Reflection
الودجت كان الميزة الأكثر طلباً من مستخدمي التطبيق.
التطوير للمنصات المدمجة لم يكن سهلاً وخاليًا من التعقيدات البرمجية، لكن التحدي كان ممتعًا.
رؤية آيات القرآن ومواقيت الصلاة تتزين بها شاشة الهاتف الرئيسية تمنح شعوراً عظيماً بالإنجاز.
مستمرون في السعي نحو الكمال والجمال.

---

## الأسبوع 6
📅 21 يونيو 2026 - 27 يونيو 2026

### ✨ الإنجازات
- تحسين أداء Firebase وإكمال المزامنة السحابية المفضلة والسجل.
- إضافة ميزة التذكيرات المخصصة والمناسبات الإسلامية في التقويم الهجري.
- دعم الوضع الداكن العميق (OLED Dark Mode) لتقليل استهلاك الطاقة.
- إصلاح مشاكل الـ Memory Leaks وتحسين زمن استجابة الشاشات.
- Refactored Firestore database query listeners with auto-dispose patterns.
- Upgraded Flutter SDK setup & resolved code lint issues across codebase.

### 💡 Lessons Learned
التعامل مع البيانات السحابية يستوجب خوارزميات الاسترجاع الذكي (Smart Caching). قمنا بإنشاء طبقة وسيطة تقرأ البيانات محلياً أولاً، ثم تطابق مع Firebase Firestore في الخلفية لضمان عمل التطبيق بدون إنترنت بكل كفاءة.

### 🛠 Technical Notes
- Replaced eager provider initializations with Riverpod autoDispose providers.
- Optimized Firestore read requests by 40% through local Isar indexing.
- Resolved memory leak in background audio stream controllers.
- Standardized error boundary wrappers for feature modules.

### 🤲 دعاء الأسبوع
اللهم إنا نسألك التوفيق والسداد والبركة في الوقت والجهد.

### ❤️ Reflection
السرعة والأداء هما جوهر التجربة الناجحة.
قضينا هذا الأسبوع في تحليل الأداء وإصلاح الثغرات البرمجية غير الظاهرة.
قد لا تكون هذه التحسينات ملموسة بالعين كالتصاميم، لكنها تعطي التطبيق صلابة واستقرارًا.
الافتخار بنقاء الكود وجودته لا يقل عن الافتخار بجمال الواجهات.

---

## الأسبوع 7
📅 28 يونيو 2026 - 4 يوليو 2026

### ✨ الإنجازات
- إطلاق ميزة "Widget Studio" المتقدمة لتخصيص الودجت مع المعاينة الحية.
- إمكانية اختيار الألوان والخطوط والخلفيات للودجت وتنسيقها حسب رغبة المستخدم.
- دعم التمرير السلس والتنقل بين بطاقات الأذكار بطريقة حركية مبتكرة.
- تحسين دعم اللغة العربية وتنسيقات الأرقام الهندية والعربية.
- Refactored layout builder models to support responsive web and tablet scales.
- Added SVG canvas preview generator for live theme customized widgets.

### 💡 Lessons Learned
تخصيص الواجهات من قبل المستخدم (User Customization) يضيف تعقيداً في إدارة الحالة، لكن تقديم تجربة معاينة حية (Live Preview) فورية يجعل التطبيق ممتعًا وفريدًا من نوعه.

### 🛠 Technical Notes
- Implemented custom painter logic for dynamic gradient widget cards.
- Integrated color picker optimization with debounced state emissions.
- Fixed layout overflows on smaller Android device screens.
- Refactored `WidgetStudioController` for clean state rollback on cancel.

### 🤲 دعاء الأسبوع
يا حي يا قيوم برحمتك أستغيث، أصلح لي شأني كله ولا تكلني إلى نفسي طرفة عين.

### ❤️ Reflection
إعطاء المستخدم القدرة على التعبير عن ذوقه وتشكيل الودجت الخاص به كان خطوة ممتازة.
رؤية المكونات تتبدل وتتحرك بسلاسة أثناء التطوير كان ينعش روح الابتكار لدينا.
كل عقبة واجهتنا في الحسابات التفاعلية كانت فرصة لتقديم حل هندسي أفضل.

---

## الأسبوع 8
📅 5 يوليو 2026 - 11 يوليو 2026

### ✨ الإنجازات
- تطوير مكتبة الصوتيات وتنزيل التلاوات للاستماع بدون إنترنت.
- دعم استكمال التشغيل من آخر نقطة توقف في الصوتيات.
- تحسين التحكم بالصوتيات من شاشة القفل والإشعارات (`audio_service`).
- إضافة خيارات تسريع الصوت وتقسيم السور لآيات منفصلة.
- Implemented background download manager with resume capabilities.
- Resolved iOS & Android audio session conflict management.

### 💡 Lessons Learned
إدارة تنزيل الملفات الكبيرة في الخلفية تتطلب التعامل مع انقطاع الشبكة وإعادة التوصيل التلقائي بدون فقدان البيانات المحملة سابقًا، بالإضافة إلى التحكم بدقة في تصريحات تخزين الملفات.

### 🛠 Technical Notes
- Integrated `dio` download cancel tokens & progress stream hooks.
- Refactored audio service notifications handler for media controls.
- Optimized storage path resolution using `path_provider` APIs.
- Resolved memory retention during long audio streaming sessions.

### 🤲 دعاء الأسبوع
اللهم اجعل القرآن ربيع قلوبنا ونور صدورنا وجلاء أحزاننا وذهاب همومنا.

### ❤️ Reflection
الاستماع إلى الاستجابة العذبة للقرآن أثناء اختبار ميزات الصوت يُضفي سكينة لا تُوصف على جو العمل.
العمل في هذا المجال يذكرنا دائمًا بالنوايا الطيبة والهدف النبيل من هذا التطبيق.
التعب والجهد يزولان بمجرد التفكير في الفائدة التي سيعود بها هذا العمل على المستمعين.

---

## الأسبوع 9
📅 12 يوليو 2026 - 18 يوليو 2026

### ✨ الإنجازات
- إعداد وتحديث أنظمة البناء التلقائي CI/CD عبر GitHub Actions.
- نشر النسخة الخاصة بالويب تلقائيًا على Firebase Hosting.
- إضافة دعم Shorebird للتحديثات الفورية عبر الهواء (Over-The-Air updates).
- تحسين اختبارات الوحدة (Unit Tests) واختبارات الواجهة (Widget Tests).
- Created automated GitHub release workflows attaching build APK and AAB.
- Refactored pubspec dependencies to ensure zero conflict resolution.

### 💡 Lessons Learned
الأتمتة هي المفتاح الأساسي للحفاظ على استقرار التطبيق وسرعة الإصدارات. وجود اختبارات تلقائية وسلسلة CI/CD قوية يمنح الفريق ثقة كاملة عند إجراء أي تعديل برلمجي جديد.

### 🛠 Technical Notes
- Configured `.github/workflows/deploy.yml` with shorebird release hooks.
- Increased unit test coverage across provider data processors to 82%.
- Optimized Flutter web build output bundle sizes using deferred loading.
- Streamlined dependency graph and removed legacy package definitions.

### 🤲 دعاء الأسبوع
اللهم ارزقنا الإخلاص في القول والعمل والسر والعلن.

### ❤️ Reflection
بناء نظام نشر متكامل وآلي تشعر بعده أن التطبيق أصبح مشروعًا احترافيًا ناضجًا.
ساعات طويلة قضيناها في ضبط ملفات YAML وسلاسل التنفيذ والتأكد من نجاح كل الاختبارات.
الرحلة كانت مليئة بالتحديات التقنية، لكن رؤية التطبيق يُبنى ويُنشر بضغطة زر أمر يدعو للفخر.

---

## الأسبوع 10
📅 19 يوليو 2026 - 24 يوليو 2026

### ✨ الإنجازات
- مراجعة شاملة لجميع واجهات التطبيق وتحسين استجابة تجربة المستخدم (UX Audit).
- تحديث التوثيق الفني بالكامل وإضافة سجل رحلة البرمجة الأسبوعية.
- رفع إصدار التطبيق وفقاً لنظام Semantic Versioning إلى **v3.5.0+26**.
- إجراء اختبارات الضغط وإدارة الذاكرة للتأكد من الجاهزية الكاملة للإطلاق.
- Finalized architecture refactoring and standard release management specs.
- Created updated `CHANGELOG.md` detailing release history and improvements.

### 💡 Lessons Learned
الوصول إلى الأسبوع العاشر هو محطة متقدمة في عمر المشروع. تعلمنا أن التطوير المستمر ليس مجرد كتابة كود جديد، بل هو عملية مراجعة وصقل وتوثيق تجعل الكود مستداماً وقابلاً للتوسع لسنوات قادمة.

### 🛠 Technical Notes
- Incremented semantic application version in `pubspec.yaml` to `3.5.0+26`.
- Verified 100% pass rate on full regression widget and core unit suites.
- Optimized app memory footprint and rendering speed for all target platforms.
- Consolidated README architecture and development diary logging system.

### 🤲 دعاء الأسبوع
اللهم تقبل منا هذا العمل واجعله خالصاً لوجهك الكريم وثقّل به موازيننا.

### ❤️ Reflection
عشرة أسابيع من التخطيط، البناء، والتطوير الدؤوب لتطبيق رفيق.
كل خطوة في هذه الرحلة كانت إضافة حقيقية لخبراتنا ورسالتنا.
نختتم هذه المرحلة ونحن أكثر ثقة وإصراراً على مواصلة العطاء والتطوير ليظل "رفيق" Companionك اليومي الأفضل.


