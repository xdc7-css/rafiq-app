import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/ds_components.dart';
import '../providers/widget_studio_provider.dart';
import '../widgets/studio_widgets.dart';

/// Preset management: save, load, rename, duplicate, delete.
class PresetManagement extends ConsumerWidget {
  const PresetManagement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studio = ref.watch(widgetStudioProvider);
    final notifier = ref.read(widgetStudioProvider.notifier);
    final presets = studio.presets;

    return Column(
      children: [
        StudioSectionHeader(
          title: 'Presets',
          icon: Icons.bookmarks_rounded,
          trailing: GestureDetector(
            onTap: () => _showSaveDialog(context, ref),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.goldPrimary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, size: 14, color: AppTheme.goldPrimary),
                  const SizedBox(width: 4),
                  Text(
                    'New',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.goldPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (presets.isEmpty)
          _EmptyPresets(onSave: () => _showSaveDialog(context, ref))
        else
          StudioCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                // ── Restore Defaults ──
                _PresetTile(
                  icon: Icons.restore_rounded,
                  name: 'Restore Defaults',
                  isDefault: true,
                  onTap: () => notifier.restoreDefaults(),
                ),
                Divider(height: 1, color: AppTheme.borderSubtle),
                // ── Preset List ──
                ...presets.map((preset) {
                  final isActive = preset.id == studio.activePresetId;
                  return _PresetTile(
                    icon: isActive
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    name: preset.name,
                    isActive: isActive,
                    onTap: () => notifier.loadPreset(preset.id),
                    onRename: () =>
                        _showRenameDialog(context, ref, preset.id, preset.name),
                    onDuplicate: () => notifier.duplicatePreset(preset.id),
                    onDelete: () => _showDeleteConfirm(
                        context, ref, preset.id, preset.name),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }

  void _showSaveDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppTheme.borderGold),
        ),
        title: Text(
          'Save Preset',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.cairo(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Preset name...',
            hintStyle: GoogleFonts.cairo(color: AppTheme.textMuted),
            filled: true,
            fillColor: AppTheme.bgSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderGold),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: GoogleFonts.cairo(color: AppTheme.textMuted)),
          ),
          GoldButton(
            label: 'Save',
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(widgetStudioProvider.notifier)
                    .savePreset(controller.text.trim());
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(
      BuildContext context, WidgetRef ref, String presetId, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppTheme.borderGold),
        ),
        title: Text(
          'Rename Preset',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.cairo(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.bgSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderGold),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: GoogleFonts.cairo(color: AppTheme.textMuted)),
          ),
          GoldButton(
            label: 'Rename',
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(widgetStudioProvider.notifier)
                    .renamePreset(presetId, controller.text.trim());
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(
      BuildContext context, WidgetRef ref, String presetId, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppTheme.borderGold),
        ),
        title: Text(
          'Delete "$name"?',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'This preset will be permanently removed.',
          style: GoogleFonts.cairo(color: AppTheme.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: GoogleFonts.cairo(color: AppTheme.textMuted)),
          ),
          GoldButton(
            label: 'Delete',
            outlined: true,
            onTap: () {
              ref.read(widgetStudioProvider.notifier).deletePreset(presetId);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyPresets extends StatelessWidget {
  final VoidCallback onSave;
  const _EmptyPresets({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      child: Column(
        children: [
          Icon(
            Icons.bookmarks_outlined,
            size: 32,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 10),
          Text(
            'No presets saved yet',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Save your current settings as a preset\nto quickly switch between styles.',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: AppTheme.textMutedPremium,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          GoldButton(
            label: 'Save Current',
            icon: Icons.add_rounded,
            onTap: onSave,
          ),
        ],
      ),
    );
  }
}

class _PresetTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool isDefault;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onRename;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;

  const _PresetTile({
    required this.icon,
    required this.name,
    this.isDefault = false,
    this.isActive = false,
    required this.onTap,
    this.onRename,
    this.onDuplicate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? AppTheme.goldPrimary
                    : isDefault
                        ? AppTheme.textMuted
                        : AppTheme.textElevated,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? AppTheme.goldPrimary
                        : AppTheme.textElevated,
                  ),
                ),
              ),
              if (isActive)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Active',
                    style: GoogleFonts.cairo(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.goldPrimary,
                    ),
                  ),
                ),
              if (!isDefault)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 16,
                    color: AppTheme.textMuted,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'rename':
                        onRename?.call();
                        break;
                      case 'duplicate':
                        onDuplicate?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'rename',
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded,
                              size: 16, color: AppTheme.textElevated),
                          const SizedBox(width: 8),
                          Text('Rename', style: GoogleFonts.cairo()),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy_rounded,
                              size: 16, color: AppTheme.textElevated),
                          const SizedBox(width: 8),
                          Text('Duplicate', style: GoogleFonts.cairo()),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              size: 16, color: Colors.red.shade300),
                          const SizedBox(width: 8),
                          Text('Delete',
                              style: GoogleFonts.cairo(
                                  color: Colors.red.shade300)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
