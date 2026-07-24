import 'package:flutter/material.dart';
import '../models/permission_models.dart';
import '../services/permission_request_controller.dart';
import '../theme/app_theme.dart';

class PermissionStatusRow extends StatelessWidget {
  final PermissionDefinition item;
  final PermissionUIStatus status;
  final bool compact;
  final VoidCallback? onTap;

  const PermissionStatusRow({
    super.key,
    required this.item,
    required this.status,
    this.compact = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return compact ? _buildCompact() : _buildDetailed();
  }

  // ═══════════════════════════════════════════════════════════════
  // COMPACT MODE — Onboarding
  // ═══════════════════════════════════════════════════════════════

  Widget _buildCompact() {
    final isGranted = status == PermissionUIStatus.granted;
    final isRequesting = status == PermissionUIStatus.requesting;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isGranted
                  ? AppTheme.goldPrimary.withValues(alpha: 0.12)
                  : AppTheme.goldPrimary.withValues(alpha: isRequesting ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              item.icon,
              size: 22,
              color: isGranted
                  ? AppTheme.goldPrimary
                  : AppTheme.goldPrimary.withValues(alpha: isRequesting ? 0.9 : 0.6),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _buildStatusChip(key: ValueKey(status)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DETAILED MODE — Settings
  // ═══════════════════════════════════════════════════════════════

  Widget _buildDetailed() {
    final isGranted = status == PermissionUIStatus.granted;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isGranted
              ? AppTheme.goldPrimary.withValues(alpha: 0.2)
              : AppTheme.goldPrimary.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.goldPrimary.withValues(alpha: 0.15),
                      AppTheme.goldPrimary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, size: 24, color: AppTheme.goldPrimary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                isGranted ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 20,
                color: isGranted ? AppTheme.goldPrimary : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                isGranted ? 'مفعل' : 'غير مفعل',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isGranted ? AppTheme.goldPrimary : Colors.orange,
                ),
              ),
              const Spacer(),
              if (!isGranted && item.showRetry)
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.goldPrimary,
                    foregroundColor: AppTheme.bgPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'تفعيل',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (isGranted)
                TextButton(
                  onPressed: onTap,
                  child: Text(
                    'تعديل',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.goldPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Status Chip (shared)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildStatusChip({Key? key}) {
    switch (status) {
      case PermissionUIStatus.waiting:
        return Container(
          key: key,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.goldPrimary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'بانتظار',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.goldPrimary,
            ),
          ),
        );

      case PermissionUIStatus.requesting:
        return Container(
          key: key,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.goldPrimary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.goldPrimary),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'جارٍ الطلب...',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.goldPrimary,
                ),
              ),
            ],
          ),
        );

      case PermissionUIStatus.granted:
        return Container(
          key: key,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.goldPrimary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_rounded, size: 14, color: AppTheme.goldPrimary),
              SizedBox(width: 4),
              Text(
                'تم التفعيل',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.goldPrimary,
                ),
              ),
            ],
          ),
        );

      case PermissionUIStatus.denied:
        return Container(
          key: key,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'يتطلب الإعداد',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
        );
    }
  }
}
