class ShiaBookInfo {
  final String id;
  final String nameArabic;
  final String nameEnglish;
  final int hadithCount;

  const ShiaBookInfo({
    required this.id,
    required this.nameArabic,
    this.nameEnglish = '',
    this.hadithCount = 0,
  });

  factory ShiaBookInfo.fromId(String bookId) {
    const bookNames = <String, (String, String)>{
      'Alkafi_v1': ('الكافي - النيات والاعتقادات', 'الكافي: النيات والاعتقادات'),
      'Alkafi_v2': ('الكافي - الفروع', 'الكافي: الفروع'),
      'Alkafi_v3': ('الكافي - الأصول', 'الكافي: الأصول'),
      'Alkafi_v4': ('الكافي - الفروع (4)', 'الكافي: الفروع (4)'),
      'Alkafi_v5': ('الكافي - الفروع (5)', 'الكافي: الفروع (5)'),
      'Alkafi_v6': ('الكافي - الروضة', 'الكافي: الروضة'),
      'Alkafi_v7': ('الكافي - الفروع (7)', 'الكافي: الفروع (7)'),
      'Alkafi_v8': ('الكافي - متنوعة', 'الكافي: متنوعة'),
      'Fadaail_elshia': ('فضائل الشيعة', 'فضائل الشيعة'),
      'Al_Amaal': ('الأعمال', 'الأعمال'),
      'ALkhisal': ('الخصال', 'الخصال'),
      'AlTawhid': ('التوحيد', 'التوحيد'),
      'KamilAlZiyarat': ('كامل الزيارات', 'كامل الزيارات'),
      'kitabAlGhayba': ('كتاب الغيبة (1)', 'كتاب الغيبة (1)'),
      'kitabAlGhayba2': ('كتاب الغيبة (2)', 'كتاب الغيبة (2)'),
      'MujamaaAlAhadithAlMutabara': ('مجمع الأحاديث المعتبرة', 'مجمع الأحاديث المعتبرة'),
      'RijalIbnALGhadairy': ('رجال ابن الغضائري', 'رجال ابن الغضائري'),
      'ShifatAlShia': ('شيعة الشيعة', 'شيعة الشيعة'),
      'ThawabAlAmalWaIqabAlaamal': ('ثواب الأعمال وعقاب الأعمال', 'ثواب الأعمال وعقاب الأعمال'),
      'UyonAkhbarAlRidaV1': ('عيونأخبار الرضا (1)', 'عيونأخبار الرضا (1)'),
      'UyonAkhbarAlRidaV2': ('عيونأخبار الرضا (2)', 'عيونأخبار الرضا (2)'),
    };

    final names = bookNames[bookId];
    return ShiaBookInfo(
      id: bookId,
      nameArabic: names?.$1 ?? bookId,
      nameEnglish: names?.$2 ?? '',
    );
  }

  static const allBookIds = [
    'Alkafi_v1', 'Alkafi_v2', 'Alkafi_v3', 'Alkafi_v4',
    'Alkafi_v5', 'Alkafi_v6', 'Alkafi_v7', 'Alkafi_v8',
    'Fadaail_elshia', 'Al_Amaal', 'ALkhisal', 'AlTawhid',
    'KamilAlZiyarat', 'kitabAlGhayba', 'kitabAlGhayba2',
    'MujamaaAlAhadithAlMutabara', 'RijalIbnALGhadairy',
    'ShifatAlShia', 'ThawabAlAmalWaIqabAlaamal',
    'UyonAkhbarAlRidaV1', 'UyonAkhbarAlRidaV2',
  ];

  static List<ShiaBookInfo> get allBooks =>
      allBookIds.map(ShiaBookInfo.fromId).toList();
}

class ShiaHadith {
  final int number;
  final String bookId;
  final String text;
  final String? subject;
  final String? chain;
  final String? narrator;
  final Map<String, dynamic>? raw;

  const ShiaHadith({
    required this.number,
    required this.bookId,
    required this.text,
    this.subject,
    this.chain,
    this.narrator,
    this.raw,
  });

  factory ShiaHadith.fromJson(Map<String, dynamic> json, String bookId) {
    final text = (json['text'] ??
            json['body'] ??
            json['hadith'] ??
            json['content'] ??
            '')
        .toString()
        .trim();
    final number = _parseInt(json['number'] ?? json['hadithNumber'] ?? json['id'] ?? json['index'] ?? 0);

    return ShiaHadith(
      number: number,
      bookId: bookId,
      text: text,
      subject: json['subject']?.toString() ?? json['topic']?.toString(),
      chain: json['chain']?.toString() ?? json['isnad']?.toString(),
      narrator: json['narrator']?.toString() ?? json['rawi']?.toString(),
      raw: json,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  String get sourceDisplayName {
    final info = ShiaBookInfo.fromId(bookId);
    return info.nameArabic;
  }

  String get formattedReference {
    final info = ShiaBookInfo.fromId(bookId);
    return 'الكافي ${info.nameArabic} — حديث $number';
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'bookId': bookId,
        'text': text,
        'subject': subject,
        'chain': chain,
        'narrator': narrator,
      };

  factory ShiaHadith.fromLocalJson(Map<String, dynamic> json) {
    return ShiaHadith(
      number: json['number'] ?? 0,
      bookId: json['bookId'] ?? '',
      text: json['text'] ?? '',
      subject: json['subject'],
      chain: json['chain'],
      narrator: json['narrator'],
      raw: json['raw'],
    );
  }
}
