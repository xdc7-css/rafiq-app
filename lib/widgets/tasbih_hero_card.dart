import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/tasbeeh_al_zahra_provider.dart';
import '../providers/tasbeeh_stats_provider.dart';
import '../theme/app_theme.dart';

class TasbihHeroCard extends ConsumerStatefulWidget {
  const TasbihHeroCard({super.key});
  @override
  ConsumerState<TasbihHeroCard> createState() => _TasbihHeroCardState();
}

class _TasbihHeroCardState extends ConsumerState<TasbihHeroCard>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late AnimationController _tapController;
  late AnimationController _celebrateController;
  Timer? _autoResetTimer;

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      vsync: this, duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _tapController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200),
    );
    _celebrateController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2500),
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _tapController.dispose();
    _celebrateController.dispose();
    _autoResetTimer?.cancel();
    super.dispose();
  }

  void _handleTap() {
    final notifier = ref.read(tasbeehAlZahraProvider.notifier);
    final before = ref.read(tasbeehAlZahraProvider);
    if (before.isCompleted) return;

    HapticFeedback.lightImpact();
    ref.read(tasbihStatsProvider.notifier).recordTap();

    final result = notifier.increment();
    if (result['sessionFinished'] == true) {
      HapticFeedback.heavyImpact();
      _celebrateController.forward(from: 0);
      _autoResetTimer?.cancel();
      _autoResetTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          notifier.reset();
          _celebrateController.reset();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tasbeehAlZahraProvider);
    final stats = ref.watch(tasbihStatsProvider);
    final w = MediaQuery.sizeOf(context).width;
    final cardH = w < 360 ? 180.0 : w < 420 ? 200.0 : 220.0;
    final padH = w < 360 ? 14.0 : 20.0;
    final padV = w < 360 ? 10.0 : 12.0;

    return GestureDetector(
      onTap: () => context.push('/tasbeeh'),
      onLongPress: () => _showQuickSettings(),
      child: Container(
        height: cardH,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.borderGold, width: 0.5),
          boxShadow: [
            BoxShadow(color: AppTheme.shadowDark, blurRadius: 40, offset: const Offset(0, 12), spreadRadius: -8),
            BoxShadow(color: AppTheme.shadowGold, blurRadius: 30),
            BoxShadow(color: AppTheme.goldPrimary.withValues(alpha: 0.06), blurRadius: 60, spreadRadius: 4),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/whitebg.PNG',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.bgCard.withValues(alpha: 0.05),
                          AppTheme.bgCard.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(padH, padV, padH, padV),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(state, stats),
                      const SizedBox(height: 6),
                      Expanded(child: _buildMainContent(state)),
                      const SizedBox(height: 6),
                      _buildStageChips(state),
                    ],
                  ),
                ),
              ),
              if (state.isCompleted)
                AnimatedBuilder(
                  animation: _celebrateController,
                  builder: (_, __) => _buildCompletionOverlay(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TasbeehAlZahraState state, TasbihStats stats) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('تسبيحة الزهراء (ع)',
              style: GoogleFonts.notoKufiArabic(
                  fontSize: 8, fontWeight: FontWeight.w700, color: AppTheme.bgPrimary)),
        ),
      ],
    );
  }

  Widget _buildMainContent(TasbeehAlZahraState state) {
    return Row(
      children: [
        _buildCompactCounter(state),
        const SizedBox(width: 16),
        Expanded(child: _buildCenterInfo(state)),
        const SizedBox(width: 8),
        _buildFingerprintButton(state),
      ],
    );
  }

  Widget _buildCompactCounter(TasbeehAlZahraState state) {
    final w = MediaQuery.sizeOf(context).width;
    final size = w < 360 ? 56.0 : 70.0;
    return AnimatedBuilder(
      animation: _breatheController,
      builder: (_, __) {
        final b = _breatheController.value;
        final progress = state.target > 0 ? (state.count / state.target).clamp(0.0, 1.0) : 0.0;
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size, height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.borderGold.withValues(alpha: 0.15), width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.goldPrimary.withValues(alpha: 0.08 + b * 0.06),
                      blurRadius: 12 + b * 6,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size - 4,
                height: size - 4,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  color: AppTheme.goldPrimary,
                  backgroundColor: AppTheme.goldPrimary.withValues(alpha: 0.08),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${state.count}',
                      style: GoogleFonts.inter(
                          fontSize: size < 60 ? 18 : 22, fontWeight: FontWeight.w800,
                          color: AppTheme.goldPrimary,
                          height: 1)),
                  Text('${state.target}',
                      style: GoogleFonts.inter(
                          fontSize: 9, fontWeight: FontWeight.w600,
                          color: AppTheme.textMuted,
                          height: 1)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCenterInfo(TasbeehAlZahraState state) {
    final w = MediaQuery.sizeOf(context).width;
    final titleSize = w < 360 ? 14.0 : 17.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(state.nameArabic,
            style: GoogleFonts.notoKufiArabic(
                fontSize: titleSize, fontWeight: FontWeight.bold,
                color: AppTheme.goldPrimary)),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(state.stageName,
                style: GoogleFonts.notoKufiArabic(
                    fontSize: 10, color: AppTheme.textMuted)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child:               Text('${state.totalCount.clamp(0, 100)}%',
                  style: GoogleFonts.inter(
                      fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.goldPrimary)),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text('${state.totalCount} / 100',
            style: GoogleFonts.inter(
                fontSize: 10, color: AppTheme.textMuted)),
      ],
    );
  }

  Widget _buildFingerprintButton(TasbeehAlZahraState state) {
    final w = MediaQuery.sizeOf(context).width;
    final btnSize = w < 360 ? 46.0 : 56.0;
    final iconSize = w < 360 ? 22.0 : 28.0;
    final innerSize = w < 360 ? 42.0 : 52.0;
    if (state.isCompleted) {
      return Container(
        width: btnSize, height: btnSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppTheme.goldGradient,
          boxShadow: [
            BoxShadow(color: AppTheme.goldPrimary.withValues(alpha: 0.3), blurRadius: 12),
          ],
        ),
        child: Icon(Icons.check_circle_rounded, color: AppTheme.bgPrimary, size: iconSize),
      );
    }
    return GestureDetector(
      onTapDown: (_) {
        _tapController.forward();
        _handleTap();
      },
      onTapUp: (_) => _tapController.reverse(),
      onTapCancel: () => _tapController.reverse(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_tapController, _breatheController]),
        builder: (_, __) {
          final tap = _tapController.value;
          final breathe = _breatheController.value;
          final scale = 1.0 - tap * 0.15;
          return SizedBox(
            width: btnSize,
            height: btnSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: btnSize + breathe * 6,
                  height: btnSize + breathe * 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.goldPrimary.withValues(alpha: 0.12 - tap * 0.06),
                      width: 0.5,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: scale,
                    child: Container(
                    width: innerSize, height: innerSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.goldGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.goldPrimary.withValues(alpha: 0.3 + breathe * 0.15 + tap * 0.2),
                          blurRadius: 14 + breathe * 8,
                          spreadRadius: tap * 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(innerSize / 2),
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.12),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15 + tap * 0.1),
                              width: 1.0,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (tap > 0)
                                Container(
                                  width: innerSize, height: innerSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: tap * 0.08),
                                  ),
                                ),
                              const Icon(Icons.fingerprint, color: AppTheme.bgPrimary, size: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStageChips(TasbeehAlZahraState state) {
    final stages = [
      ('الله أكبر', 34, 1),
      ('الحمد لله', 33, 2),
      ('سبحان الله', 33, 3),
    ];
    return Row(
      children: stages.map((s) {
        final idx = s.$3;
        final isComplete = state.stage > idx || (state.stage == idx && state.count >= state.target);
        final isCurrent = state.stage == idx && !isComplete;
        return Expanded(
          child: AnimatedBuilder(
            animation: _breatheController,
            builder: (_, __) {
              final b = _breatheController.value;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                decoration: BoxDecoration(
                  gradient: isComplete
                      ? LinearGradient(colors: [
                          AppTheme.goldPrimary.withValues(alpha: 0.7),
                          AppTheme.goldSoft.withValues(alpha: 0.4),
                        ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                      : isCurrent
                          ? LinearGradient(colors: [
                              AppTheme.goldPrimary.withValues(alpha: 0.1 + b * 0.06),
                              AppTheme.goldPrimary.withValues(alpha: 0.03),
                            ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                          : null,
                  color: isCurrent || isComplete ? null : AppTheme.goldPrimary.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isComplete
                        ? AppTheme.goldPrimary
                        : isCurrent
                            ? AppTheme.borderGold.withValues(alpha: 0.4 + b * 0.3)
                            : AppTheme.borderGold.withValues(alpha: 0.08),
                    width: isCurrent ? 0.8 : 0.3,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isComplete)
                      const Icon(Icons.check_circle_rounded, size: 9, color: AppTheme.bgPrimary),
                    if (isComplete) const SizedBox(width: 3),
                    Text(s.$1,
                        style: GoogleFonts.notoKufiArabic(
                            fontSize: 8, fontWeight: FontWeight.bold,
                            color: isComplete ? AppTheme.bgPrimary : AppTheme.goldPrimary),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: (isComplete ? AppTheme.bgPrimary : AppTheme.goldPrimary).withValues(alpha: isComplete ? 0.15 : 0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('${s.$2}',
                          style: GoogleFonts.inter(
                              fontSize: 7, fontWeight: FontWeight.w600,
                              color: isComplete ? AppTheme.bgPrimary : AppTheme.goldPrimary)),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCompletionOverlay() {
    return AnimatedBuilder(
      animation: _celebrateController,
      builder: (_, __) {
        final c = _celebrateController.value;
        final scale = 0.6 + 0.4 * c;
        final opacity = c.clamp(0.0, 1.0);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.black.withValues(alpha: 0.6 * c),
          ),
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.goldGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.celebration_rounded, color: AppTheme.bgPrimary, size: 22),
                    ),
                    const SizedBox(height: 6),
                    ShaderMask(
                      shaderCallback: (b) => AppTheme.goldGradient.createShader(b),
                      child: Text('✨ تقبل الله ✨',
                          style: GoogleFonts.notoKufiArabic(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(height: 2),
                    Text('أحسنت، لقد أتممت التسبيح',
                        style: GoogleFonts.notoKufiArabic(
                            fontSize: 9, color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showQuickSettings() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppTheme.bgSurface.withValues(alpha: 0.95),
                  AppTheme.bgCard.withValues(alpha: 0.9),
                ]),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.borderGold, width: 0.5),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('التسبيح السريع',
                      style: GoogleFonts.notoKufiArabic(
                          fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  AppTheme.goldDivider(),
                  const SizedBox(height: 16),
                  _quickBtn(Icons.refresh_rounded, 'إعادة تعيين', () {
                    ref.read(tasbeehAlZahraProvider.notifier).reset();
                    Navigator.pop(ctx);
                  }),
                  const SizedBox(height: 8),
                  _quickBtn(Icons.open_in_full_rounded, 'فتح التسبيح الكامل', () {
                    Navigator.pop(ctx);
                    context.push('/tasbeeh');
                  }),
                  const SizedBox(height: 8),
                  _quickBtn(Icons.bar_chart_rounded, 'الإحصائيات', () {
                    Navigator.pop(ctx);
                    context.push('/tasbeeh');
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.goldPrimary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderGold, width: 0.3),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.goldPrimary, size: 16),
            const SizedBox(width: 10),
            Text(label,
                style: GoogleFonts.notoKufiArabic(
                    fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          ],
        ),
      ),
    );
  }
}

