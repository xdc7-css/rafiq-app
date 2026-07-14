import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/star_background.dart';
import '../providers/ziyarat_providers.dart';
import 'content_detail_screen.dart';

class MafatihScreen extends ConsumerWidget {
  const MafatihScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mafatih = ref.watch(mafatihListProvider);

    return Scaffold(
      body: IslamicBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_forward_rounded, color: AppTheme.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      'مفاتيح الجنان',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 22, fontWeight: FontWeight.w800,
                        color: AppTheme.goldPrimary,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: mafatih.when(
                  data: (sections) => ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    children: sections.map((section) {
                      return _SectionCard(
                        title: section.title,
                        type: _typeLabel(section.type),
                        itemCount: section.items.length,
                        items: section.items,
                      );
                    }).toList(),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'adiyah': return 'أدعية';
      case 'ziyarat': return 'زيارات';
      case 'amal_yawmi': return 'أعمال يومية';
      case 'amal_munasabat': return 'أعمال المناسبات';
      default: return type;
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String type;
  final int itemCount;
  final List items;

  const _SectionCard({
    required this.title,
    required this.type,
    required this.itemCount,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.bgCard.withValues(alpha: 0.9),
            AppTheme.bgSurface.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: AppTheme.goldPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$itemCount',
                style: GoogleFonts.notoKufiArabic(fontSize: 11, color: AppTheme.goldPrimary),
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              type,
              style: GoogleFonts.notoKufiArabic(fontSize: 12, color: AppTheme.textMuted),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        children: items.map<Widget>((item) {
          return ListTile(
            dense: true,
            title: Text(
              item.title,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 14, color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textDirection: TextDirection.rtl,
            ),
            trailing: Icon(Icons.arrow_back_ios_new_rounded,
                size: 14, color: AppTheme.textMuted),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => _MafatihItemScreen(item: item, sectionTitle: title),
              ));
            },
          );
        }).toList(),
      ),
    );
  }
}

class _MafatihItemScreen extends StatelessWidget {
  final item;
  final String sectionTitle;

  const _MafatihItemScreen({required this.item, required this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    return ContentDetailScreen(
      id: item.id,
      type: 'mafatih',
      title: item.title,
      fullText: item.fullText,
      source: item.source ?? sectionTitle,
      estimatedMinutes: 4,
      sectionCount: 1,
    );
  }
}
