import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/permission_models.dart';
import '../../../../services/permission_request_controller.dart';
import '../../../../services/permission_service.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/oem_guidance_card.dart';
import '../../../../widgets/permission_status_row.dart';

class PermissionsSettingsScreen extends ConsumerStatefulWidget {
  const PermissionsSettingsScreen({super.key});

  @override
  ConsumerState<PermissionsSettingsScreen> createState() =>
      _PermissionsSettingsScreenState();
}

class _PermissionsSettingsScreenState
    extends ConsumerState<PermissionsSettingsScreen> {
  /// Platform-filtered settings permissions (built once)
  late final List<PermissionDefinition> _permissions;

  /// Informational-only items (e.g. auto-start on Android)
  late final List<PermissionDefinition> _infoItems;

  late final PermissionRequestController _controller;

  @override
  void initState() {
    super.initState();
    final all = PermissionRegistry.settingsPermissions();
    _permissions = all.where((p) => !p.isInformational).toList();
    _infoItems = all.where((p) => p.isInformational).toList();
    _controller = PermissionRequestController(_permissions);
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    await _controller.checkInitialPermissions();
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 100),
                    child: Column(
                      children: [
                        ..._permissions.map((item) => [
                              PermissionStatusRow(
                                item: item,
                                status: _controller.status(item.key),
                                compact: false,
                                onTap: () async {
                                  await _controller.retryPermission(item.key);
                                },
                              ),
                              const SizedBox(height: 16),
                            ]).expand((e) => e),
                        ..._infoItems.map((item) => [
                              PermissionStatusRow(
                                item: item,
                                status: PermissionUIStatus.granted,
                                compact: false,
                                onTap: () async {
                                  if (item.key == PermissionKey.foreground) {
                                    await PermissionService.openAutoStartSettings();
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                            ]).expand((e) => e),
                        _buildInfoCard(),
                        const SizedBox(height: 16),
                        const OEMGuidanceCard(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
        color: AppTheme.goldPrimary,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.bgPrimary.withValues(alpha: 0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
        title: Text(
          'صلاحيات التطبيق',
          style: GoogleFonts.notoKufiArabic(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.goldPrimary,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.goldPrimary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.goldPrimary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: AppTheme.goldPrimary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'بعض الصلاحيات اختيارية لكنها مطلوبة لعمل الأذان بشكل موثوق',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textMuted.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
