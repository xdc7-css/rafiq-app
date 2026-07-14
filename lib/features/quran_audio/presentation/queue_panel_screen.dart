import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/ds_components.dart';
import '../data/models/persisted_playback_state.dart';
import '../providers/quran_audio_providers.dart';

class QueuePanelScreen extends ConsumerStatefulWidget {
  const QueuePanelScreen({super.key});

  @override
  ConsumerState<QueuePanelScreen> createState() => _QueuePanelScreenState();
}

class _QueuePanelScreenState extends ConsumerState<QueuePanelScreen> {
  late List<QueueItem> _queueItems;
  late int _currentIndex;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final handler = ref.read(audioHandlerProvider);
      final mediaQueue = handler.queue.value;
      final curIdx = handler.currentIndex ?? 0;
      _queueItems = mediaQueue.map((m) {
        return QueueItem(
          surahNumber: m.extras?['surahNumber'] as int? ?? 0,
          surahName: m.title,
          audioUrl: m.extras?['audioUrl'] as String? ?? '',
          localPath: m.extras?['localPath'] as String?,
        );
      }).toList();
      _currentIndex = curIdx;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(audioPlayerNotifierProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.bgPrimary,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D1B2A), Color(0xFF0A1628)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                _buildNowPlaying(playerState),
                const SizedBox(height: 12),
                _buildActionBar(),
                const SizedBox(height: 8),
                Expanded(
                  child: _queueItems.isEmpty
                      ? _buildEmptyQueue()
                      : _buildQueueList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.bgCard.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.borderGold, width: 0.5),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.textPrimary, size: 18),
            ),
          ),
          const Spacer(),
          Text(
            'قائمة التشغيل',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildNowPlaying(AudioPlayerState playerState) {
    if (!playerState.hasActivePlayback) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playerState.currentSurahName,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    playerState.currentReciter?.name ?? '',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 12,
                      color: AppTheme.goldPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (playerState.isPlaying)
              Icon(Icons.equalizer_rounded, color: AppTheme.goldPrimary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.queue_music_rounded, color: AppTheme.goldPrimary, size: 18),
          const SizedBox(width: 8),
          Text(
            'قائمة التشغيل',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.goldPrimary,
            ),
          ),
          const Spacer(),
          Text(
            '${_queueItems.length} سورة',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () async {
              await ref.read(audioPlayerNotifierProvider.notifier).clearQueue();
              setState(() {
                final handler = ref.read(audioHandlerProvider);
                final mediaQueue = handler.queue.value;
                _queueItems = mediaQueue.map((m) {
                  return QueueItem(
                    surahNumber: m.extras?['surahNumber'] as int? ?? 0,
                    surahName: m.title,
                    audioUrl: m.extras?['audioUrl'] as String? ?? '',
                    localPath: m.extras?['localPath'] as String?,
                  );
                }).toList();
                _currentIndex = handler.currentIndex ?? 0;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.bgCard.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderGold, width: 0.5),
              ),
              child: Text(
                'مسح القائمة',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyQueue() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.queue_music_rounded, size: 64, color: AppTheme.goldPrimary.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(
            'قائمة التشغيل فارغة',
            style: GoogleFonts.notoKufiArabic(fontSize: 16, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 8),
          Text(
            'اختر سورة من القائمة لبدء التشغيل',
            style: GoogleFonts.notoKufiArabic(fontSize: 12, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueList() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _queueItems.length,
      onReorder: (oldIndex, newIndex) async {
        if (oldIndex < newIndex) newIndex--;
        final item = _queueItems.removeAt(oldIndex);
        _queueItems.insert(newIndex, item);
        await ref.read(audioPlayerNotifierProvider.notifier).moveInQueue(oldIndex, newIndex);
        setState(() {
          final handler = ref.read(audioHandlerProvider);
          _currentIndex = handler.currentIndex ?? 0;
        });
      },
      itemBuilder: (context, index) {
        final item = _queueItems[index];
        final isActive = index == _currentIndex;

        return Dismissible(
          key: ValueKey('queue_${item.surahNumber}_$index'),
          direction: _queueItems.length <= 1
              ? DismissDirection.none
              : DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.delete_rounded, color: Colors.redAccent),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  backgroundColor: AppTheme.bgCard,
                  title: Text(
                    'إزالة من القائمة',
                    style: GoogleFonts.notoKufiArabic(color: AppTheme.textPrimary),
                  ),
                  content: Text(
                    'إزالة "${item.surahName}" من قائمة التشغيل؟',
                    style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text('إلغاء', style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text('إزالة', style: GoogleFonts.notoKufiArabic(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ),
            ) ?? false;
          },
          onDismissed: (_) async {
            await ref.read(audioPlayerNotifierProvider.notifier).removeFromQueue(index);
            setState(() {
              _queueItems.removeAt(index);
              final handler = ref.read(audioHandlerProvider);
              _currentIndex = handler.currentIndex ?? 0;
            });
          },
          child: GestureDetector(
            onTap: () async {
              await ref.read(audioHandlerProvider).skipToQueueItem(index);
              setState(() {
                _currentIndex = index;
              });
            },
            onLongPress: () => _showItemActions(index, item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.goldPrimary.withValues(alpha: 0.15)
                    : AppTheme.bgCard.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isActive ? AppTheme.goldPrimary.withValues(alpha: 0.5) : AppTheme.borderGold.withValues(alpha: 0.3),
                  width: isActive ? 1.0 : 0.5,
                ),
              ),
              child: Row(
                children: [
                  if (isActive)
                    Icon(Icons.equalizer_rounded, color: AppTheme.goldPrimary, size: 20)
                  else
                    Text(
                      '${index + 1}',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.surahName,
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 14,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive ? AppTheme.goldPrimary : AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'الآن',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else
                    Icon(Icons.drag_handle_rounded, color: AppTheme.textMuted, size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showItemActions(int index, QueueItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.borderGold, width: 0.5),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textMuted.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    item.surahName,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.goldPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (index != _currentIndex) ...[
                  _buildActionTile(
                    icon: Icons.skip_next_rounded,
                    title: 'تشغيل التالي',
                    onTap: () async {
                      Navigator.pop(ctx);
                      final qItem = QueueItem(
                        surahNumber: item.surahNumber,
                        surahName: item.surahName,
                        audioUrl: item.audioUrl,
                        localPath: item.localPath,
                      );
                      await ref.read(audioPlayerNotifierProvider.notifier).removeFromQueue(index);
                      await ref.read(audioPlayerNotifierProvider.notifier).addToQueue(qItem, playNext: true);
                      setState(() {
                        final handler = ref.read(audioHandlerProvider);
                        final mediaQueue = handler.queue.value;
                        _queueItems = mediaQueue.map((m) {
                          return QueueItem(
                            surahNumber: m.extras?['surahNumber'] as int? ?? 0,
                            surahName: m.title,
                            audioUrl: m.extras?['audioUrl'] as String? ?? '',
                            localPath: m.extras?['localPath'] as String?,
                          );
                        }).toList();
                        _currentIndex = handler.currentIndex ?? 0;
                      });
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.playlist_add_rounded,
                    title: 'إضافة للنهاية',
                    onTap: () async {
                      Navigator.pop(ctx);
                      final qItem = QueueItem(
                        surahNumber: item.surahNumber,
                        surahName: item.surahName,
                        audioUrl: item.audioUrl,
                        localPath: item.localPath,
                      );
                      await ref.read(audioPlayerNotifierProvider.notifier).removeFromQueue(index);
                      await ref.read(audioPlayerNotifierProvider.notifier).addToQueue(qItem, playNext: false);
                      setState(() {
                        final handler = ref.read(audioHandlerProvider);
                        final mediaQueue = handler.queue.value;
                        _queueItems = mediaQueue.map((m) {
                          return QueueItem(
                            surahNumber: m.extras?['surahNumber'] as int? ?? 0,
                            surahName: m.title,
                            audioUrl: m.extras?['audioUrl'] as String? ?? '',
                            localPath: m.extras?['localPath'] as String?,
                          );
                        }).toList();
                        _currentIndex = handler.currentIndex ?? 0;
                      });
                    },
                  ),
                ],
                _buildActionTile(
                  icon: Icons.delete_rounded,
                  title: 'إزالة من القائمة',
                  color: Colors.redAccent,
                  onTap: () async {
                    Navigator.pop(ctx);
                    await ref.read(audioPlayerNotifierProvider.notifier).removeFromQueue(index);
                    setState(() {
                      _queueItems.removeAt(index);
                      final handler = ref.read(audioHandlerProvider);
                      _currentIndex = handler.currentIndex ?? 0;
                    });
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.goldPrimary, size: 22),
      title: Text(
        title,
        style: GoogleFonts.notoKufiArabic(
          fontSize: 14,
          color: color ?? AppTheme.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }
}
