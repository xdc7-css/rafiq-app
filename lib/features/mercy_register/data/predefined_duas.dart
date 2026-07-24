import 'package:flutter/material.dart';

class DuaOption {
  final IconData icon;
  final String title;
  final String preview;
  final String category;
  const DuaOption({required this.icon, required this.title, required this.preview, required this.category});
}

// Default quick dua options (used on the main form) and full list for bottom sheet.
const List<DuaOption> kQuickDuaOptions = [
  DuaOption(
    icon: Icons.flight_outlined,
    title: 'اللهم اغفر له وارحمه',
    preview: 'اللهم اغفر له وارحمه',
    category: 'الدعاء',
  ),
  DuaOption(
    icon: Icons.nature_outlined,
    title: 'اللهم اجعل قبره روضة من رياض الجنة',
    preview: 'اللهم اجعل قبره روضة من رياض الجنة',
    category: 'الزيارة',
  ),
  DuaOption(
    icon: Icons.book_outlined,
    title: 'إهداء ثواب القرآن الكريم',
    preview: 'إهداء ثواب القرآن الكريم',
    category: 'القرآن الكريم',
  ),
  DuaOption(
    icon: Icons.favorite_border,
    title: 'إهداء الدعاء',
    preview: 'إهداء الدعاء',
    category: 'الدعاء',
  ),
  DuaOption(
    icon: Icons.auto_awesome_outlined,
    title: 'إهداء التسبيح',
    preview: 'إهداء التسبيح',
    category: 'التسبيح',
  ),
  DuaOption(
    icon: Icons.star_outline,
    title: 'اللهم اجمعنا به في الفردوس الأعلى',
    preview: 'اللهم اججمعنا به في الفردوس الأعلى',
    category: 'الرحمة',
  ),
];

// Full list for the bottom sheet, grouped by categories.
const List<DuaOption> kAllDuaOptions = [
  ...kQuickDuaOptions,
  // Additional examples – in a real app these would be exhaustive.
  DuaOption(
    icon: Icons.book_outlined,
    title: 'قراءة القرآن',
    preview: 'اللهم اجعلنا من قرّاء القرآن',
    category: 'القرآن الكريم',
  ),
  DuaOption(
    icon: Icons.volunteer_activism_outlined,
    title: 'طلب الرحمة',
    preview: 'اللهم إنا نسألك الرحمة',
    category: 'الدعاء',
  ),
  DuaOption(
    icon: Icons.access_time_outlined,
    title: 'سبحان الله',
    preview: 'سبحان الله',
    category: 'التسبيح',
  ),
  DuaOption(
    icon: Icons.place_outlined,
    title: 'زيارة المقبرة',
    preview: 'اللهم اجعل زيارة القبور مغفرة',
    category: 'الزيارة',
  ),
  DuaOption(
    icon: Icons.favorite_border,
    title: 'رحمة للمتوفى',
    preview: 'اللهم ارحم موتانا',
    category: 'الرحمة',
  ),
  DuaOption(
    icon: Icons.nights_stay_outlined,
    title: 'ختم القرآن',
    preview: 'اللهم ثبتنا على ختم القرآن',
    category: 'الختمات',
  ),
];
