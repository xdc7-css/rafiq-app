import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../theme/app_theme.dart';

class ReadingSettingsSheet extends StatefulWidget {
  const ReadingSettingsSheet({super.key});

  @override
  State<ReadingSettingsSheet> createState() => _ReadingSettingsSheetState();
}

class _ReadingSettingsSheetState extends State<ReadingSettingsSheet> {
  double _fontSize = 1.0;
  bool _keepScreenOn = true;
  bool _showPageIndicator = true;
  String _backgroundMode = 'dark';
  bool _loading = true;

  static const _bgModes = {
    'dark': 'داكن',
    'sepia': 'بني',
    'light': 'فاتح',
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('reading_font_scale') ?? 1.0;
      _keepScreenOn = prefs.getBool('reading_keep_screen_on') ?? true;
      _showPageIndicator =
          prefs.getBool('reading_show_page_indicator') ?? true;
      _backgroundMode = prefs.getString('reading_bg_mode') ?? 'dark';
      _loading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('reading_font_scale', _fontSize);
    await prefs.setBool('reading_keep_screen_on', _keepScreenOn);
    await prefs.setBool('reading_show_page_indicator', _showPageIndicator);
    await prefs.setString('reading_bg_mode', _backgroundMode);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildHeader(),
              if (_loading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.goldPrimary,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    children: [
                      _buildFontSizeSection(),
                      const SizedBox(height: 20),
                      _buildBackgroundSection(),
                      const SizedBox(height: 20),
                      _buildToggleOption(
                        icon: Icons.screen_lock_portrait_rounded,
                        title: 'إبقاء الشاشة مضاءة',
                        subtitle: 'أثناء القراءة',
                        value: _keepScreenOn,
                        onChanged: (v) {
                          setState(() => _keepScreenOn = v);
                          _saveSettings();
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildToggleOption(
                        icon: Icons.pin_drop_rounded,
                        title: 'إظهار مؤشر الصفحة',
                        subtitle: 'في شريط التنقل السفلي',
                        value: _showPageIndicator,
                        onChanged: (v) {
                          setState(() => _showPageIndicator = v);
                          _saveSettings();
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: AppTheme.midnightNavy,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'إعدادات القراءة',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeSection() {
    return _buildSection(
      title: 'حجم الخط',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.text_fields_rounded,
                size: 16,
                color: Colors.white.withValues(alpha: 0.5),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppTheme.goldPrimary,
                    inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                    thumbColor: AppTheme.goldPrimary,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 16,
                    ),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: _fontSize,
                    min: 0.8,
                    max: 1.5,
                    divisions: 7,
                    onChanged: (v) {
                      setState(() => _fontSize = v);
                      _saveSettings();
                    },
                  ),
                ),
              ),
              Icon(
                Icons.text_fields_rounded,
                size: 24,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ],
          ),
          Text(
            '${(_fontSize * 100).round()}%',
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppTheme.goldPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundSection() {
    return _buildSection(
      title: 'لون الخلفية',
      child: Row(
        children: _bgModes.entries.map((entry) {
          final selected = _backgroundMode == entry.key;
          final bgColor = switch (entry.key) {
            'dark' => const Color(0xFF0A0F1E),
            'sepia' => const Color(0xFF2B2118),
            'light' => const Color(0xFFF5F2ED),
            _ => const Color(0xFF0A0F1E),
          };
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _backgroundMode = entry.key);
                _saveSettings();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.goldPrimary.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? AppTheme.goldPrimary.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected
                              ? AppTheme.goldPrimary
                              : Colors.white.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry.value,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 11,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected
                            ? AppTheme.goldPrimary
                            : Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.goldPrimary.withValues(alpha: 0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppTheme.midnightNavy,
              activeTrackColor: AppTheme.goldPrimary,
              inactiveThumbColor: Colors.white.withValues(alpha: 0.4),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
