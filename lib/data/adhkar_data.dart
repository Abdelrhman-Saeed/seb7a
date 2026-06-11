// data/adhkar_data.dart
// بيانات الأذكار المدمجة في التطبيق

import '../models/dhikr_model.dart';

class AdhkarData {
  static List<DhikrModel> getDefaultAdhkar() => [
    DhikrModel(
      id: 'subhanallah',
      arabicText: 'سُبْحَانَ اللهِ',
      transliteration: 'Subhan Allah',
      meaning: 'تنزيهاً لله عن كل نقص',
      defaultTarget: 33,
      virtue: 'من أفضل الأذكار وأحبها إلى الله',
      hadith:
          'قال رسول الله ﷺ: "كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم"\n\nرواه البخاري ومسلم\n\nوقال ﷺ: "من قال سبحان الله وبحمده في يوم مائة مرة، حُطَّت خطاياه وإن كانت مثل زبد البحر"\n\nرواه البخاري',
    ),
    DhikrModel(
      id: 'alhamdulillah',
      arabicText: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'Alhamdulillah',
      meaning: 'الشكر والثناء كله لله',
      defaultTarget: 33,
      virtue: 'أثقل ما يوضع في الميزان',
      hadith:
          'قال رسول الله ﷺ: "الطهور شطر الإيمان، والحمد لله تملأ الميزان، وسبحان الله والحمد لله تملآن - أو تملأ - ما بين السماوات والأرض"\n\nرواه مسلم\n\nوقال ﷺ: "ما من شيء أثقل في ميزان المؤمن يوم القيامة من خلق حسن"\n\nرواه أبو داود والترمذي',
    ),
    DhikrModel(
      id: 'allahuakbar',
      arabicText: 'اللهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      meaning: 'الله أعظم من كل شيء',
      defaultTarget: 34,
      virtue: 'تعظيم الله وتكبيره',
      hadith:
          'قال رسول الله ﷺ: "أحب الكلام إلى الله أربع: سبحان الله، والحمد لله، ولا إله إلا الله، والله أكبر"\n\nرواه مسلم\n\nوقال ﷺ: "أفضل الذكر لا إله إلا الله، وأفضل الدعاء الحمد لله"\n\nرواه الترمذي وابن ماجه',
    ),
    DhikrModel(
      id: 'lailahaillallah',
      arabicText: 'لَا إِلَهَ إِلَّا اللهُ',
      transliteration: 'La ilaha illa Allah',
      meaning: 'لا معبود بحق إلا الله وحده',
      defaultTarget: 100,
      virtue: 'أفضل الذكر وكلمة التوحيد',
      hadith:
          'قال رسول الله ﷺ: "أفضل الذكر لا إله إلا الله"\n\nرواه الترمذي\n\nوقال ﷺ: "من قال لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير في يوم مائة مرة، كانت له عَدل عشر رقاب، وكُتبت له مائة حسنة، ومُحيت عنه مائة سيئة، وكانت له حرزاً من الشيطان"\n\nرواه البخاري',
    ),
    DhikrModel(
      id: 'lahawalawaquwwa',
      arabicText: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ',
      transliteration: 'La hawla wala quwwata illa billah',
      meaning: 'لا تحوّل عن معصية ولا قوة على طاعة إلا بالله',
      defaultTarget: 100,
      virtue: 'كنز من كنوز الجنة',
      hadith:
          'قال رسول الله ﷺ لأبي موسى الأشعري: "ألا أدلك على كنز من كنوز الجنة؟" قلت: بلى يا رسول الله. قال: "لا حول ولا قوة إلا بالله"\n\nرواه البخاري ومسلم\n\nوقال ﷺ: "أكثروا من قول لا حول ولا قوة إلا بالله، فإنها كنز من كنوز الجنة"\n\nرواه أحمد',
    ),
    DhikrModel(
      id: 'astaghfirullah',
      arabicText: 'أَسْتَغْفِرُ اللهَ',
      transliteration: 'Astaghfirullah',
      meaning: 'أطلب من الله أن يغفر ذنوبي',
      defaultTarget: 100,
      virtue: 'يمحو الذنوب ويفتح أبواب الرزق',
      hadith:
          'قال الله تعالى: ﴿فَقُلْتُ اسْتَغْفِرُوا رَبَّكُمْ إِنَّهُ كَانَ غَفَّارًا * يُرْسِلِ السَّمَاءَ عَلَيْكُم مِّدْرَارًا﴾\n\nسورة نوح: 10-11\n\nوقال رسول الله ﷺ: "من أكثر من الاستغفار جعل الله له من كل هم فرجاً، ومن كل ضيق مخرجاً، ورزقه من حيث لا يحتسب"\n\nرواه أبو داود وابن ماجه',
    ),
    DhikrModel(
      id: 'salatnabi',
      arabicText: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
      transliteration: 'Allahumma salli wa sallim ala nabiyyina Muhammad',
      meaning: 'اللهم صلّ على النبي محمد وسلّم عليه',
      defaultTarget: 100,
      virtue: 'يزيد في الرزق ويكفّر الذنوب ويرفع الدرجات',
      hadith:
          'قال رسول الله ﷺ: "من صلى عليّ صلاةً واحدة صلى الله عليه عشراً"\n\nرواه مسلم\n\nوقال ﷺ: "البخيل الذي من ذُكرت عنده فلم يصل عليّ"\n\nرواه الترمذي\n\nوقال ﷺ: "أولى الناس بي يوم القيامة أكثرهم عليّ صلاة"\n\nرواه الترمذي',
    ),
  ];

  // أذكار الصباح والمساء حسب الوقت
  static List<String> getMorningDhikrIds() =>
      ['subhanallah', 'alhamdulillah', 'allahuakbar', 'lailahaillallah'];

  static List<String> getEveningDhikrIds() =>
      ['astaghfirullah', 'lahawalawaquwwa', 'salatnabi'];

  // الإنجازات
  static List<Map<String, dynamic>> getAchievements() => [
    {
      'id': 'first_100',
      'title': 'أول مئة',
      'description': 'أكملت ١٠٠ تسبيحة',
      'icon': '🌟',
      'requiredCount': 100,
    },
    {
      'id': 'first_1000',
      'title': 'ألف تسبيحة',
      'description': 'أكملت ١٠٠٠ تسبيحة',
      'icon': '⭐',
      'requiredCount': 1000,
    },
    {
      'id': 'first_10000',
      'title': 'عشرة آلاف',
      'description': 'أكملت ١٠,٠٠٠ تسبيحة',
      'icon': '🏆',
      'requiredCount': 10000,
    },
    {
      'id': 'first_100000',
      'title': 'مئة ألف',
      'description': 'أكملت ١٠٠,٠٠٠ تسبيحة',
      'icon': '👑',
      'requiredCount': 100000,
    },
    {
      'id': 'streak_7',
      'title': 'أسبوع متواصل',
      'description': 'سبّحت ٧ أيام متتالية',
      'icon': '🔥',
      'requiredCount': 7,
    },
    {
      'id': 'streak_30',
      'title': 'شهر من الذكر',
      'description': 'سبّحت ٣٠ يوماً متتالياً',
      'icon': '💎',
      'requiredCount': 30,
    },
  ];
}
