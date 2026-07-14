import 'package:flutter/material.dart';

enum TimeFormat { hour24, hour12 }

enum NumeralSystem { english, arabic }

class TimeFormatter {
  TimeFormatter._();

  static const _arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  static String convertDigits(String input, NumeralSystem system) {
    if (system == NumeralSystem.english) return input;
    return input.split('').map((c) {
      final d = int.tryParse(c);
      return d != null ? _arabicDigits[d] : c;
    }).join();
  }

  static String formatTime(
    DateTime? time, {
    TimeFormat format = TimeFormat.hour24,
    NumeralSystem numerals = NumeralSystem.english,
    String locale = 'ar',
    bool showSeconds = false,
  }) {
    if (time == null) return '--:--';
    final h = time.hour;
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');

    if (format == TimeFormat.hour24) {
      final hh = h.toString().padLeft(2, '0');
      final base = '$hh:$m';
      if (showSeconds) return convertDigits('$base:$s', numerals);
      return convertDigits(base, numerals);
    }

    final isArabic = locale.startsWith('ar');
    final period = h >= 12 ? (isArabic ? 'م' : 'PM') : (isArabic ? 'ص' : 'AM');
    final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    final hh = h12.toString().padLeft(2, '0');
    final base = '$hh:$m';
    if (showSeconds) return '${convertDigits('$base:$s', numerals)} $period';
    return '${convertDigits(base, numerals)} $period';
  }

  static String formatTimeHMS(
    DateTime? time, {
    TimeFormat format = TimeFormat.hour24,
    NumeralSystem numerals = NumeralSystem.english,
    String locale = 'ar',
  }) {
    return formatTime(
      time,
      format: format,
      numerals: numerals,
      locale: locale,
      showSeconds: true,
    );
  }

  static String formatDuration(
    Duration d, {
    NumeralSystem numerals = NumeralSystem.english,
    bool showHoursWhenZero = false,
  }) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');

    if (hours > 0 || showHoursWhenZero) {
      final hh = hours.toString().padLeft(2, '0');
      return convertDigits('$hh:$mm:$ss', numerals);
    }
    return convertDigits('$mm:$ss', numerals);
  }

  static String formatCountdown(
    Duration d, {
    NumeralSystem numerals = NumeralSystem.english,
  }) {
    return formatDuration(
      d,
      numerals: numerals,
      showHoursWhenZero: d.inHours > 0,
    );
  }

  static String formatRemaining(
    Duration d, {
    NumeralSystem numerals = NumeralSystem.english,
  }) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      return convertDigits('$hours:$mm', numerals);
    }
    return convertDigits('$minutes:$ss', numerals);
  }

  static Widget timeText(
    String text, {
    required TextStyle style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
