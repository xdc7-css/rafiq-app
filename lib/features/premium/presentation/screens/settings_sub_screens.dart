import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/ds_components.dart';
import '../../../../widgets/star_background.dart';

// ─────────────────────────────────────────────────
// Language Settings Screen
// ─────────────────────────────────────────────────

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguage = 'ar';
  String _selectedQuranScript = 'uthmani';
  String _selectedTranslation = 'hilali';

  final _languages = [
    ('ar', 'العربية', '🇸🇦', 'العربية'),
    ('en', 'English', '🇺🇸', 'الإنجليزية'),
    ('fr', 'Français', '🇫🇷', 'الفرنسية'),
    ('ur', 'اردو', '🇵🇰', 'الأردية'),
    ('tr', 'Türkçe', '🇹🇷', 'التركية'),
    ('id', 'Bahasa Indonesia', '🇮🇩', 'الإندونيسية'),
    ('ms', 'Bahasa Melayu', '🇲🇾', 'الملايوية'),
    ('de', 'Deutsch', '🇩🇪', 'الألمانية'),
  ];

  final _scripts = [
    ('uthmani', 'الخط العثماني', 'النص المعتمد في المصحف الشريف'),
    ('indopak', 'الخط الهندي', 'يستخدم في جنوب آسيا'),
    ('simple', 'خط مبسط', 'للقراءة السريعة'),
  ];

  final _translations = [
    ('hilali', 'محسن خان وهلالي', 'ترجمة إنجليزية معتمدة'),
    ('sahih_intl', 'السعيدي الدولي', 'ترجمة إنجليزية حديثة'),
    ('pickthal', 'محمد بيكثال', 'ترجمة كلاسيكية'),
    ('yusuf_ali', 'يوسف علي', 'ترجمة مرجعية شهيرة'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gold = AppTheme.goldPrimary;
    final primaryText = AppTheme.textPrimary;
    final secondaryText = AppTheme.textMuted;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Column(
              children: [
                _PremiumAppBar(
                  title: 'اللغة والمحتوى',
                  gold: gold,
                  primaryText: primaryText,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _SectionHeader(
                        title: 'لغة التطبيق',
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(height: 12),
                      GlassCard(
                        radius: 24,
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          children: _languages.map((lang) {
                            final selected = _selectedLanguage == lang.$1;
                            return _LanguageTile(
                              flag: lang.$3,
                              nativeName: lang.$2,
                              englishName: lang.$4,
                              selected: selected,
                              isDark: isDark,
                              gold: gold,
                              primaryText: primaryText,
                              secondaryText: secondaryText,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _selectedLanguage = lang.$1);
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: 'خط المصحف',
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(height: 12),
                      GlassCard(
                        radius: 24,
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          children: _scripts.map((s) {
                            final selected = _selectedQuranScript == s.$1;
                            return _RadioTile(
                              title: s.$2,
                              subtitle: s.$3,
                              selected: selected,
                              isDark: isDark,
                              gold: gold,
                              primaryText: primaryText,
                              secondaryText: secondaryText,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _selectedQuranScript = s.$1);
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: 'ترجمة معنى القرآن',
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(height: 12),
                      GlassCard(
                        radius: 24,
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          children: _translations.map((t) {
                            final selected = _selectedTranslation == t.$1;
                            return _RadioTile(
                              title: t.$2,
                              subtitle: t.$3,
                              selected: selected,
                              isDark: isDark,
                              gold: gold,
                              primaryText: primaryText,
                              secondaryText: secondaryText,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _selectedTranslation = t.$1);
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 32),
                      _SaveButton(
                        gold: gold,
                        isDark: isDark,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.maybePop(context);
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Notification Settings Screen
// ─────────────────────────────────────────────────

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _prayerNotifs = true;
  bool _fajrAdhan = true;
  bool _dhuhrAdhan = false;
  bool _asrAdhan = true;
  bool _maghribAdhan = true;
  bool _ishaAdhan = true;
  bool _dailyAyah = true;
  bool _dailyHadith = true;
  bool _hijriReminder = false;
  bool _khatmahReminder = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gold = AppTheme.goldPrimary;
    final primaryText = AppTheme.textPrimary;
    final secondaryText = AppTheme.textMuted;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Column(
              children: [
                _PremiumAppBar(
                  title: 'إعدادات الإشعارات',
                  gold: gold,
                  primaryText: primaryText,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    children: [
                      // Master toggle
                      GlassCard(
                        radius: 20,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: gold.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_active_rounded,
                                color: gold,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'إشعارات الصلاة',
                                    style: GoogleFonts.notoKufiArabic(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: primaryText,
                                    ),
                                  ),
                                  Text(
                                    'تفعيل إشعارات مواقيت الصلاة',
                                    style: GoogleFonts.notoKufiArabic(
                                      fontSize: 12,
                                      color: secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _GoldSwitch(
                              value: _prayerNotifs,
                              gold: gold,
                              onChanged: (v) =>
                                  setState(() => _prayerNotifs = v),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      _SectionHeader(
                        title: 'الأذان لكل صلاة',
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(height: 12),

                      GlassCard(
                        radius: 24,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            _PrayerToggleTile(
                              'الفجر',
                              '04:32',
                              _fajrAdhan,
                              gold,
                              primaryText,
                              secondaryText,
                              (v) => setState(() => _fajrAdhan = v),
                              isDark,
                              _prayerNotifs,
                            ),
                            _Divider(gold: gold),
                            _PrayerToggleTile(
                              'الظهر',
                              '12:15',
                              _dhuhrAdhan,
                              gold,
                              primaryText,
                              secondaryText,
                              (v) => setState(() => _dhuhrAdhan = v),
                              isDark,
                              _prayerNotifs,
                            ),
                            _Divider(gold: gold),
                            _PrayerToggleTile(
                              'العصر',
                              '15:45',
                              _asrAdhan,
                              gold,
                              primaryText,
                              secondaryText,
                              (v) => setState(() => _asrAdhan = v),
                              isDark,
                              _prayerNotifs,
                            ),
                            _Divider(gold: gold),
                            _PrayerToggleTile(
                              'المغرب',
                              '18:52',
                              _maghribAdhan,
                              gold,
                              primaryText,
                              secondaryText,
                              (v) => setState(() => _maghribAdhan = v),
                              isDark,
                              _prayerNotifs,
                            ),
                            _Divider(gold: gold),
                            _PrayerToggleTile(
                              'العشاء',
                              '20:30',
                              _ishaAdhan,
                              gold,
                              primaryText,
                              secondaryText,
                              (v) => setState(() => _ishaAdhan = v),
                              isDark,
                              _prayerNotifs,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: 'التذكيرات اليومية',
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(height: 12),

                      GlassCard(
                        radius: 24,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            _ToggleTile(
                              'آية اليوم',
                              Icons.auto_stories_rounded,
                              _dailyAyah,
                              gold,
                              primaryText,
                              secondaryText,
                              (v) => setState(() => _dailyAyah = v),
                            ),
                            _Divider(gold: gold),
                            _ToggleTile(
                              'حديث اليوم',
                              Icons.format_quote_rounded,
                              _dailyHadith,
                              gold,
                              primaryText,
                              secondaryText,
                              (v) => setState(() => _dailyHadith = v),
                            ),
                            _Divider(gold: gold),
                            _ToggleTile(
                              'المناسبات الهجرية',
                              Icons.event_rounded,
                              _hijriReminder,
                              gold,
                              primaryText,
                              secondaryText,
                              (v) => setState(() => _hijriReminder = v),
                            ),
                            _Divider(gold: gold),
                            _ToggleTile(
                              'تذكير الختمة',
                              Icons.menu_book_rounded,
                              _khatmahReminder,
                              gold,
                              primaryText,
                              secondaryText,
                              (v) => setState(() => _khatmahReminder = v),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Support Screen
// ─────────────────────────────────────────────────

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gold = AppTheme.goldPrimary;
    final primaryText = AppTheme.textPrimary;
    final secondaryText = AppTheme.textMuted;

    final faqs = [
      (
        'كيف أضيف الويدجت لشاشتي الرئيسية؟',
        'اضغط على الشاشة الرئيسية مطوّلاً ثم اختر "الأدوات" وابحث عن رَفِيقْ.',
      ),
      (
        'كيف أغير موقع الصلاة؟',
        'اذهب إلى الإعدادات > مواقيت الصلاة > الموقع وحدد مدينتك أو استخدم GPS.',
      ),
      (
        'هل يعمل التطبيق بدون إنترنت؟',
        'نعم، القرآن الكريم والأذكار والأدعية متاحة بالكامل دون إنترنت.',
      ),
      (
        'كيف أحذف حسابي؟',
        'اذهب إلى الملف الشخصي > الإعدادات > حذف الحساب. سيتم حذف بياناتك خلال 30 يوماً.',
      ),
      (
        'لا يعمل الأذان على جهازي',
        'تأكد من إذن الصوت وأن وضع الصمت غير مفعّل، ثم تحقق من إعدادات الإشعارات.',
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Column(
              children: [
                _PremiumAppBar(
                  title: 'الدعم الفني',
                  gold: gold,
                  primaryText: primaryText,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    children: [
                      // Hero Card
                      GlassCard(
                        radius: 24,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                gradient: AppTheme.goldGradient,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.support_agent_rounded,
                                color: isDark
                                    ? AppTheme.bgPrimary
                                    : Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'نحن هنا لمساعدتك',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'فريق الدعم متاح ٢٤/٧ للمستخدمين المميزين',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 12,
                                color: secondaryText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Contact Options
                      _SectionHeader(
                        title: 'تواصل معنا',
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(height: 12),

                      _ContactCard(
                        icon: Icons.chat_rounded,
                        title: 'المحادثة المباشرة',
                        subtitle: 'متوسط وقت الرد: دقيقتان',
                        badge: 'متاح الآن',
                        badgeColor: Colors.green,
                        isDark: isDark,
                        gold: gold,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                        onTap: () => HapticFeedback.mediumImpact(),
                      ),
                      const SizedBox(height: 12),
                      _ContactCard(
                        icon: Icons.email_rounded,
                        title: 'البريد الإلكتروني',
                        subtitle: 'support@islamicapp.com',
                        badge: '< ٢٤ ساعة',
                        badgeColor: gold,
                        isDark: isDark,
                        gold: gold,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                        onTap: () => HapticFeedback.lightImpact(),
                      ),
                      const SizedBox(height: 12),
                      _ContactCard(
                        icon: Icons.forum_rounded,
                        title: 'منتدى المجتمع',
                        subtitle: 'اطرح سؤالك أو تصفح الإجابات',
                        badge: null,
                        badgeColor: null,
                        isDark: isDark,
                        gold: gold,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                        onTap: () => HapticFeedback.lightImpact(),
                      ),

                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: 'الأسئلة الشائعة',
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(height: 12),

                      ...faqs.map(
                        (faq) => _FaqTile(
                          question: faq.$1,
                          answer: faq.$2,
                          isDark: isDark,
                          gold: gold,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Feedback Screen
// ─────────────────────────────────────────────────

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;
  int _selectedCategory = -1;
  final _feedbackController = TextEditingController();
  bool _submitted = false;

  final _categories = [
    'تقرير خطأ',
    'اقتراح ميزة',
    'محتوى',
    'أداء التطبيق',
    'تصميم وتجربة المستخدم',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gold = AppTheme.goldPrimary;
    final primaryText = AppTheme.textPrimary;
    final secondaryText = AppTheme.textMuted;

    if (_submitted) {
      return _FeedbackSuccess(
        isDark: isDark,
        gold: gold,
        primaryText: primaryText,
        secondaryText: secondaryText,
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Column(
              children: [
                _PremiumAppBar(
                  title: 'تقييم التطبيق',
                  gold: gold,
                  primaryText: primaryText,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),

                        // Stars
                        GlassCard(
                          radius: 24,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                'ما مدى رضاك عن التطبيق؟',
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (i) {
                                  return GestureDetector(
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      setState(() => _rating = i + 1);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: AnimatedScale(
                                        scale: _rating > i ? 1.15 : 1.0,
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        child: Icon(
                                          _rating > i
                                              ? Icons.star_rounded
                                              : Icons.star_outline_rounded,
                                          color: _rating > i
                                              ? gold
                                              : secondaryText.withValues(
                                                  alpha: 0.4,
                                                ),
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _ratingLabel(_rating),
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 14,
                                  color: _rating > 0 ? gold : secondaryText,
                                  fontWeight: _rating > 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        _SectionHeader(
                          title: 'نوع الملاحظة',
                          secondaryText: secondaryText,
                        ),
                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(_categories.length, (i) {
                            final selected = _selectedCategory == i;
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _selectedCategory = i);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: selected
                                      ? AppTheme.goldGradient
                                      : null,
                                  color: selected
                                      ? null
                                      : (isDark
                                            ? AppTheme.bgCard.withValues(
                                                alpha: 0.4,
                                              )
                                            : Colors.white.withValues(
                                                alpha: 0.7,
                                              )),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: selected
                                        ? Colors.transparent
                                        : gold.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Text(
                                  _categories[i],
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 13,
                                    color: selected
                                        ? (isDark
                                              ? AppTheme.bgPrimary
                                              : Colors.white)
                                        : primaryText,
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 20),
                        _SectionHeader(
                          title: 'تفاصيل الملاحظة (اختياري)',
                          secondaryText: secondaryText,
                        ),
                        const SizedBox(height: 12),

                        GlassCard(
                          radius: 20,
                          padding: const EdgeInsets.all(4),
                          child: TextField(
                            controller: _feedbackController,
                            maxLines: 5,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 13,
                              color: primaryText,
                            ),
                            decoration: InputDecoration(
                              hintText: 'شاركنا رأيك وملاحظاتك...',
                              hintStyle: GoogleFonts.notoKufiArabic(
                                fontSize: 13,
                                color: secondaryText.withValues(alpha: 0.6),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        _SaveButton(
                          gold: gold,
                          isDark: isDark,
                          label: 'إرسال الملاحظة',
                          onTap: () {
                            if (_rating == 0 && _selectedCategory == -1) return;
                            HapticFeedback.mediumImpact();
                            setState(() => _submitted = true);
                          },
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _ratingLabel(int r) {
    switch (r) {
      case 1:
        return 'سيئ جداً';
      case 2:
        return 'سيئ';
      case 3:
        return 'متوسط';
      case 4:
        return 'جيد';
      case 5:
        return 'ممتاز! أحببناه 🌟';
      default:
        return 'اضغط على نجمة للتقييم';
    }
  }
}

class _FeedbackSuccess extends StatelessWidget {
  final bool isDark;
  final Color gold;
  final Color primaryText;
  final Color secondaryText;

  const _FeedbackSuccess({
    required this.isDark,
    required this.gold,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          const StarBackground(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: gold.withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      color: isDark ? AppTheme.bgPrimary : Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'شكراً جزيلاً! ❤️',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: gold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'ملاحظاتك تساعدنا على تحسين التطبيق وتطويره لخدمتكم بشكل أفضل',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 14,
                      color: secondaryText,
                      height: 1.7,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor: isDark
                            ? AppTheme.bgPrimary
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      onPressed: () => Navigator.maybePop(context),
                      child: Text(
                        'العودة للرئيسية',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Shared Helper Widgets
// ─────────────────────────────────────────────────

class _PremiumAppBar extends StatelessWidget {
  final String title;
  final Color gold;
  final Color primaryText;

  const _PremiumAppBar({
    required this.title,
    required this.gold,
    required this.primaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.maybePop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: gold.withValues(alpha: 0.25)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: gold,
                size: 18,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color secondaryText;

  const _SectionHeader({required this.title, required this.secondaryText});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.notoKufiArabic(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: secondaryText,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final Color gold;
  final bool isDark;
  final String label;
  final VoidCallback onTap;

  const _SaveButton({
    required this.gold,
    required this.isDark,
    this.label = 'حفظ التغييرات',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: AppTheme.goldGradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: gold.withValues(alpha: 0.35),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.bgPrimary : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _GoldSwitch extends StatelessWidget {
  final bool value;
  final Color gold;
  final ValueChanged<bool> onChanged;

  const _GoldSwitch({
    required this.value,
    required this.gold,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: (v) {
        HapticFeedback.selectionClick();
        onChanged(v);
      },
      activeThumbColor: gold,
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected))
          return gold.withValues(alpha: 0.25);
        return null;
      }),
    );
  }
}

class _Divider extends StatelessWidget {
  final Color gold;
  const _Divider({required this.gold});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: gold.withValues(alpha: 0.08),
      indent: 20,
      endIndent: 20,
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String flag;
  final String nativeName;
  final String englishName;
  final bool selected;
  final bool isDark;
  final Color gold;
  final Color primaryText;
  final Color secondaryText;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.flag,
    required this.nativeName,
    required this.englishName,
    required this.selected,
    required this.isDark,
    required this.gold,
    required this.primaryText,
    required this.secondaryText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? gold.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nativeName,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected ? gold : primaryText,
                    ),
                  ),
                  Text(
                    englishName,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, color: gold, size: 22),
          ],
        ),
      ),
    );
  }
}

class _RadioTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final bool isDark;
  final Color gold;
  final Color primaryText;
  final Color secondaryText;
  final VoidCallback onTap;

  const _RadioTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.isDark,
    required this.gold,
    required this.primaryText,
    required this.secondaryText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? gold.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected ? gold : primaryText,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? gold : secondaryText.withValues(alpha: 0.4),
                  width: selected ? 0 : 1.5,
                ),
                gradient: selected ? AppTheme.goldGradient : null,
              ),
              child: selected
                  ? Icon(
                      Icons.check_rounded,
                      color: isDark ? AppTheme.bgPrimary : Colors.white,
                      size: 13,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final Color gold;
  final Color primaryText;
  final Color secondaryText;
  final ValueChanged<bool> onChanged;

  const _ToggleTile(
    this.title,
    this.icon,
    this.value,
    this.gold,
    this.primaryText,
    this.secondaryText,
    this.onChanged,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: gold, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 14,
                color: primaryText,
              ),
            ),
          ),
          _GoldSwitch(value: value, gold: gold, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _PrayerToggleTile extends StatelessWidget {
  final String prayer;
  final String time;
  final bool value;
  final Color gold;
  final Color primaryText;
  final Color secondaryText;
  final ValueChanged<bool> onChanged;
  final bool isDark;
  final bool parentEnabled;

  const _PrayerToggleTile(
    this.prayer,
    this.time,
    this.value,
    this.gold,
    this.primaryText,
    this.secondaryText,
    this.onChanged,
    this.isDark,
    this.parentEnabled,
  );

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: parentEnabled ? 1.0 : 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                prayer,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 14,
                  color: primaryText,
                ),
              ),
            ),
            _GoldSwitch(
              value: value && parentEnabled,
              gold: gold,
              onChanged: parentEnabled ? onChanged : (_) {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final Color? badgeColor;
  final bool isDark;
  final Color gold;
  final Color primaryText;
  final Color secondaryText;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badge,
    this.badgeColor,
    required this.isDark,
    required this.gold,
    required this.primaryText,
    required this.secondaryText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        radius: 20,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: gold, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (badgeColor ?? gold).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (badgeColor ?? gold).withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  badge!,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 10,
                    color: badgeColor ?? gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: gold.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  final bool isDark;
  final Color gold;
  final Color primaryText;
  final Color secondaryText;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.isDark,
    required this.gold,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _expanded = !_expanded;
            if (_expanded) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          });
        },
        child: GlassCard(
          radius: 20,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _expanded ? widget.gold : widget.primaryText,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: widget.gold,
                      size: 22,
                    ),
                  ),
                ],
              ),
              SizeTransition(
                sizeFactor: _animation,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: widget.gold.withValues(alpha: 0.12),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.answer,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 12,
                        color: widget.secondaryText,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
