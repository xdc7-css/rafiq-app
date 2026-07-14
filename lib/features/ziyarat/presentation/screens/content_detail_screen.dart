import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/star_background.dart';
import '../../../../widgets/islamic_art.dart';
import '../providers/audio_provider.dart';
import '../providers/bookmark_provider.dart';
import '../widgets/audio_controls.dart';
import '../widgets/reading_mode_toggle.dart';

class ContentDetailScreen extends ConsumerStatefulWidget {
  final String id;
  final String type;
  final String title;
  final String fullText;
  final String source;
  final int estimatedMinutes;
  final int sectionCount;

  const ContentDetailScreen({
    super.key,
    required this.id,
    required this.type,
    required this.title,
    required this.fullText,
    required this.source,
    this.estimatedMinutes = 5,
    this.sectionCount = 1,
  });

  @override
  ConsumerState<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends ConsumerState<ContentDetailScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _floatController;
  bool _showAudioBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final readingMode = ref.watch(readingModeProvider);
    final isBookmarked = ref.watch(isBookmarkedProvider(widget.id));

    return Scaffold(
      body: IslamicBackground(
        child: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 160,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.bgPrimary.withValues(alpha: 0.9),
                              AppTheme.bgSecondary.withValues(alpha: 0.5),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(w < 360 ? 16 : 20, 50, w < 360 ? 16 : 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward_rounded,
                                        color: AppTheme.textPrimary),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  const Spacer(),
                                  Text(
                                    widget.estimatedMinutes <= 10 ? 'مختصر' : 'طويل',
                                    style: GoogleFonts.notoKufiArabic(
                                      fontSize: 11,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${widget.estimatedMinutes} دقيقة',
                                      style: GoogleFonts.notoKufiArabic(
                                        fontSize: 11,
                                        color: AppTheme.goldPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.title,
                                    style: GoogleFonts.notoKufiArabic(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.goldPrimary,
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 28, height: 28,
                                    child: IslamicStar(
                                      size: 28,
                                      color: AppTheme.goldPrimary.withValues(alpha: 0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    leading: const SizedBox.shrink(),
                  ),
                  SliverToBoxAdapter(
                    child: _buildActionBar(isBookmarked),
                  ),
                  SliverToBoxAdapter(
                    child: _buildSourceBadge(),
                  ),
                  SliverToBoxAdapter(
                    child: _buildDivider(),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w < 360 ? 16 : 20),
                      child: _buildReadingModeContent(readingMode),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(w < 360 ? 16 : 20, 8, w < 360 ? 16 : 20, 100),
                      child: _buildSourceFooter(),
                    ),
                  ),
                ],
              ),
              if (_showAudioBar)
                Positioned(
                  left: w < 360 ? 16.0 : 20.0,
                  right: w < 360 ? 16.0 : 20.0,
                  bottom: 20,
                  child: AudioControls(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionBar(bool isBookmarked) {
    final w = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w < 360 ? 16 : 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ReadingModeToggle(),
          const Spacer(),
          Flexible(
            child: _ActionChip(
              icon: _showAudioBar ? Icons.music_note : Icons.music_note_outlined,
              label: 'الصوت',
              isActive: _showAudioBar,
              onTap: () => setState(() => _showAudioBar = !_showAudioBar),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: _ActionChip(
              icon: Icons.copy_rounded,
              label: 'نسخ',
              onTap: _copyText,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: _ActionChip(
              icon: Icons.share_rounded,
              label: 'مشاركة',
              onTap: _shareText,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: _ActionChip(
              icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
              label: isBookmarked ? 'محفوظ' : 'حفظ',
              isActive: isBookmarked,
              onTap: () => _toggleBookmark(isBookmarked),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceBadge() {
    final w = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w < 360 ? 16 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.bgSurface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.source_rounded, size: 14, color: AppTheme.textMuted),
                const SizedBox(width: 6),
                Text(
                  'المصدر: ${widget.source}',
                  style: GoogleFonts.notoKufiArabic(fontSize: 12, color: AppTheme.textMuted),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    final w = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w < 360 ? 16 : 20, vertical: 12),
      child: Container(height: 1, decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.goldPrimary.withValues(alpha: 0.3),
            AppTheme.goldPrimary.withValues(alpha: 0.05),
            Colors.transparent,
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      )),
    );
  }

  Widget _buildReadingModeContent(ReadingMode mode) {
    double fontSize;
    Color textColor;
    double height;

    switch (mode) {
      case ReadingMode.normal:
        fontSize = 22;
        textColor = AppTheme.textPrimary;
        height = 1.9;
      case ReadingMode.night:
        fontSize = 22;
        textColor = const Color(0xFFB0BEC5);
        height = 1.9;
      case ReadingMode.focus:
        fontSize = 24;
        textColor = AppTheme.goldSoft;
        height = 2.2;
      case ReadingMode.large:
        fontSize = 28;
        textColor = AppTheme.textPrimary;
        height = 2.0;
    }

    final bg = mode == ReadingMode.night
        ? AppTheme.bgPrimary.withValues(alpha: 0.7)
        : Colors.transparent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        widget.fullText,
        style: GoogleFonts.notoNaskhArabic(
          fontSize: fontSize,
          color: textColor,
          height: height,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildSourceFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderGold.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              widget.source,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 13,
                color: AppTheme.goldPrimary.withValues(alpha: 0.8),
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.source_rounded, size: 16, color: AppTheme.goldPrimary.withValues(alpha: 0.6)),
        ],
      ),
    );
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: widget.fullText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ النص', textDirection: TextDirection.rtl),
        backgroundColor: AppTheme.goldPrimary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareText() {
    Share.share('${widget.title}\n\n${widget.fullText}\n\n- ${widget.source}');
  }

  void _toggleBookmark(bool isBookmarked) {
    final notifier = ref.read(bookmarkProvider.notifier);
    if (isBookmarked) {
      final bookmark = ref.read(bookmarkProvider).firstWhere(
        (b) => b.contentId == widget.id,
      );
      notifier.removeBookmark(bookmark.id);
    } else {
      notifier.addBookmark(widget.id, widget.type, widget.title);
    }
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.goldPrimary.withValues(alpha: 0.15)
              : AppTheme.bgSurface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive
                ? AppTheme.goldPrimary.withValues(alpha: 0.3)
                : AppTheme.borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 11,
                color: isActive ? AppTheme.goldPrimary : AppTheme.textMuted,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(width: 4),
            Icon(icon, size: 16,
                color: isActive ? AppTheme.goldPrimary : AppTheme.textMuted),
          ],
        ),
      ),
    );
  }
}
