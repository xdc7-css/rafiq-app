import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/permission_models.dart';
import '../theme/app_theme.dart';

class PermissionStatusCard extends StatefulWidget {
  const PermissionStatusCard({super.key});

  @override
  State<PermissionStatusCard> createState() => _PermissionStatusCardState();
}

class _PermissionStatusCardState extends State<PermissionStatusCard> {
  bool _checking = true;
  PermissionDefinition? _singleMissing;
  int _missingCount = 0;

  /// Platform-filtered permissions (built once)
  late final List<PermissionDefinition> _permissions;

  @override
  void initState() {
    super.initState();
    _permissions = PermissionRegistry.onboardingPermissions();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final missing = <PermissionDefinition>[];
    for (final perm in _permissions) {
      if (perm.isInformational) continue;
      final granted = await PermissionRegistry.checkPermission(perm.key);
      if (!granted) missing.add(perm);
    }

    if (!mounted) return;
    setState(() {
      _checking = false;
      _missingCount = missing.length;
      _singleMissing = missing.length == 1 ? missing.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking || _missingCount == 0) return const SizedBox.shrink();

    final w = MediaQuery.sizeOf(context).width;
    final pad = w < 360 ? 14.0 : 18.0;
    final isCompact = _missingCount == 1;

    return GestureDetector(
      onTap: () async {
        await context.push('/permissions');
        _checkPermissions();
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: Container(
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.goldPrimary.withValues(alpha: 0.08),
                AppTheme.goldPrimary.withValues(alpha: 0.03),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.goldPrimary.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: isCompact ? 36 : 40,
                height: isCompact ? 36 : 40,
                decoration: BoxDecoration(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _singleMissing?.icon ?? Icons.notifications_paused_rounded,
                  size: isCompact ? 18 : 20,
                  color: AppTheme.goldPrimary.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(width: isCompact ? 10 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: isCompact ? 12 : 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _subtitle,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 10,
                        color: AppTheme.textMuted.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: AppTheme.goldPrimary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _title {
    if (_singleMissing != null) return _singleMissing!.title;
    return 'إعداد الأذان غير مكتمل';
  }

  String get _subtitle {
    if (_singleMissing != null) return _singleMissing!.subtitle;
    if (_missingCount == 2) return 'صلاحيتان مطلوبتان لتشغيل الأذان';
    return '$_missingCount صلاحيات مطلوبة لتشغيل الأذان';
  }
}
