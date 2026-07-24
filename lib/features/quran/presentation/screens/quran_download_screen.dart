import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../theme/app_theme.dart';
import '../../../../services/storage_service.dart';
import '../../providers/quran_page_providers.dart';

/// Minimal download screen shown briefly on first launch.
///
/// Shows a pulsing Quran icon while the first pages download in background.
/// Navigation to [nextRoute] happens immediately — the download continues
/// silently via [QuranPageStreamer].
class QuranDownloadScreen extends ConsumerStatefulWidget {
  final String nextRoute;

  const QuranDownloadScreen({super.key, this.nextRoute = '/home'});

  @override
  ConsumerState<QuranDownloadScreen> createState() =>
      _QuranDownloadScreenState();
}

class _QuranDownloadScreenState extends ConsumerState<QuranDownloadScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _navigated = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Initialize the streamer and start background download.
    ref.read(quranStreamerInitProvider);
    startBackgroundDownload(ref);

    // Navigate immediately — no waiting for download.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateHome();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _connectivitySub?.cancel();
    super.dispose();
  }

  void _navigateHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    StorageService.setQuranDownloadCompleted(true);
    context.go(widget.nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.navyDeep,
                AppTheme.bgPrimary,
                Color(0xFF060E1F),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                _buildQuranIcon(),
                const SizedBox(height: 32),
                _buildTitle(),
                const SizedBox(height: 12),
                _buildSubtitle(),
                const Spacer(flex: 2),
                _buildLoadingIndicator(),
                const SizedBox(height: 32),
                _buildFooter(),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuranIcon() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _pulseAnimation.value,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.menu_book_rounded,
                size: 48,
                color: AppTheme.goldPrimary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Text(
      'القرآن الكريم',
      style: GoogleFonts.notoKufiArabic(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'يتم التحميل في الخلفية...',
      style: GoogleFonts.notoKufiArabic(
        fontSize: 14,
        color: AppTheme.textMutedPremium,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            'يمكنك البدء في القراءة فوراً',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 120,
            height: 3,
            child: LinearProgressIndicator(
              backgroundColor: AppTheme.bgSurface,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.goldPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.goldPrimary,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'تحميل الصفحات...',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              color: AppTheme.textMutedPremium,
            ),
          ),
        ],
      ),
    );
  }
}
