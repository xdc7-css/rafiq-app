import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/settings_provider.dart';
import '../../../services/time_formatter.dart';

class PrayerCountdown extends ConsumerWidget {
  final Duration? duration;
  final TextStyle? style;
  final VoidCallback? onFinished;

  const PrayerCountdown({
    super.key,
    this.duration,
    this.style,
    this.onFinished,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final numerals = settings.numeralSystem;
    final d = duration;

    if (d == null || d.isNegative) {
      return Text(
        TimeFormatter.formatDuration(Duration.zero, numerals: numerals),
        style: style ?? Theme.of(context).textTheme.headlineMedium,
      );
    }

    if (d.inSeconds <= 0) {
      onFinished?.call();
    }

    return Text(
      TimeFormatter.formatCountdown(d, numerals: numerals),
      style: style,
    );
  }
}
