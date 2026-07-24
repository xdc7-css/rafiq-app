import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/mercy_register_providers.dart';
import '../../data/models/memorial.dart';

/// Normalizes Arabic text for comparison:
/// - Trims whitespace
/// - Collapses multiple spaces into one
/// - Removes Arabic diacritics (tatweel, harakat)
/// - Converts to lower case for case‑insensitive comparison
String normalizeArabic(String input) {
  final trimmed = input.trim();
  final singleSpaced = trimmed.replaceAll(RegExp(r'\s+'), ' ');
  // Remove Arabic diacritics and tatweel
  final cleaned = singleSpaced.replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED\u0640]'), '');
  return cleaned.toLowerCase();
}

/// Checks whether a memorial name already exists for the current user.
Future<bool> isDuplicateMemorialName(WidgetRef ref, String name) async {
  final memorials = ref.read(memorialsProvider);
  final normalizedSearch = normalizeArabic(name);
  for (final Memorial m in memorials) {
    if (normalizeArabic(m.deceasedName) == normalizedSearch) {
      return true;
    }
  }
  return false;
}
