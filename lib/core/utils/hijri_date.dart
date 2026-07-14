class HijriDate {
  final int year;
  final int month;
  final int day;

  HijriDate(this.year, this.month, this.day);

  static const List<String> monthNames = [
    'المحرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة'
  ];

  String get monthName => monthNames[month - 1];

  String format() => '$day $monthName $year هـ';

  @override
  String toString() => format();

  factory HijriDate.now() {
    return HijriDate.fromDate(DateTime.now());
  }

  factory HijriDate.fromDate(DateTime date, {int adjustment = 0}) {
    int y = date.year;
    int m = date.month;
    int d = date.day;

    if (m < 3) {
      y -= 1;
      m += 12;
    }

    int a = (y / 100).floor();
    int b = (a / 4).floor();
    int c = 2 - a + b;
    int e = (365.25 * (y + 4716)).floor();
    int f = (30.6001 * (m + 1)).floor();
    int jd = c + d + e + f - 1524 + adjustment;

    // Convert Julian Day to Hijri Epoch (Julian Day 1948439.5)
    double jdIslamic = jd - 1948440 + 0.5;
    int cyc = (jdIslamic / 10631).floor();
    double remainder = jdIslamic - (cyc * 10631);
    int yCycle = ((remainder * 30 + 15) / 10631).floor();
    int dayOfYear = (remainder - ((yCycle * 10631 + 14) / 30).floor()).round() + 1;

    int hYear = cyc * 30 + yCycle + 1;
    int hMonth = 0;
    int hDay = 0;

    List<int> monthLengths = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];
    bool isLeap = [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29].contains(yCycle % 30);
    if (isLeap) {
      monthLengths[11] = 30;
    }

    int accum = 0;
    for (int i = 0; i < 12; i++) {
      accum += monthLengths[i];
      if (dayOfYear <= accum) {
        hMonth = i + 1;
        hDay = dayOfYear - (accum - monthLengths[i]);
        break;
      }
    }

    if (hDay <= 0) hDay = 1;
    if (hMonth <= 0) hMonth = 1;
    if (hMonth > 12) hMonth = 12;

    return HijriDate(hYear, hMonth, hDay);
  }
}
