import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';

/// Shows a premium success notification overlay that auto-dismisses.
/// Returns a Future that completes when the notification is dismissed.
Future<void> showPremiumSuccess(BuildContext context, {required String message}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  final completer = Completer<void>();

  entry = OverlayEntry(
    builder: (_) => _PremiumSuccessOverlay(
      message: message,
      onDismiss: () {
        entry.remove();
        if (!completer.isCompleted) completer.complete();
      },
    ),
  );

  overlay.insert(entry);
  return completer.future;
}

class _PremiumSuccessOverlay extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;

  const _PremiumSuccessOverlay({
    required this.message,
    required this.onDismiss,
  });

  @override
  State<_PremiumSuccessOverlay> createState() =>
      _PremiumSuccessOverlayState();
}

class _PremiumSuccessOverlayState extends State<_PremiumSuccessOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
    _dismissTimer = Timer(const Duration(milliseconds: 2200), _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + 16;

    return Positioned(
      top: top,
      left: 20,
      right: 20,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF11264E),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                    blurRadius: 16,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.goldPrimary.withValues(alpha: 0.15),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 22,
                      color: Color(0xFFD8A83A),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
