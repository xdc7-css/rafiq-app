import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/arabic_strings.dart';
import '../../providers/settings_provider.dart';
import '../../services/home_widget_service.dart';

class WidgetSettingsScreen extends ConsumerStatefulWidget {
  const WidgetSettingsScreen({super.key});

  @override
  ConsumerState<WidgetSettingsScreen> createState() =>
      _WidgetSettingsScreenState();
}

class _WidgetSettingsScreenState extends ConsumerState<WidgetSettingsScreen> {
  late double _transparency;
  late double _fontSize;
  late Color _bgColor;
  late Color _textColor;
  int _selectedPreviewIndex = 0;

  static const _widgetTypes = [
    _WidgetType('أوقات الصلاة (كبير)', Icons.access_time_filled, '4×2'),
    _WidgetType('أوقات الصلاة (صغير)', Icons.access_time, '2×2'),
    _WidgetType('القرآن الكريم', Icons.menu_book, '2×3'),
    _WidgetType('المسبحة', Icons.change_history, '2×2'),
    _WidgetType('اللوحة الشاملة', Icons.dashboard, '4×4'),
  ];

  @override
  void initState() {
    super.initState();
    _initFromSettings();
  }

  void _initFromSettings() {
    final settings = ref.read(settingsNotifierProvider);
    _transparency = settings.widgetTransparency;
    _fontSize = settings.widgetFontSize;
    _bgColor = Color(settings.widgetBgColor);
    _textColor = Color(settings.widgetTextColor);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(Ar.widgetSettingsAppBar),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInstructions,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Widget Type Selector
            Text(
              'اختر نوع الودجت',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _widgetTypes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final wt = _widgetTypes[index];
                  final selected = _selectedPreviewIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPreviewIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 90,
                      decoration: BoxDecoration(
                        color: selected
                            ? theme.colorScheme.primary.withValues(alpha: 0.15)
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            wt.icon,
                            size: 24,
                            color: selected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            wt.label,
                            style: TextStyle(
                              fontSize: 9,
                              color: selected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight:
                                  selected ? FontWeight.bold : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            wt.size,
                            style: TextStyle(
                              fontSize: 8,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Live Preview
            Text(
              Ar.preview,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildLivePreview(theme),

            const SizedBox(height: 24),

            // Background Color
            Text(
              Ar.bgColor,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildColorPicker(
              _bgColor,
              (color) => setState(() => _bgColor = color),
              theme,
            ),

            const SizedBox(height: 20),

            // Text Color
            Text(
              Ar.textColor,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildColorPicker(
              _textColor,
              (color) => setState(() => _textColor = color),
              theme,
            ),

            const SizedBox(height: 20),

            // Transparency
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Ar.transparency,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(_transparency * 100).round()}%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: theme.colorScheme.primary,
                thumbColor: theme.colorScheme.primary,
                overlayColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Slider(
                value: _transparency,
                min: 0.1,
                max: 1.0,
                divisions: 18,
                onChanged: (value) => setState(() => _transparency = value),
              ),
            ),

            const SizedBox(height: 16),

            // Font Size
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Ar.font_Size,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_fontSize.round()}sp',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: theme.colorScheme.primary,
                thumbColor: theme.colorScheme.primary,
                overlayColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Slider(
                value: _fontSize,
                min: 10.0,
                max: 24.0,
                divisions: 14,
                onChanged: (value) => setState(() => _fontSize = value),
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(Icons.check_circle_outline),
                label: Text(
                  Ar.saveSettings,
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Instruction hint
            Center(
              child: TextButton.icon(
                onPressed: _showInstructions,
                icon: const Icon(Icons.help_outline, size: 18),
                label: const Text(
                  'كيف أضيف الودجت للشاشة؟',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLivePreview(ThemeData theme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildWidgetPreviewByType(theme),
    );
  }

  Widget _buildWidgetPreviewByType(ThemeData theme) {
    switch (_selectedPreviewIndex) {
      case 0:
        return _buildPrayer4x2Preview(theme);
      case 1:
        return _buildPrayer2x2Preview(theme);
      case 2:
        return _buildQuranPreview(theme);
      case 3:
        return _buildTasbihPreview(theme);
      case 4:
        return _buildDashboardPreview(theme);
      default:
        return _buildPrayer4x2Preview(theme);
    }
  }

  Widget _buildPrayer4x2Preview(ThemeData theme) {
    return Container(
      key: const ValueKey('prayer4x2'),
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _bgColor,
            Color.lerp(_bgColor, Colors.black, 0.3)!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _textColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '☪',
                style: TextStyle(
                  fontSize: _fontSize * 0.9,
                  color: const Color(0xFFD8B56A),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'الفجر',
                style: TextStyle(
                  fontSize: _fontSize * 1.1,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              const Spacer(),
              Text(
                '٠٤:٣٠',
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD8B56A),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '▽ ١:٤٥',
                style: TextStyle(
                  fontSize: _fontSize * 0.7,
                  color: _textColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 0.5,
            color: _textColor.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _prayerMini('الفجر', '٤:٣٠', _textColor),
              _prayerMini('الظهر', '١٢:٣٠', _textColor),
              _prayerMini('العصر', '٤:٠٠', _textColor),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              _prayerMini('المغرب', '٧:١٥', _textColor),
              _prayerMini('العشاء', '٨:٤٥', _textColor),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _prayerMini(String name, String time, Color textColor) {
    return Expanded(
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: _fontSize * 0.6,
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 2),
          Text(
            time,
            style: TextStyle(
              fontSize: _fontSize * 0.65,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayer2x2Preview(ThemeData theme) {
    return Container(
      key: const ValueKey('prayer2x2'),
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _bgColor,
            Color.lerp(_bgColor, Colors.black, 0.3)!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _textColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('☪', style: TextStyle(fontSize: _fontSize * 1.2, color: const Color(0xFFD8B56A))),
          const SizedBox(height: 4),
          Text(
            'الفجر',
            style: TextStyle(
              fontSize: _fontSize * 0.9,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          Text(
            '٠٤:٣٠',
            style: TextStyle(
              fontSize: _fontSize * 1.1,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD8B56A),
            ),
          ),
          Text(
            '▽ ١:٤٥',
            style: TextStyle(
              fontSize: _fontSize * 0.65,
              color: _textColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuranPreview(ThemeData theme) {
    return Container(
      key: const ValueKey('quran'),
      width: 180,
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _bgColor,
            Color.lerp(_bgColor, Colors.black, 0.3)!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _textColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'بِسْمِ ٱللَّهِ',
            style: TextStyle(
              fontSize: _fontSize * 0.8,
              color: const Color(0xFFD8B56A),
            ),
          ),
          const SizedBox(height: 4),
          Container(height: 0.5, color: _textColor.withValues(alpha: 0.2)),
          const SizedBox(height: 4),
          Text(
            'سورة البقرة',
            style: TextStyle(
              fontSize: _fontSize * 0.9,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          Text(
            'الآية ٢٥٥',
            style: TextStyle(
              fontSize: _fontSize * 0.7,
              color: _textColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: 0.07,
              minHeight: 5,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFD8B56A)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'الصفحة ٤٢ / ٦٠٤',
            style: TextStyle(
              fontSize: _fontSize * 0.6,
              color: _textColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasbihPreview(ThemeData theme) {
    return Container(
      key: const ValueKey('tasbih'),
      width: 140,
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _bgColor,
            Color.lerp(_bgColor, Colors.black, 0.3)!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _textColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'سبحان الله',
            style: TextStyle(
              fontSize: _fontSize * 0.85,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD8B56A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '٢٣',
            style: TextStyle(
              fontSize: _fontSize * 1.6,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          Text(
            '/ ٣٣',
            style: TextStyle(
              fontSize: _fontSize * 0.65,
              color: _textColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 6),
          Container(height: 0.5, color: _textColor.withValues(alpha: 0.2)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: _textColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text('＋', style: TextStyle(color: _textColor, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: _textColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _textColor.withValues(alpha: 0.15)),
                  ),
                  alignment: Alignment.center,
                  child: Text('↺', style: TextStyle(color: _textColor.withValues(alpha: 0.6), fontSize: 14)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardPreview(ThemeData theme) {
    return Container(
      key: const ValueKey('dashboard'),
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _bgColor,
            Color.lerp(_bgColor, Colors.black, 0.3)!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _textColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                '☪ رفيق',
                style: TextStyle(
                  fontSize: _fontSize * 0.9,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD8B56A),
                ),
              ),
              const Spacer(),
              Text(
                '١٥ محرم ١٤٤٧',
                style: TextStyle(
                  fontSize: _fontSize * 0.6,
                  color: _textColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          Container(height: 0.5, color: _textColor.withValues(alpha: 0.15), margin: const EdgeInsets.symmetric(vertical: 4)),
          // Prayer grid
          Row(
            children: [
              _prayerMini('الفجر', '٤:٣٠', _textColor),
              _prayerMini('الظهر', '١٢:٣٠', _textColor),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              _prayerMini('العصر', '٤:٠٠', _textColor),
              _prayerMini('المغرب', '٧:١٥', _textColor),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              _prayerMini('العشاء', '٨:٤٥', _textColor),
              const Spacer(),
            ],
          ),
          Container(height: 0.5, color: _textColor.withValues(alpha: 0.15), margin: const EdgeInsets.symmetric(vertical: 4)),
          // Quran
          Row(
            children: [
              Text('📖 ', style: TextStyle(fontSize: _fontSize * 0.7)),
              Text(
                'سورة البقرة - الآية ٢٥٥',
                style: TextStyle(fontSize: _fontSize * 0.65, color: _textColor),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: 0.07,
              minHeight: 3,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFD8B56A)),
            ),
          ),
          Container(height: 0.5, color: _textColor.withValues(alpha: 0.15), margin: const EdgeInsets.symmetric(vertical: 4)),
          // Tasbih
          Row(
            children: [
              Text('📿 ', style: TextStyle(fontSize: _fontSize * 0.7)),
              Text(
                'سبحان الله',
                style: TextStyle(
                  fontSize: _fontSize * 0.7,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD8B56A),
                ),
              ),
              const Spacer(),
              Text(
                '٢٣ / ٣٣',
                style: TextStyle(fontSize: _fontSize * 0.65, color: _textColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: _textColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '＋ تسبيحة',
                    style: TextStyle(color: _textColor, fontSize: _fontSize * 0.55),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: _textColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _textColor.withValues(alpha: 0.15)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '↺ جديد',
                    style: TextStyle(
                      color: _textColor.withValues(alpha: 0.6),
                      fontSize: _fontSize * 0.55,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(
    Color currentColor,
    Function(Color) onChanged,
    ThemeData theme,
  ) {
    final colors = [
      const Color(0xFF0A1946),
      const Color(0xFF050B24),
      const Color(0xFF0B2C6B),
      const Color(0xFF1A1A2E),
      const Color(0xFFD8B56A),
      const Color(0xFFC9A84C),
      const Color(0xFF2ECC71),
      const Color(0xFFF8F8F8),
      const Color(0xFF212121),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: colors.map((color) {
        final isSelected = currentColor.toARGB32() == color.toARGB32();
        return GestureDetector(
          onTap: () => onChanged(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                    size: 20,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  void _saveSettings() {
    ref.read(settingsNotifierProvider.notifier).updateWidgetColors(
          _bgColor.toARGB32(),
          _textColor.toARGB32(),
        );
    ref.read(settingsNotifierProvider.notifier).updateWidgetTransparency(_transparency);
    ref.read(settingsNotifierProvider.notifier).updateWidgetFontSize(_fontSize);

    HomeWidgetService.updateWidgetAppearance(
      bgColor: _bgColor.toARGB32(),
      textColor: _textColor.toARGB32(),
      fontSize: _fontSize,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ الإعدادات وتحديث الودجت'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showInstructions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'كيف تضيف الودجت',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _instructionStep(context, '١', 'اضطغط مطولاً على الشاشة في أي مكان فارغ'),
              _instructionStep(context, '٢', 'اختر "الودجت" أو "Widgets" من القائمة'),
              _instructionStep(context, '٣', 'ابحث عن "رفيق" في قائمة الودجت'),
              _instructionStep(context, '٤', 'اختر نوع الودجت المناسب واسحبه للشاشة'),
              _instructionStep(context, '٥', 'سيتم تحديث الودجت تلقائياً عند فتح التطبيق'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'يمكنك تغيير ألوان الودجت من هذه الشاشة. اضغط "حفظ" لتطبيق التغييرات.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
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

  Widget _instructionStep(BuildContext context, String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WidgetType {
  final String label;
  final IconData icon;
  final String size;
  const _WidgetType(this.label, this.icon, this.size);
}
