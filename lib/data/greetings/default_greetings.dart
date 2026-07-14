import '../../models/greeting.dart';
import '../../models/greeting_period.dart';

const Map<GreetingPeriod, List<GreetingEntry>> defaultGreetings = {
  GreetingPeriod.fajr: [
    GreetingEntry(
      title: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
      subtitle: 'مع فجر جديد، ابدأ يومك بسكينة القلب',
    ),
    GreetingEntry(
      title: 'صَبَاحُ الخَيْر',
      subtitle: 'أسأل الله أن يملأ يومك نوراً وطمأنينة',
    ),
    GreetingEntry(
      title: 'رَبِّ اشْرَحْ لِي صَدْرِي',
      subtitle: 'في هذه الساعات الهادئة، ادعُ الله بسكينة',
    ),
    GreetingEntry(
      title: 'ذِكْرٌ فِي سَكِينَة',
      subtitle: 'اللهم بارك لنا في هذا الصباح وسهّل أمورنا',
    ),
    GreetingEntry(
      title: 'نَوْرٌ مِنَ الرَّحْمَن',
      subtitle: 'اللهم اجعل هذا اليوم خيراً من الليالي التي مضت',
    ),
  ],
  GreetingPeriod.morning: [
    GreetingEntry(
      title: 'أَصْبَحْنَا وَأَصْبَحَ المُلْكُ لِلَّه',
      subtitle: 'تملأ القلوب سكينة حين نتذكّر نعم الله',
    ),
    GreetingEntry(
      title: 'اللَّهُمَّ بَارِكْ لَنَا فِي يَوْمِنَا',
      subtitle: 'كن لله شاكراً في كل خطوة من يومك',
    ),
    GreetingEntry(
      title: 'صَبَاحُ الطُّمَأْنِينَة',
      subtitle: 'في كل نَفَسٍ فيه صحة وسلام، فرصة للحمد',
    ),
    GreetingEntry(
      title: 'حَمْدٌ عَلَى نِعْمَةِ الصَّحْوَة',
      subtitle: 'اللهم اهدِ قلوبنا واحفظ أيامنا برحمتك',
    ),
    GreetingEntry(
      title: 'يَوْمٌ جَدِيدٌ مَعَ الرَّحْمَن',
      subtitle: 'ألقي أموري لله وأبدأ يومي بحسن الظن',
    ),
  ],
  GreetingPeriod.dhuhr: [
    GreetingEntry(
      title: 'اللَّهُمَّ أَنْزِلْ عَلَيْنَا سَكِينَةً',
      subtitle: 'في منتصف اليوم، توقّف واذكر الله',
    ),
    GreetingEntry(
      title: 'ذِكْرٌ فِي وَسَطِ النَّهَار',
      subtitle: 'اللهم بارك لنا في ساعات الظهيرة وسهّل شؤوننا',
    ),
    GreetingEntry(
      title: 'سَكِينَةٌ فِي الظُّهْرَاء',
      subtitle: 'توقّف لحظة واصبر، فإن الله مع الصابرين',
    ),
    GreetingEntry(
      title: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّد',
      subtitle: 'في هذا الوقت ضع همومك بين يدي الله',
    ),
    GreetingEntry(
      title: 'صَبْرٌ وَحُسْنُ الظَّنّ',
      subtitle: 'كل صعوبة تمر، والفرج من عند الله',
    ),
  ],
  GreetingPeriod.asr: [
    GreetingEntry(
      title: 'اللَّهُمَّ اقْضِ عَنَّا الدَّيْن',
      subtitle: 'في وقت العصر، اسأل الله تيسير أمورك',
    ),
    GreetingEntry(
      title: 'صَبْرٌ فِي أَحْزَانِنَا',
      subtitle: 'اللهم اجعل صبرنا شكراً واجعل آجالنا خيراً',
    ),
    GreetingEntry(
      title: 'أَسْبَابُ الرَّحْمَة',
      subtitle: 'احمل في قلبك رجاء الله ولا تخف من الغد',
    ),
    GreetingEntry(
      title: 'حُسْنُ الظَّنِّ بِاللَّه',
      subtitle: 'في ساعات العصر، توكّل على الله وألقِ همومك',
    ),
    GreetingEntry(
      title: 'اللَّهُمَّ رَوِّحْ عَنَّا',
      subtitle: 'اللهم أسعد قلوبنا وارزقنا الطمأنينة',
    ),
  ],
  GreetingPeriod.maghrib: [
    GreetingEntry(
      title: 'مَغْرِبُ السَّكِينَة',
      subtitle: 'مع غروب الشمس، ألقي يومي لله',
    ),
    GreetingEntry(
      title: 'اللَّهُمَّ تَوَفَّنَا مُسْلِمِين',
      subtitle: 'في وقت المغرب، احمد الله على نعم اليوم',
    ),
    GreetingEntry(
      title: 'حَمْدٌ وَشُكْرٌ لِلَّه',
      subtitle: 'اللهم بارك لنا في مسائنا وارزقنا الخير',
    ),
    GreetingEntry(
      title: 'رَحْمَةٌ فِي الْمَغْرِب',
      subtitle: 'ألقي أموري كلها لله وألقي همي عليه',
    ),
    GreetingEntry(
      title: 'اللَّهُمَّ ارْحَمْنَا',
      subtitle: 'في هذه الساعة المباركة، ادعُ الله بصدق',
    ),
  ],
  GreetingPeriod.evening: [
    GreetingEntry(
      title: 'مَسَاءُ الْخَيْر',
      subtitle: 'أسأل الله أن يملأ مسائك سكينة وطمأنينة',
    ),
    GreetingEntry(
      title: 'اللَّهُمَّ أَصْلِحْ لَنَا دِينَنَا',
      subtitle: 'في ساعات المساء، تدبّر آلاء الله عليك',
    ),
    GreetingEntry(
      title: 'سَكِينَةُ الْعِشَاء',
      subtitle: 'اللهم بارك لنا في ليلتنا واغفر ذنوبنا',
    ),
    GreetingEntry(
      title: 'ذِكْرٌ بَعْدَ الْعَمَل',
      subtitle: 'احمد الله على ما أنعم واصفح عمن أساء إليك',
    ),
    GreetingEntry(
      title: 'اللَّهُمَّ تَوَكَّلْتُ عَلَيْك',
      subtitle: 'ألقِ همومك على الله فإنه لا يضيع أجر المحسنين',
    ),
  ],
  GreetingPeriod.midnight: [
    GreetingEntry(
      title: 'سَاعَةُ الْإِجَابَة',
      subtitle: 'في جوف الليل، الله أقرب إليك من شراك نعلك',
    ),
    GreetingEntry(
      title: 'اللَّهُمَّ اغْفِرْ لَنَا',
      subtitle: 'توب إلى الله في هذه الساعات المباركة',
    ),
    GreetingEntry(
      title: 'سُبْحَانَ اللَّه فِي الظُّلُمَات',
      subtitle: 'في سكون الليل، ذكّر نفسك بعظمة الله',
    ),
    GreetingEntry(
      title: 'لَيْلٌ مُبَارَكٌ',
      subtitle: 'اللهم اجعل ليلتنا نوراً وآجالنا خيراً',
    ),
    GreetingEntry(
      title: 'وَسْوَسَةُ الْقَلْبِ إِلَى اللَّه',
      subtitle: 'في هذه الساعة، الله يتودّد إلى عباده الصالحين',
    ),
  ],
};
