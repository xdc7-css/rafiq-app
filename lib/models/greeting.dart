import 'greeting_period.dart';

class GreetingEntry {
  final String title;
  final String subtitle;

  const GreetingEntry({required this.title, this.subtitle = ''});
}

enum GreetingPriority { occasion, monthly, defaults }

class GreetingOccasion {
  final int hijriMonth;
  final int hijriDay;
  final String name;
  final List<GreetingEntry> greetings;

  const GreetingOccasion({
    required this.hijriMonth,
    required this.hijriDay,
    required this.name,
    required this.greetings,
  });

  bool matches(int month, int day) => hijriMonth == month && hijriDay == day;
}

class GreetingResult {
  final String title;
  final String subtitle;
  final GreetingPeriod period;
  final GreetingPriority priority;
  final String? occasionName;
  final int hijriMonth;

  const GreetingResult({
    required this.title,
    this.subtitle = '',
    required this.period,
    required this.priority,
    this.occasionName,
    this.hijriMonth = 0,
  });
}
