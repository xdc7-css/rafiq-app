import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/arabic_strings.dart';
import '../../../../theme/app_theme.dart';

class FatwaSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const FatwaSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.darkGlassBlue.withValues( alpha: 0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.luxuryGold.withValues( alpha: 0.08),
              width: 0.5,
            ),
          ),
          child: TextField(
            controller: controller,
            textDirection: TextDirection.rtl,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => onSearch(),
            style: GoogleFonts.notoKufiArabic(
              color: AppTheme.warmWhite,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: Ar.fatwaSearchHint,
              hintStyle: GoogleFonts.notoKufiArabic(
                color: AppTheme.warmWhite.withValues( alpha: 0.3),
                fontSize: 15,
              ),
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: AppTheme.luxuryGold.withValues( alpha: 0.6),
                  size: 24,
                ),
                onPressed: onSearch,
              ),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: AppTheme.warmWhite.withValues( alpha: 0.4),
                        size: 20,
                      ),
                      onPressed: () {
                        controller.clear();
                        onSearch();
                      },
                    )
                  : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
