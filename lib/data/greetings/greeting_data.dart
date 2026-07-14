import '../../models/greeting.dart';
import '../../models/greeting_period.dart';
import 'muharram_greetings.dart';
import 'safar_greetings.dart';
import 'rabi_al_awwal_greetings.dart';
import 'rabi_al_thani_greetings.dart';
import 'jumada_al_ula_greetings.dart';
import 'jumada_al_akhirah_greetings.dart';
import 'rajab_greetings.dart';
import 'shaban_greetings.dart';
import 'ramadan_greetings.dart';
import 'shawwal_greetings.dart';
import 'dhu_al_qadah_greetings.dart';
import 'dhu_al_hijjah_greetings.dart';

export 'muharram_greetings.dart';
export 'safar_greetings.dart';
export 'rabi_al_awwal_greetings.dart';
export 'rabi_al_thani_greetings.dart';
export 'jumada_al_ula_greetings.dart';
export 'jumada_al_akhirah_greetings.dart';
export 'rajab_greetings.dart';
export 'shaban_greetings.dart';
export 'ramadan_greetings.dart';
export 'shawwal_greetings.dart';
export 'dhu_al_qadah_greetings.dart';
export 'dhu_al_hijjah_greetings.dart';
export 'special_occasions.dart';

const Map<int, Map<GreetingPeriod, List<GreetingEntry>>> monthlyGreetings = {
  1: muharramGreetings,
  2: safarGreetings,
  3: rabiAlAwwalGreetings,
  4: rabiAlThaniGreetings,
  5: jumadaAlUlaGreetings,
  6: jumadaAlAkhirahGreetings,
  7: rajabGreetings,
  8: shabanGreetings,
  9: ramadanGreetings,
  10: shawwalGreetings,
  11: dhuAlQadahGreetings,
  12: dhuAlHijjahGreetings,
};
