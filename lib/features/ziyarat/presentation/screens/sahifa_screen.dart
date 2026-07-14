import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/star_background.dart';
import '../providers/ziyarat_providers.dart';
import '../widgets/ziyarat_card.dart';
import 'content_detail_screen.dart';

class SahifaScreen extends ConsumerWidget {
  const SahifaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sahifa = ref.watch(sahifaListProvider);

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
                      'الصحيفة السجادية',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 22, fontWeight: FontWeight.w800,
                        color: AppTheme.goldPrimary,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'كلمات الإمام زين العابدين عليه السلام من أدعية ومناجاة',
                  style: GoogleFonts.notoKufiArabic(fontSize: 13, color: AppTheme.textMuted),
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: sahifa.when(
                  data: (list) => ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final item = list[i];
                      return ContentCard(
                        title: item.title,
                        subtitle: 'الدعاء رقم ${item.number}',
                        icon: Icons.menu_book_rounded,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => ContentDetailScreen(
                              id: 'sahifa_${item.number}',
                              type: 'sahifa',
                              title: item.title,
                              fullText: item.fullText,
                              source: 'الصحيفة السجادية',
                              estimatedMinutes: item.estimatedMinutes,
                              sectionCount: 1,
                            ),
                          ));
                        },
                      );
                    },
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
}
