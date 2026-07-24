class DuaCategory {
  final String id;
  final String title;
  final String description;

  const DuaCategory({
    required this.id,
    required this.title,
    required this.description,
  });
}

class DuaItem {
  final String id;
  final String title;
  final String subtitle;
  final String fullText;
  final String categoryId;
  final String? source;

  const DuaItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.fullText,
    required this.categoryId,
    this.source,
  });
}

const List<DuaCategory> kDuaCategories = [
  DuaCategory(
    id: 'mercy',
    title: 'أدعية الرحمة',
    description: 'أدعية مستجابة للمتوفين بالرحمة والمغفرة',
  ),
  DuaCategory(
    id: 'forgiveness',
    title: 'أدعية المغفرة',
    description: 'اسأل الله المغفرة والعفو لمن أحببت',
  ),
  DuaCategory(
    id: 'parents',
    title: 'دعاء للوالدين',
    description: 'أدعية للوالدين أجمعين بالرحمة والمغفرة',
  ),
  DuaCategory(
    id: 'need',
    title: 'دعاء قضاء الحاجة',
    description: 'أدعية لقضاء الحوائج والكرب',
  ),
  DuaCategory(
    id: 'prayer',
    title: 'أدعية بعد الصلاة',
    description: 'أدعية مأثورة تقال بعد كل صلاة',
  ),
  DuaCategory(
    id: 'quran',
    title: 'أدعية من القرآن',
    description: 'أدعية قرآنية عظيمة الشأن',
  ),
  DuaCategory(
    id: 'ahlulbayt',
    title: 'أدعية أهل البيت (ع)',
    description: 'أدعية من وصايا أهل البيت الطاهرين',
  ),
];

const List<DuaItem> kDuaItems = [
  DuaItem(
    id: 'mercy_1',
    title: 'دعاء الرحمة للمتوفى',
    subtitle: 'اللهم ارحمه واغفر له',
    fullText:
        'اللهم ارحمه رحمة واسعةً، واغفر له ذنوبه، وعافه في قبره، ونوّر له فيه، وافسح له في قبره، وارزقه حسن الخاتمة.',
    categoryId: 'mercy',
    source: 'أدعية مأثورة',
  ),
  DuaItem(
    id: 'mercy_2',
    title: 'دعاء لراحة البال',
    subtitle: 'اللهم اجعل قبره روضة من رياض الجنة',
    fullText:
        'اللهم اجعل قبره روضة من رياض الجنة، ولا تجعله حفرة من حفر النار، اللهم اجعله نوراً حيثما كان، وارحم ضعفه ومسقطه.',
    categoryId: 'mercy',
    source: 'أدعية مأثورة',
  ),
  DuaItem(
    id: 'mercy_3',
    title: 'دعاء للميت عند القبر',
    subtitle: 'اللهم ثبته عند السؤال',
    fullText:
        'اللهم ثبته عند السؤال، واجعل قبره رياضاً من رياض الجنة، ولا تجعله حفرة من حفر النار، اللهم ارحم غربته ووحشته في قبره.',
    categoryId: 'mercy',
    source: 'أدعية مأثورة',
  ),
  DuaItem(
    id: 'mercy_4',
    title: 'دعاء للمتوفى في الليل',
    subtitle: 'اللهم ارحم موتانا وموتى المسلمين',
    fullText:
        'اللهم ارحم موتانا وموتى المسلمين، واغفر لهم وارحمهم، وعافهم واعفو عنهم، وأكرم نزلهم، ووسع مدخلهم، واغسلهم بالماء والثلج والبرد، ونقّهم من الذنوب والخطايا كما يُنقّى الثوب الأبيض من الدنس.',
    categoryId: 'mercy',
    source: 'أدعية مأثورة',
  ),
  DuaItem(
    id: 'forgiveness_1',
    title: 'دعاء الاستغفار للمتوفى',
    subtitle: 'أغفر له وارحمه',
    fullText:
        'اللهم اغفر له ذنوبه كلها، دِقّها وجلّها، وآخرها وأولها، وعلانيتها وسرّها، اللهم اغفر له ما قدّم وما أخّر، وما أسرّ وما أعلنت.',
    categoryId: 'forgiveness',
    source: 'أدعية مأثورة',
  ),
  DuaItem(
    id: 'forgiveness_2',
    title: 'دعاء العفو والصفح',
    subtitle: 'اللهم اعفو عنه وسامحه',
    fullText:
        'اللهم اعفو عنه، وسامحه، وتجاوز عن سيئاته، وادخله الفردوس الأعلى بغير حساب ولا سابق عذاب، برحمتك يا أرحم الراحمين.',
    categoryId: 'forgiveness',
    source: 'أدعية مأثورة',
  ),
  DuaItem(
    id: 'parents_1',
    title: 'دعاء للوالدين',
    subtitle: 'اللهم ارحمهما كما ربيانا صغيراً',
    fullText:
        'اللهم ارحمهما كما ربيانا صغيراً، واغفر لهما كما يغفر الوالدان لصغيرهما، اللهم لا تحرمني أجرهما ولا تفتنّي بعدهما واغفر لنا ولهما.',
    categoryId: 'parents',
    source: 'صحيح مسلم',
  ),
  DuaItem(
    id: 'parents_2',
    title: 'دعاء للوالدين المتوفيين',
    subtitle: 'رب ارحماهما',
    fullText:
        'رَّبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا، اللهم ارحمهما في الآخرة كما ربيانا صغيراً، واجعل قبرهما نوراً وارزقهما حسن الخاتمة.',
    categoryId: 'parents',
    source: 'سورة الإسراء: 24',
  ),
  DuaItem(
    id: 'need_1',
    title: 'دعاء لقضاء حاجة المتوفى',
    subtitle: 'اللهم اقضِ حوائجه',
    fullText:
        'اللهم اقضِ حوائجه التي عندك، وارفع درجاته، ونقّه من الذنوب والخطايا كما يُنقّى الثوب الأبيض من الدنس، وابدّل بداره خيراً من داره، وبأهله خيراً من أهله.',
    categoryId: 'need',
    source: 'أدعية مأثورة',
  ),
  DuaItem(
    id: 'need_2',
    title: 'دعاء لراحة نفس المتوفى',
    subtitle: 'اللهم نوّر قبره',
    fullText:
        'اللهم نوّر قبره، وافتح له باباً إلى الجنة، واغلق عنه باباً إلى النار، وآنس وحشته، وارزقه لذة النظر إلى وجهك الكريم.',
    categoryId: 'need',
    source: 'أدعية مأثورة',
  ),
  DuaItem(
    id: 'prayer_1',
    title: 'دعاء بعد الصلاة للمتوفى',
    subtitle: 'اللهم صلّ على محمد',
    fullText:
        'اللهم صلّ على محمد وعلى آل محمد كما صليت على إبراهيم وعلى آل إبراهيم إنك حميد مجيد، اللهم بارك على محمد وعلى آل محمد كما باركت على إبراهيم وعلى آل إبراهيم إنك حميد مجيد. اللهم ارحم موتانا وموتى المسلمين.',
    categoryId: 'prayer',
    source: 'صحيح البخاري ومسلم',
  ),
  DuaItem(
    id: 'prayer_2',
    title: 'أذكار بعد الصلاة مع الدعاء',
    subtitle: 'أستغفر الله',
    fullText:
        'أستغفر الله (ثلاثاً)، اللهم أنت السلام ومنك السلام تباركت يا ذا الجلال والإكرام. لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير، لا حوة ولا قوة إلا بالله، لا إله إلا الله ولا نعبد إلا إياه، له النعمة وله الفضل وله الثناء الحسن، لا إله إلا الله مخلصين له الدين ولو كره الكافرون. اللهم ارحم موتانا وموتى المسلمين.',
    categoryId: 'prayer',
    source: 'صحيح مسلم',
  ),
  DuaItem(
    id: 'quran_1',
    title: 'دعاء ربنا آتنا',
    subtitle: 'من سورة البقرة',
    fullText:
        'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ، اللهم اجعل هذه الحسنات لمن أحببت.',
    categoryId: 'quran',
    source: 'سورة البقرة: 201',
  ),
  DuaItem(
    id: 'quran_2',
    title: 'دعاء أصحاب الأخدود',
    subtitle: 'من سورة الكهف',
    fullText:
        'رَبَّنَا آتِنَا مِن لَّدُنكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا، اللهم ارحم من فارقنا واجمعنا بهم في الفردوس الأعلى.',
    categoryId: 'quran',
    source: 'سورة الكهف: 10',
  ),
  DuaItem(
    id: 'quran_3',
    title: 'دعاء يونس عليه السلام',
    subtitle: 'من سورة الأنبياء',
    fullText:
        'لَّا إِلَهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ، اللهم ارحمنا برحمتك الواسعة.',
    categoryId: 'quran',
    source: 'سورة الأنبياء: 87',
  ),
  DuaItem(
    id: 'ahlulbayt_1',
    title: 'دعاء الهم والحزن',
    subtitle: 'من أدعية الإمام علي (ع)',
    fullText:
        'اللهم بدل حزني فرحاً، وبدّل همي فرجاً، وبدّل فقرني غنىً، وبدّل ذلي عزّاً، اللهم ارحم من فقدناه واجمعنا به في الجنة.',
    categoryId: 'ahlulbayt',
    source: 'الإمام علي (ع)',
  ),
  DuaItem(
    id: 'ahlulbayt_2',
    title: 'دعاء عرفة',
    subtitle: 'من أدعية الإمام الحسين (ع)',
    fullText:
        'اللهم ارحم تائهنا، واغفر جاهلينا، واقبل معذرتنا، وأحسن في عيوبنا نظرتنا، اللهم ارحم من في قبره وحيداً واحشده.',
    categoryId: 'ahlulbayt',
    source: 'الإمام الحسين (ع)',
  ),
  DuaItem(
    id: 'ahlulbayt_3',
    title: 'دعاء للموتى',
    subtitle: 'من دعاء الإمام الحسن العسكري (ع)',
    fullText:
        'اللهم ارحم موتانا وموتى المسلمين، وعفو عنهم، وأدخلهم جنّتك مع الأبرار، اللهم اغفر لحينا وميّتنا، وشاهدنا وغائبنا، وصغيرنا وكبيرنا، وزوجنا.',
    categoryId: 'ahlulbayt',
    source: 'الإمام الحسن العسكري (ع)',
  ),
  DuaItem(
    id: 'ahlulbayt_4',
    title: 'دعاء الصباح للمتوفى',
    subtitle: 'من وصايا الأئمة (ع)',
    fullText:
        'أسألك بحق محمد وآل محمد أن ترحم من في قبره وتنوّر عليه، وتسكنه فسيح جنّتك، وغفر له ذنوبه وخطاياه.',
    categoryId: 'ahlulbayt',
    source: 'أدعية أهل البيت (ع)',
  ),
];
