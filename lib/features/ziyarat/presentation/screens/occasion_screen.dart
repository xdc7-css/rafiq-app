import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/star_background.dart';
import '../providers/ziyarat_providers.dart';
import '../widgets/ziyarat_card.dart';
import 'occasion_detail_screen.dart';

class OccasionScreen extends ConsumerWidget {
  const OccasionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final occasions = ref.watch(occasionsListProvider);

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
                      'المناسبات الإسلامية',
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
                child: occasions.when(
                  data: (list) => ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final occasion = list[i];
                      return ContentCard(
                        title: occasion.title,
                        subtitle: occasion.dateHijri,
                        icon: Icons.event_rounded,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => OccasionDetailScreen(occasion: occasion),
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
