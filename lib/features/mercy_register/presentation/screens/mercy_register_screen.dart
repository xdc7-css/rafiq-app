import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/memorial.dart';
import '../../providers/mercy_register_providers.dart';
import '../widgets/premium_memorial_card.dart';
import '../../../../widgets/premium_bottom_nav.dart';

const _bgPrimary = Color(0xFF081326);
const _bgCard = Color(0xFF11264E);
const _goldPrimary = Color(0xFFD8A83A);
const _goldLight = Color(0xFFF3CF72);
const _textPrimary = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFCBD3E8);

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredMemorialsProvider = Provider<List<Memorial>>((ref) {
  final all = ref.watch(memorialsProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return all;
  final normalized = Memorial.normalizeArabic(query);
  return all.where((m) {
    return m.searchName.contains(normalized) ||
        (m.searchNameArabic?.contains(normalized) ?? false) ||
        m.deceasedName.toLowerCase().contains(query) ||
        (m.deceasedNameArabic?.toLowerCase().contains(query) ?? false);
  }).toList();
});

class MercyRegisterScreen extends ConsumerStatefulWidget {
  const MercyRegisterScreen({super.key});

  @override
  ConsumerState<MercyRegisterScreen> createState() =>
      _MercyRegisterScreenState();
}

class _MercyRegisterScreenState extends ConsumerState<MercyRegisterScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomNav = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _bgPrimary,
      appBar: AppBar(
        backgroundColor: _bgPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: _textPrimary,
          ),
        ),
        title: Text(
          'سجل الرحمة',
          style: GoogleFonts.notoKufiArabic(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: _textPrimary,
              size: 22,
            ),
            onSelected: (value) {
              switch (value) {
                case 'backup':
                  _showComingSoon('استيراد من نسخة احتياطية');
                case 'qr':
                  _showComingSoon('مسح QR');
                case 'family':
                  _showComingSoon('إنشاء مجموعة عائلية');
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'backup',
                child: Row(
                  children: [
                    const Icon(Icons.backup_outlined,
                        color: _goldPrimary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'استيراد من نسخة احتياطية',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 14,
                        color: _textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'qr',
                child: Row(
                  children: [
                    const Icon(Icons.qr_code_scanner_outlined,
                        color: _goldPrimary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'مسح QR',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 14,
                        color: _textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'family',
                child: Row(
                  children: [
                    const Icon(Icons.group_add_outlined,
                        color: _goldPrimary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'إنشاء مجموعة عائلية',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 14,
                        color: _textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeroSection(),
              _buildListHeader(),
              _buildMemorialList(),
              SizedBox(height: 100 + bottomNav),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: PremiumBottomNav(
        selectedIndex: -1,
        onDestinationSelected: (index) {
          HapticFeedback.selectionClick();
          switch (index) {
            case 0:
              context.go('/home');
            case 1:
              context.go('/quran');
            case 2:
              context.go('/ziyarat');
            case 3:
              context.go('/hadith');
            case 4:
              context.go('/settings');
          }
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // Hero Section
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: SizedBox(
        height: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: _bgPrimary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: _goldPrimary.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Stack(
                children: [
                  // ── Navy gradient background ──
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _bgPrimary,
                            const Color(0xFF0D1B33),
                            const Color(0xFF11264E),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // ── Full-width background artwork with fallback ──
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/sjlrhma.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: _bgCard);
                      },
                    ),
                  ),

                  // ── Gold border overlay ──
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: _goldPrimary.withValues(alpha: 0.2),
                          width: 0.8,
                        ),
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

  Widget _buildListHeader() {
    final count = ref.watch(filteredMemorialsProvider).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Text(
            'أحبتي',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'في الدعاء',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: _textSecondary.withValues(alpha: 0.6),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _goldPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _goldPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemorialList() {
    final memorials = ref.watch(filteredMemorialsProvider);
    final query = ref.watch(searchQueryProvider);

    if (memorials.isEmpty && query.isNotEmpty) {
      return _buildSearchEmpty();
    }

    if (memorials.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(
          memorials.length,
          (index) {
            final memorial = memorials[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MemorialCard(
                memorial: memorial,
                isOwner: ref.watch(currentUserIdProvider) == memorial.userId,
                onTap: () => context.push('/mercy-register/${memorial.id}'),
                onDedicateDua: () => context.push('/dua-selection/${Uri.encodeComponent(memorial.id)}'),
                onDedicateFatiha: () => context.go('/mushaf?page=1&memorialId=${Uri.encodeComponent(memorial.id)}'),
                onDedicateTasbeeh: () => context.push('/tasbeeh?memorialId=${Uri.encodeComponent(memorial.id)}'),
                onEdit: () => context.push('/add-memorial'),
                onDelete: () => _confirmDelete(memorial),
                onReport: () => _showComingSoon('إبلاغ'),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _bgCard,
              border: Border.all(
                color: _goldPrimary.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.volunteer_activism_outlined,
              size: 44,
              color: _goldPrimary.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا يوجد أحد في القائمة بعد',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أضف من تحبهم ليظل الدعاء\nوالصدقة الجارية مستمرة.',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 13,
              color: _textSecondary,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => context.push('/add-memorial'),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_goldPrimary, _goldLight],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_rounded, color: _bgPrimary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'إضافة حبيب',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _bgPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: _textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج مطابقة',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرّب البحث بكلمات أخرى.',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 13,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => context.push('/add-memorial'),
      backgroundColor: _goldPrimary,
      foregroundColor: _bgPrimary,
      elevation: 6,
      child: const Icon(Icons.add_rounded, size: 28),
    );
  }

  Future<void> _confirmDelete(Memorial memorial) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'حذف السجل',
          style: GoogleFonts.notoKufiArabic(
            color: _textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل تريد حذف سجل "${memorial.displayName}" نهائياً؟',
          style: GoogleFonts.notoKufiArabic(color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child:
                Text('إلغاء', style: TextStyle(color: _textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref
          .read(memorialsProvider.notifier)
          .deleteMemorial(memorial.id);
      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم حذف سجل "${memorial.displayName}"',
              style: GoogleFonts.notoKufiArabic(),
            ),
            backgroundColor: _bgCard,
          ),
        );
      }
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('ميزة "$feature" قريباً...', style: GoogleFonts.notoKufiArabic()),
        backgroundColor: _bgCard,
      ),
    );
  }
}
