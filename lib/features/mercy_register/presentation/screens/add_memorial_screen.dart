import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme/app_theme.dart';
import '../../data/models/memorial.dart';
import '../../providers/mercy_register_providers.dart';
import '../../data/predefined_duas.dart';
import '../../domain/utils/validation.dart';
import '../../../../core/utils/hijri_date.dart';

/// Add Memorial screen – premium, simplified UI.
final quickDuasProvider = Provider<List<DuaOption>>((ref) => kQuickDuaOptions);
final allDuasProvider = Provider<List<DuaOption>>((ref) => kAllDuaOptions);

class AddMemorialScreen extends ConsumerStatefulWidget {
  const AddMemorialScreen({super.key});

  @override
  ConsumerState<AddMemorialScreen> createState() => _AddMemorialScreenState();
}

class _AddMemorialScreenState extends ConsumerState<AddMemorialScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  int _buildCount = 0;

  DateTime _dateOfDeath = DateTime.now();
  String? _selectedDuaTitle; // store title as identifier
  bool _isPublic = true;
  bool _isSaving = false;

  // Animation controller for success overlay
  late final AnimationController _successCtrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      debugPrint('[AddMemorial] controller.text: "${_nameController.text}"');
    });
    _nameFocusNode.addListener(() {
      debugPrint('[AddMemorial] focusNode: hasFocus=${_nameFocusNode.hasFocus}');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfDeath,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.goldPrimary,
              surface: AppTheme.bgCard,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && !picked.isAfter(DateTime.now())) {
      setState(() => _dateOfDeath = picked);
    }
  }

  String _formatHijri(DateTime date) {
    final hijri = HijriDate.fromDate(date);
    return '${hijri.day}/${hijri.month}/${hijri.year} هـ';
  }

  Future<void> _save() async {
    debugPrint('[AddMemorial] ===== SAVE STARTED =====');
    if (!_formKey.currentState!.validate()) {
      debugPrint('[AddMemorial] Form validation FAILED');
      return;
    }
    debugPrint('[AddMemorial] Form validation PASSED');

    final nameTrim = _nameController.text.trim();
    debugPrint('[AddMemorial] Name: "$nameTrim"');
    debugPrint('[AddMemorial] Date of death: $_dateOfDeath');
    debugPrint('[AddMemorial] Selected dua: $_selectedDuaTitle');
    debugPrint('[AddMemorial] Is public: $_isPublic');

    final isDup = await isDuplicateMemorialName(ref, nameTrim);
    debugPrint('[AddMemorial] Is duplicate: $isDup');
    if (isDup) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اسم المتوفى موجود مسبقاً')),
      );
      debugPrint('[AddMemorial] ===== SAVE ABORTED: DUPLICATE NAME =====');
      return;
    }

    setState(() => _isSaving = true);

    final authUserId = ref.read(firebaseAuthProvider).currentUserId;
    debugPrint('[AddMemorial] Auth user id: "$authUserId"');

    final memorial = Memorial.create(
      deceasedName: nameTrim,
      deceasedNameArabic: null,
      dateOfDeath: _dateOfDeath,
      description: null,
      type: MemorialType.generalPrayer,
      isPublic: _isPublic,
      duaText: _selectedDuaTitle,
      userId: authUserId,
    );
    debugPrint('[AddMemorial] Memorial created: id=${memorial.id}, name=${memorial.deceasedName}');

    try {
      debugPrint('[AddMemorial] Reading repository provider...');
      final repo = await ref.read(memorialRepositoryProvider.future);
      debugPrint('[AddMemorial] Repository obtained. Calling createMemorial...');
      final result = await repo.createMemorial(memorial);
      debugPrint('[AddMemorial] createMemorial result: isSuccess=${result.isSuccess}');
      if (result.isFailure) {
        debugPrint('[AddMemorial] Result failure: ${result.errorOrNull}');
      }
      if (!mounted) {
        debugPrint('[AddMemorial] Widget not mounted after save, aborting');
        return;
      }
      if (result.isSuccess) {
        debugPrint('[AddMemorial] ===== SAVE SUCCESS =====');
        ref.read(memorialsProvider.notifier).updateSingleMemorial(memorial);
        _showSuccessOverlay();
      } else {
        debugPrint('[AddMemorial] ===== SAVE FAILED: result.isFailure =====');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل الحفظ: ${result.errorOrNull}')),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('[AddMemorial] ===== SAVE EXCEPTION: $e =====');
      debugPrint('[AddMemorial] Stack trace: $stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل الحفظ: $e')),
      );
    } finally {
      debugPrint('[AddMemorial] ===== SAVE FINISHED =====');
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSuccessOverlay() {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => _SuccessOverlay(controller: _successCtrl),
    );
    _successCtrl.forward();
    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (mounted) {
        Navigator.of(context).pop(); // close overlay
        await Future.delayed(const Duration(milliseconds: 200));
        Navigator.of(context).pop(); // go back to previous screen
      }
    });
  }

  void _showMoreDuas() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _DuaBottomSheet(selectedCurrent: _selectedDuaTitle),
    );
    if (selected != null) {
      setState(() => _selectedDuaTitle = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    debugPrint('[AddMemorial] build #$_buildCount');
    final quickDuas = ref.watch(quickDuasProvider);
    // Build quick dua cards – use const where possible
    final quickCards = quickDuas.map((opt) {
      final isSelected = _selectedDuaTitle == opt.title;
      return GestureDetector(
        onTap: () => setState(() => _selectedDuaTitle = opt.title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: (MediaQuery.of(context).size.width - 64) / 2,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.goldPrimary.withValues(alpha: 0.2)
                : AppTheme.bgCard.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppTheme.goldPrimary : AppTheme.borderSubtle,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(opt.icon, color: AppTheme.goldPrimary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      opt.title,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 13,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                opt.preview,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    'إضافة سجل جديد',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Name field
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onTap: () => debugPrint('[AddMemorial] name field tapped'),
                        onChanged: (v) => debugPrint('[AddMemorial] onChanged: "$v" (len=${v.length})'),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'الرجاء إدخال الاسم';
                          if (v.trim().length > 60) return 'الحد الأقصى 60 حرفًا';
                          return null;
                        },
                        style: GoogleFonts.notoKufiArabic(
                            fontSize: 14, color: AppTheme.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'اسم المتوفى',
                          labelStyle: GoogleFonts.notoKufiArabic(
                              fontSize: 13, color: AppTheme.textMuted),
                          prefixIcon: const Icon(Icons.person_rounded,
                              color: AppTheme.goldPrimary, size: 20),
                          filled: true,
                          fillColor:
                              AppTheme.bgCard.withValues(alpha: 0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                BorderSide(color: AppTheme.borderSubtle, width: 0.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                BorderSide(color: AppTheme.borderSubtle, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: AppTheme.goldPrimary, width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Date picker with Hijri
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                              color: AppTheme.bgCard.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: AppTheme.borderSubtle, width: 0.5)),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded,
                                  color: AppTheme.goldPrimary, size: 20),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'تاريخ الوفاة: ${_dateOfDeath.year}/${_dateOfDeath.month}/${_dateOfDeath.day}',
                                    style: GoogleFonts.notoKufiArabic(
                                        fontSize: 14,
                                        color: AppTheme.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'هجري: ${_formatHijri(_dateOfDeath)}',
                                    style: GoogleFonts.notoKufiArabic(
                                        fontSize: 12,
                                        color: AppTheme.textMuted),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Quick Dua cards
                      Text(
                        'دعاء الإهداء',
                        style: GoogleFonts.notoKufiArabic(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: quickCards,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _showMoreDuas,
                        child: const Text('عرض المزيد من الأدعية'),
                      ),
                      const SizedBox(height: 16),
                      // Visibility switch
                      SwitchListTile(
                        value: _isPublic,
                        onChanged: (v) => setState(() => _isPublic = v),
                        title: Text(
                          'العرض لجميع المستخدمين',
                          style: GoogleFonts.notoKufiArabic(
                              fontSize: 14, color: AppTheme.textPrimary),
                        ),
                        subtitle: Text(
                          'يمكن لجميع مستخدمي التطبيق إهداء ثواب أعمالهم لهذا المتوفى.',
                          style: GoogleFonts.notoKufiArabic(
                              fontSize: 11, color: AppTheme.textMuted),
                        ),
                        activeThumbColor: AppTheme.goldPrimary,
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 32),
                      // Save button
                      GestureDetector(
                        onTap: _isSaving ? null : _save,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: _isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white),
                                  )
                                : Text(
                                    'حفظ السجل',
                                    style: GoogleFonts.notoKufiArabic(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.bgPrimary),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Success overlay widget with scale animation.
class _SuccessOverlay extends StatelessWidget {
  final AnimationController controller;
  const _SuccessOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(parent: controller, curve: Curves.easeOutBack);
    return Center(
      child: ScaleTransition(
        scale: animation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: AppTheme.goldPrimary, size: 64),
              SizedBox(height: 12),
              Text(
                'تم حفظ السجل بنجاح',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet displaying all duas grouped by category.
class _DuaBottomSheet extends ConsumerWidget {
  final String? selectedCurrent;
  const _DuaBottomSheet({this.selectedCurrent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDuas = ref.watch(allDuasProvider);
    // Group by category
    final Map<String, List<DuaOption>> grouped = {};
    for (final opt in allDuas) {
      grouped.putIfAbsent(opt.category, () => []).add(opt);
    }
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.textMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          ...grouped.entries.map((entry) {
            return ExpansionTile(
              collapsedIconColor: AppTheme.textMuted,
              iconColor: AppTheme.goldPrimary,
              shape: const Border(),
              collapsedShape: const Border(),
              title: Text(
                entry.key,
                style: GoogleFonts.notoKufiArabic(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              children: entry.value.map((dua) {
                final isSelected = dua.title == selectedCurrent;
                return ListTile(
                  leading: Icon(dua.icon, color: AppTheme.goldPrimary),
                  title: Text(
                    dua.title,
                    style: GoogleFonts.notoKufiArabic(
                        color: isSelected ? AppTheme.goldPrimary : AppTheme.textPrimary),
                  ),
                  subtitle: Text(
                    dua.preview,
                    style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted),
                  ),
                  trailing: isSelected ? const Icon(Icons.check, color: AppTheme.goldPrimary) : null,
                  onTap: () => Navigator.of(context).pop(dua.title),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
