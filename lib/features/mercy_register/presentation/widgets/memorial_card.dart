import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../data/models/memorial.dart';

class MemorialCard extends StatelessWidget {
  final Memorial memorial;
  final VoidCallback? onTap;

  const MemorialCard({
    super.key,
    required this.memorial,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.borderSubtle,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: AppTheme.goldPrimary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memorial.displayName,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        memorial.timeAgo,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.textMuted.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${memorial.prayerCount} دعوة',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 11,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
              color: AppTheme.textMuted.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
