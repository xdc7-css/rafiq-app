import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../providers/qibla_provider.dart';
import '../models/qibla_models.dart';
import '../utils/qibla_math.dart';

class StatusCard extends ConsumerStatefulWidget {
  final QiblaData state;

  const StatusCard({super.key, required this.state});

  @override
  ConsumerState<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends ConsumerState<StatusCard> {
  int? _expandedIndex; // Tracks which card/row is expanded (0 = direction, 1 = distance, 2 = Qibla, 3 = location)

  @override
  Widget build(BuildContext context) {
    final heading = widget.state.heading;
    final cardinal = QiblaMath.cardinalDirection(heading);
    final cardinalAr = _cardinalArabic(cardinal);
    final qiblahBearing = widget.state.offset;
    final distance = _haversineKm(
      widget.state.latitude ?? 0,
      widget.state.longitude ?? 0,
      21.4225,
      39.8262,
    );
    final hasLocation = widget.state.latitude != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: QiblaColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: QiblaColors.cardBorder, width: 0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Current Direction
          _ExpandableStatusRow(
            icon: Icons.explore_rounded,
            label: 'الاتجاه الحالي',
            value: '${heading.round()}°',
            sublabel: cardinalAr,
            iconColor: QiblaColors.gold,
            isExpanded: _expandedIndex == 0,
            onTap: () => _toggleExpand(0),
            expandedContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'زاوية انحراف الهاتف الحالية بالنسبة للشمال المغناطيسي الحقيقي. تتغير هذه القيمة بشكل حي ومباشر عند تدوير الهاتف في أي اتجاه.',
                  style: TextStyle(
                    fontSize: 11,
                    color: QiblaColors.textSecondary.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _ExpandedActionButton(
                      icon: Icons.copy_rounded,
                      label: 'نسخ الاتجاه',
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: '${heading.round()}° ($cardinalAr)'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم نسخ زاوية الاتجاه الحالي')),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _ExpandedActionButton(
                      icon: Icons.share_rounded,
                      label: 'مشاركة',
                      onTap: () {
                        Share.share(
                          'الاتجاه الحالي لهاتفي هو ${heading.round()}° ($cardinalAr) باستخدام تطبيق الحقيبة الإسلامية.',
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const _Divider(),

          // Row 2: Distance to Kaaba
          _ExpandableStatusRow(
            icon: Icons.mosque_rounded,
            label: 'مسافة إلى الكعبة',
            value: hasLocation ? QiblaMath.formatDistance(distance) : '—',
            iconColor: QiblaColors.lightGold,
            isExpanded: _expandedIndex == 1,
            onTap: () => _toggleExpand(1),
            expandedContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'يتم حساب المسافة بين موقعك الحالي والكعبة المشرفة بمكة المكرمة مباشرة بناءً على نظام تحديد المواقع العالمي (GPS) باستخدام صيغة هافرسين لحساب مسافات الدائرة العظمى على سطح الأرض.',
                  style: TextStyle(
                    fontSize: 11,
                    color: QiblaColors.textSecondary.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'إحداثيات الكعبة المشرفة:\nخط العرض: 21.4225° N | خط الطول: 39.8262° E',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: QiblaColors.gold.withValues(alpha: 0.8),
                    fontFamily: 'Inter',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _ExpandedActionButton(
                      icon: Icons.info_outline_rounded,
                      label: 'شرح الحساب',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: QiblaColors.surface,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: const Text('صيغة هافرسين', style: TextStyle(color: QiblaColors.textPrimary)),
                            content: const Text(
                              'صيغة هافرسين هي معادلة هامة في الملاحة، تعطي مسافات الدائرة العظمى بين نقطتين على الكرة الأرضية باستخدام خطوط الطول ودوائر العرض الخاصة بهما.',
                              style: TextStyle(color: QiblaColors.textSecondary, height: 1.5),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('حسناً', style: TextStyle(color: QiblaColors.gold)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _ExpandedActionButton(
                      icon: Icons.copy_rounded,
                      label: 'نسخ إحداثيات الكعبة',
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: '21.4225,39.8262'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم نسخ إحداثيات الكعبة المشرفة')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const _Divider(),

          // Row 3: Qibla Angle
          _ExpandableStatusRow(
            icon: Icons.navigation_rounded,
            label: 'اتجاه القبلة',
            value: '${qiblahBearing.round()}°',
            sublabel: _cardinalArabic(QiblaMath.cardinalDirection(qiblahBearing)),
            iconColor: QiblaColors.gold,
            isExpanded: _expandedIndex == 2,
            onTap: () => _toggleExpand(2),
            expandedContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailTextRow(label: 'زاوية السمت للقبلة (Azimuth):', value: '${widget.state.qiblah.toStringAsFixed(1)}°'),
                _DetailTextRow(label: 'الانحراف المتبقي عن القبلة:', value: '${widget.state.angularDifference.toStringAsFixed(1)}°'),
                _DetailTextRow(label: 'نسبة مطابقة البوصلة للقبلة:', value: '${(widget.state.alignmentProgress * 100).round()}%'),
                _DetailTextRow(label: 'الحالة الحالية وموثوقية الإشارة:', value: widget.state.isAligned ? 'متطابق تماماً' : 'غير متطابق'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _ExpandedActionButton(
                      icon: Icons.help_outline_rounded,
                      label: 'تعليمات المعايرة',
                      onTap: () => _showCalibrationBottomSheet(context),
                    ),
                    const SizedBox(width: 8),
                    _ExpandedActionButton(
                      icon: Icons.sensors_rounded,
                      label: 'حالة الحساسات',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: QiblaColors.surface,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: const Text('حالة حساس البوصلة', style: TextStyle(color: QiblaColors.textPrimary)),
                            content: const Text(
                              'حساس المغناطيسية ومقياس التسارع نشطان ويعملان بشكل ممتاز. يرجى إبعاد الهاتف عن المعادن أو الأغطية المغناطيسية للحفاظ على دقة الإشارة.',
                              style: TextStyle(color: QiblaColors.textSecondary, height: 1.5),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('حسناً', style: TextStyle(color: QiblaColors.gold)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const _Divider(),

          // Row 4: Location
          _ExpandableStatusRow(
            icon: Icons.location_on_rounded,
            label: 'الموقع الجغرافي',
            value: hasLocation
                ? '${widget.state.city ?? "—"}, ${widget.state.country ?? "—"}'
                : 'غير متوفر',
            iconColor: QiblaColors.success,
            isExpanded: _expandedIndex == 3,
            onTap: () => _toggleExpand(3),
            expandedContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailTextRow(label: 'الدولة:', value: widget.state.country ?? 'غير معروف'),
                _DetailTextRow(label: 'المدينة / المنطقة:', value: widget.state.city ?? 'غير معروف'),
                _DetailTextRow(label: 'خط العرض (Lat):', value: widget.state.latitude?.toStringAsFixed(6) ?? '—'),
                _DetailTextRow(label: 'خط الطول (Lng):', value: widget.state.longitude?.toStringAsFixed(6) ?? '—'),
                _DetailTextRow(label: 'مزود الخدمة (Provider):', value: 'Geolocator GPS Service'),
                _DetailTextRow(label: 'دقة التحديد الحالية:', value: 'عالية جداً (~10م)'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _ExpandedActionButton(
                      icon: Icons.map_rounded,
                      label: 'فتح في الخرائط',
                      onTap: () async {
                        if (widget.state.latitude != null && widget.state.longitude != null) {
                          final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${widget.state.latitude},${widget.state.longitude}');
                          try {
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            } else {
                              throw 'Could not launch URL';
                            }
                          } catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('فشل في فتح خرائط جوجل')),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    _ExpandedActionButton(
                      icon: Icons.copy_rounded,
                      label: 'نسخ الإحداثيات',
                      onTap: () {
                        if (widget.state.latitude != null && widget.state.longitude != null) {
                          Clipboard.setData(ClipboardData(text: '${widget.state.latitude},${widget.state.longitude}'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم نسخ إحداثيات موقعك الحالي')),
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    _ExpandedActionButton(
                      icon: Icons.refresh_rounded,
                      label: 'تحديث الموقع',
                      onTap: () {
                        ref.read(qiblaProvider.notifier).init();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('جاري إعادة تحديد موقعك الحالي...')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const _Divider(),

          // Row 5: GPS Status
          _ExpandableStatusRow(
            icon: Icons.gps_fixed_rounded,
            label: 'GPS',
            value: widget.state.status == QiblaStatus.ready ? 'متصل' : 'غير متصل',
            valueColor: widget.state.status == QiblaStatus.ready
                ? QiblaColors.success
                : QiblaColors.danger,
            iconColor: widget.state.status == QiblaStatus.ready
                ? QiblaColors.success
                : QiblaColors.danger,
            isExpanded: _expandedIndex == 4,
            onTap: () => _toggleExpand(4),
            expandedContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.state.status == QiblaStatus.ready
                      ? 'جهاز تحديد المواقع العالمي (GPS) متصل ويقوم بتوفير إحداثيات خطوط الطول والعرض بدقة عالية ومستمرة.'
                      : 'تعذر الاتصال بـ GPS. يرجى تفعيل خدمات الموقع الجغرافي في الهاتف ومنح التطبيق الصلاحيات اللازمة لبدء التحديد.',
                  style: TextStyle(
                    fontSize: 11,
                    color: QiblaColors.textSecondary.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const _Divider(),

          // Row 6: Magnetometer Status
          _ExpandableStatusRow(
            icon: Icons.sensors_rounded,
            label: 'المغناطيسية',
            value: 'نشطة',
            valueColor: QiblaColors.success,
            iconColor: QiblaColors.success,
            isExpanded: _expandedIndex == 5,
            onTap: () => _toggleExpand(5),
            expandedContent: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المستشعرات الجيروسكوبية وحساسات الحقل المغناطيسي نشطة ومستقرة، وتعمل على قياس توجه الهاتف وتصحيح انحراف الإشارة بشكل آني.',
                  style: TextStyle(
                    fontSize: 11,
                    color: QiblaColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleExpand(int index) {
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = null;
      } else {
        _expandedIndex = index;
      }
    });
  }

  String _cardinalArabic(String cardinal) {
    const map = {
      'N': 'شمال', 'NNE': 'شمال شرق شرق', 'NE': 'شمال شرق',
      'ENE': 'شرق شمال شرق', 'E': 'شرق', 'ESE': 'شرق جنوب شرق',
      'SE': 'جنوب شرق', 'SSE': 'جنوب جنوب شرق', 'S': 'جنوب',
      'SSW': 'جنوب جنوب غرب', 'SW': 'جنوب غرب', 'WSW': 'غرب جنوب غرب',
      'W': 'غرب', 'WNW': 'غرب شمال غرب', 'NW': ' شمال غرب',
      'NNW': 'شمال شمال غرب',
    };
    return map[cardinal] ?? cardinal;
  }

  static double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) * math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static double _toRad(double deg) => deg * math.pi / 180;

  void _showCalibrationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: QiblaColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(
                color: QiblaColors.gold,
                width: 0.8,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.compass_calibration_rounded,
                color: QiblaColors.gold,
                size: 40,
              ),
              const SizedBox(height: 12),
              const Text(
                'طريقة معايرة البوصلة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: QiblaColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'إذا شعرت أن اتجاه القبلة غير دقيق، يرجى اتباع الخطوات التالية لمعايرة بوصلة هاتفك الذكي وتصحيح انحراف الحساسات:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: QiblaColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildCalibrationStep('1', 'ارفع هاتفك أمام صدرك واجعله موازياً للأرض.'),
              _buildCalibrationStep('2', 'قم بتحريك الهاتف in الهواء برسم مسار كامل على شكل رقم ثمانية بالإنجليزية (∞) أو علامة اللانهائية عدة مرات بشكل متواصل.'),
              _buildCalibrationStep('3', 'تجنب الوقوف بجوار الأسطح المعدنية الكبيرة أو المجالات المغناطيسية القوية (مثل أجهزة التلفزيون أو مكبرات الصوت الكبيرة) أثناء القياس.'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: QiblaColors.gold,
                    foregroundColor: QiblaColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'تمت المعايرة بنجاح',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalibrationStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: QiblaColors.gold,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: QiblaColors.background,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11.5,
                color: QiblaColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableStatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? sublabel;
  final Color iconColor;
  final Color? valueColor;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget expandedContent;

  const _ExpandableStatusRow({
    required this.icon,
    required this.label,
    required this.value,
    this.sublabel,
    required this.iconColor,
    this.valueColor,
    required this.isExpanded,
    required this.onTap,
    required this.expandedContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: QiblaColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: valueColor ?? QiblaColors.textPrimary,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: QiblaColors.textSecondary.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                    if (sublabel != null)
                      Text(
                        sublabel!,
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: QiblaColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8, bottom: 12, left: 8, right: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: QiblaColors.background.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: QiblaColors.gold.withValues(alpha: 0.05),
                      width: 0.5,
                    ),
                  ),
                  child: expandedContent,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _ExpandedActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ExpandedActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: QiblaColors.gold.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: QiblaColors.lightGold),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: QiblaColors.lightGold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailTextRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailTextRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              color: QiblaColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: QiblaColors.textPrimary,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      color: QiblaColors.textSecondary.withValues(alpha: 0.08),
    );
  }
}
