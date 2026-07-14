import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

// ─── Premium Glass Card ───
class GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;
  final Color? borderColor;
  final double borderWidth;
  final bool glowing;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.radius = 28,
    this.padding = const EdgeInsets.all(24),
    this.margin,
    this.gradient,
    this.shadows,
    this.borderColor,
    this.borderWidth = 0.5,
    this.glowing = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? AppTheme.borderGold,
          width: borderWidth,
        ),
        boxShadow: shadows ?? [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: AppTheme.shadowGold,
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
          if (glowing)
            BoxShadow(
              color: AppTheme.goldPrimary.withValues(alpha: 0.15),
              blurRadius: 40,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/whitebg.PNG'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient ?? LinearGradient(
                  colors: [
                    AppTheme.bgCard.withValues(alpha: 0.05),
                    AppTheme.bgCard.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          splashColor: AppTheme.goldPrimary.withValues(alpha: 0.05),
          highlightColor: AppTheme.goldPrimary.withValues(alpha: 0.03),
          child: card,
        ),
      );
    }

    return card;
  }
}

// ─── Glass Card Without Blur (for lists) ───
class SimpleGlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const SimpleGlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.radius = 24,
    this.padding = const EdgeInsets.all(20),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      decoration: AppTheme.glassCard(radius: radius),
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          splashColor: AppTheme.goldPrimary.withValues(alpha: 0.05),
          child: card,
        ),
      );
    }

    return card;
  }
}

// ─── Gold Button ───
class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool outlined;
  final double radius;
  final double height;

  const GoldButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.outlined = false,
    this.radius = 18,
    this.height = 48,
  });

  static final _outlinedStyle = ButtonStyle(
    minimumSize: WidgetStateProperty.all(const Size(0, 48)),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 24),
    ),
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    elevation: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.hovered)) return 4.0;
      if (states.contains(WidgetState.pressed)) return 2.0;
      return 0.0;
    }),
    side: WidgetStateProperty.resolveWith((states) {
      final alpha = states.contains(WidgetState.hovered) ? 0.8 : 0.5;
      final width = states.contains(WidgetState.hovered) ? 1.2 : 1.0;
      return BorderSide(
        color: AppTheme.goldPrimary.withValues(alpha: alpha),
        width: width,
      );
    }),
    shape: WidgetStateProperty.all(
      const StadiumBorder(),
    ),
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return AppTheme.goldPrimary.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.hovered)) {
        return AppTheme.goldPrimary.withValues(alpha: 0.06);
      }
      return Colors.transparent;
    }),
    shadowColor: WidgetStateProperty.all(
      AppTheme.goldPrimary.withValues(alpha: 0.15),
    ),
    mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
    animationDuration: const Duration(milliseconds: 200),
  );

  Widget _buildLabel({Color? color}) {
    final textColor = color ?? const Color(0xFFF6D77A);
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      );
    }
    return Text(
      label,
      style: GoogleFonts.notoKufiArabic(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final responsiveHeight = height * (w < 360 ? 0.88 : w < 420 ? 1.0 : 1.04);
    if (outlined) {
      return SizedBox(
        height: responsiveHeight,
        child: OutlinedButton(
          onPressed: onTap,
          style: _outlinedStyle.copyWith(
            minimumSize: WidgetStateProperty.all(Size(0, responsiveHeight)),
          ),
          child: _buildLabel(),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: responsiveHeight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          gradient: AppTheme.goldGradient,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: AppTheme.bgPrimary),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.bgPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Gold Badge ───
class GoldBadge extends StatelessWidget {
  final String text;
  final IconData? icon;
  final double fontSize;
  final Color? color;

  const GoldBadge({
    super.key,
    required this.text,
    this.icon,
    this.fontSize = 11,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (color ?? AppTheme.goldPrimary).withValues(alpha: 0.15),
            (color ?? AppTheme.goldPrimary).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (color ?? AppTheme.goldPrimary).withValues(alpha: 0.12),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color ?? AppTheme.goldPrimary),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: GoogleFonts.notoKufiArabic(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: color ?? AppTheme.goldPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Divider with Gold Accent ───
class GoldSectionDivider extends StatelessWidget {
  final String? label;
  const GoldSectionDivider({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          if (label != null)
            Text(
              label!,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppTheme.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Stat Display ───
class StatDisplay extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const StatDisplay({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.goldPrimary, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Quick Action Icon ───
class QuickActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickActionIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final iconSize = w < 360 ? 42.0 : w < 420 ? 48.0 : 54.0;
    final iconInnerSize = w < 360 ? 18.0 : 22.0;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.glassDark,
                  AppTheme.glassLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.borderGold,
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowDark,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppTheme.goldPrimary.withValues(alpha: 0.8), size: iconInnerSize),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Premium Circular Progress ───
class GoldCircularProgress extends StatelessWidget {
  final double value;
  final double size;
  final double strokeWidth;
  final String? centerText;
  final String? subtitle;

  const GoldCircularProgress({
    super.key,
    required this.value,
    this.size = 140,
    this.strokeWidth = 10,
    this.centerText,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: strokeWidth,
              backgroundColor: AppTheme.goldPrimary.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation(AppTheme.goldPrimary),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (centerText != null)
                Text(
                  centerText!,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: size * 0.22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 11,
                    color: AppTheme.goldPrimary.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Page Header ───
class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final double bottomPadding;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.bottomPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final titleSize = w < 360 ? 20.0 : w < 420 ? 22.0 : 24.0;
    final barWidth = w < 360 ? 3.0 : 4.0;
    final barHeight = w < 360 ? 22.0 : 28.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(w < 360 ? 16 : 20, 8, w < 360 ? 16 : 20, bottomPadding),
      child: Row(
        children: [
          Container(
            width: barWidth,
            height: barHeight,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─── Icon Button Container ───
class GoldIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color? color;

  const GoldIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 36,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final s = w < 360 ? size * 0.85 : size;
    return IconButton(
      onPressed: onTap,
      iconSize: s * 0.5,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tight(Size(s, s)),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          final alpha = states.contains(WidgetState.hovered) ? 0.8 : 0.5;
          final width = states.contains(WidgetState.hovered) ? 1.2 : 1.0;
          return BorderSide(
            color: AppTheme.goldPrimary.withValues(alpha: alpha),
            width: width,
          );
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppTheme.goldPrimary.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppTheme.goldPrimary.withValues(alpha: 0.06);
          }
          return Colors.transparent;
        }),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) return 4.0;
          if (states.contains(WidgetState.pressed)) return 2.0;
          return 0.0;
        }),
        shadowColor: WidgetStateProperty.all(
          AppTheme.goldPrimary.withValues(alpha: 0.15),
        ),
        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        animationDuration: const Duration(milliseconds: 200),
      ),
      icon: Icon(
        icon,
        color: color ?? const Color(0xFFF6D77A),
      ),
    );
  }
}

// ─── Empty State ───
class IslamicEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const IslamicEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final iconBoxSize = w < 360 ? 80.0 : w < 420 ? 90.0 : 100.0;
    final iconSize = w < 360 ? 36.0 : w < 420 ? 40.0 : 44.0;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(w < 360 ? 24 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: iconBoxSize,
              height: iconBoxSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.goldPrimary.withValues(alpha: 0.1),
                    AppTheme.goldPrimary.withValues(alpha: 0.03),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppTheme.borderGold,
                  width: 0.5,
                ),
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: AppTheme.goldPrimary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.notoKufiArabic(
                fontSize: w < 360 ? 17 : 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              GoldButton(
                label: actionLabel!,
                onTap: onAction!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Loading Shimmer ───
class IslamicShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const IslamicShimmer({
    super.key,
    this.height = 20,
    this.width = double.infinity,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppTheme.borderColor, width: 0.5),
      ),
    );
  }
}

// ─── Loading Skeleton Card ───
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: AppTheme.glassCard(radius: 28),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          IslamicShimmer(width: 100, height: 14),
          SizedBox(height: 12),
          IslamicShimmer(width: 60, height: 2),
          SizedBox(height: 16),
          IslamicShimmer(height: 16),
          SizedBox(height: 8),
          IslamicShimmer(width: 200, height: 16),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IslamicShimmer(width: 80, height: 12),
              IslamicShimmer(width: 100, height: 24, radius: 10),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Sheet Template ───
class IslamicBottomSheet extends StatelessWidget {
  final Widget child;
  final double initialSize;
  final double maxSize;

  const IslamicBottomSheet({
    super.key,
    required this.child,
    this.initialSize = 0.5,
    this.maxSize = 0.85,
  });

  static void show(BuildContext context, Widget child, {double initial = 0.5}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => IslamicBottomSheet(initialSize: initial, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialSize,
      minChildSize: 0.3,
      maxChildSize: maxSize,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.bgSurface.withValues(alpha: 0.95),
              border: Border(
                top: BorderSide(
                  color: AppTheme.borderGold,
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [child],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Dialog Template ───
class IslamicDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String? confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final bool destructive;

  const IslamicDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.confirmLabel,
    this.cancelLabel,
    this.onConfirm,
    this.destructive = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? message,
    Widget? content,
    String? confirmLabel,
    String? cancelLabel,
    VoidCallback? onConfirm,
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => IslamicDialog(
        title: title,
        message: message,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        destructive: destructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.bgSurface.withValues(alpha: 0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: AppTheme.borderGold, width: 0.5),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 13,
                color: AppTheme.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (content != null) content!,
        ],
      ),
      actions: [
        Row(
          children: [
            if (cancelLabel != null)
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    cancelLabel!,
                    style: GoogleFonts.notoKufiArabic(
                      color: AppTheme.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (confirmLabel != null)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onConfirm?.call();
                    Navigator.pop(context, true);
                  },
                  style: destructive
                      ? ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCF6679),
                        )
                      : null,
                  child: Text(confirmLabel!),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
