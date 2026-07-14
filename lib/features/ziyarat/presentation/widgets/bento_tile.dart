import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../theme/app_theme.dart';

class BentoTile extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? heroTag;
  final double height;
  final Gradient? gradient;
  final DecorationImage? backgroundImage;
  final Color? accentColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final Duration entranceDelay;

  const BentoTile({
    super.key,
    required this.child,
    this.onTap,
    this.heroTag,
    this.height = 160,
    this.gradient,
    this.backgroundImage,
    this.accentColor,
    this.borderColor,
    this.borderRadius = 24,
    this.margin,
    this.padding = const EdgeInsets.all(20),
    this.entranceDelay = Duration.zero,
  });

  @override
  State<BentoTile> createState() => _BentoTileState();
}

class _BentoTileState extends State<BentoTile>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _entranceController;
  late Animation<double> _scaleAnim;
  late Animation<double> _shadowAnim;
  late Animation<double> _fadeSlide;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 280),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.965).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );
    _shadowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeSlide = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    if (widget.entranceDelay == Duration.zero) {
      _entranceController.forward();
    } else {
      Future.delayed(widget.entranceDelay, () {
        if (mounted) _entranceController.forward();
      });
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tile = AnimatedBuilder(
      animation: Listenable.merge([_pressController, _entranceController]),
      builder: (context, child) {
        final shadowDepth = _shadowAnim.value;
        final slide = _fadeSlide.value;
        final glow = _glowAnim.value;
        final accent = widget.accentColor ?? AppTheme.goldPrimary;

        return Transform.translate(
          offset: Offset(0, 24 * (1 - slide)),
          child: Transform.scale(
            scale: _scaleAnim.value,
            child: Opacity(
              opacity: slide,
              child: Container(
                height: widget.height,
                margin: widget.margin,
                decoration: BoxDecoration(
                  image: widget.backgroundImage,
                  gradient: widget.gradient ??
                      LinearGradient(
                        colors: [
                          AppTheme.bgCard.withValues(alpha: 0.92),
                          AppTheme.bgSurface.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    color: widget.borderColor ?? AppTheme.borderGold,
                    width: 0.6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: 0.18 + shadowDepth * 0.12),
                      blurRadius: 20 + shadowDepth * 10,
                      offset: Offset(0, 8 + shadowDepth * 4),
                      spreadRadius: -4,
                    ),
                    BoxShadow(
                      color: accent.withValues(alpha: 0.04 + glow * 0.06),
                      blurRadius: 24 + glow * 16,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap != null
                        ? () {
                            HapticFeedback.lightImpact();
                            widget.onTap!();
                          }
                        : null,
                    onTapDown: (_) => _pressController.forward(),
                    onTapUp: (_) => _pressController.reverse(),
                    onTapCancel: () => _pressController.reverse(),
                    splashColor: accent.withValues(alpha: 0.06),
                    highlightColor: accent.withValues(alpha: 0.03),
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius),
                    child: Padding(
                      padding: widget.padding,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        child: tile,
      );
    }
    return tile;
  }
}

class BentoShimmer extends StatelessWidget {
  final double height;
  final double? width;

  const BentoShimmer({
    super.key,
    this.height = 160,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            AppTheme.bgCard.withValues(alpha: 0.3),
            AppTheme.bgSurface.withValues(alpha: 0.15),
            AppTheme.bgCard.withValues(alpha: 0.3),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border.all(
          color: AppTheme.borderColor.withValues(alpha: 0.4),
          width: 0.5,
        ),
      ),
      child: const _ShimmerPulse(),
    );
  }
}

class _ShimmerPulse extends StatefulWidget {
  const _ShimmerPulse();

  @override
  State<_ShimmerPulse> createState() => _ShimmerPulseState();
}

class _ShimmerPulseState extends State<_ShimmerPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(-0.5 + 2.0 * _controller.value, 0),
              colors: [
                Colors.transparent,
                AppTheme.goldPrimary.withValues(alpha: 0.04),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
    );
  }
}
