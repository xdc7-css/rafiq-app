import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_theme.dart';
import '../providers/audio_provider.dart';

class ReadingModeToggle extends ConsumerWidget {
  const ReadingModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(readingModeProvider);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ReadingMode.values.map((mode) {
          final isActive = current == mode;
          final icon = _iconFor(mode);
          return GestureDetector(
            onTap: () => ref.read(readingModeProvider.notifier).state = mode,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.goldPrimary.withValues(alpha: 0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20,
                color: isActive ? AppTheme.goldPrimary : AppTheme.textMuted),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _iconFor(ReadingMode mode) {
    switch (mode) {
      case ReadingMode.normal:
        return Icons.light_mode_rounded;
      case ReadingMode.night:
        return Icons.dark_mode_rounded;
      case ReadingMode.focus:
        return Icons.center_focus_strong_rounded;
      case ReadingMode.large:
        return Icons.text_fields_rounded;
    }
  }
}
