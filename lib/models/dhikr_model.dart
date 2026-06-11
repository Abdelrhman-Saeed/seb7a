// models/dhikr_model.dart
// نموذج بيانات الذكر

class DhikrModel {
  final String id;
  final String arabicText;
  final String transliteration;
  final String meaning;
  final String virtue; // فضل الذكر
  final String hadith; // الحديث المرتبط
  final bool isCustom; // هل هو مخصص من المستخدم
  final int defaultTarget; // الهدف الافتراضي

  DhikrModel({
    required this.id,
    required this.arabicText,
    this.transliteration = '',
    this.meaning = '',
    this.virtue = '',
    this.hadith = '',
    this.isCustom = false,
    this.defaultTarget = 33,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'arabicText': arabicText,
    'transliteration': transliteration,
    'meaning': meaning,
    'virtue': virtue,
    'hadith': hadith,
    'isCustom': isCustom,
    'defaultTarget': defaultTarget,
  };

  factory DhikrModel.fromMap(Map<String, dynamic> map) => DhikrModel(
    id: map['id'],
    arabicText: map['arabicText'],
    transliteration: map['transliteration'] ?? '',
    meaning: map['meaning'] ?? '',
    virtue: map['virtue'] ?? '',
    hadith: map['hadith'] ?? '',
    isCustom: map['isCustom'] ?? false,
    defaultTarget: map['defaultTarget'] ?? 33,
  );

  DhikrModel copyWith({
    String? id,
    String? arabicText,
    String? transliteration,
    String? meaning,
    String? virtue,
    String? hadith,
    bool? isCustom,
    int? defaultTarget,
  }) =>
      DhikrModel(
        id: id ?? this.id,
        arabicText: arabicText ?? this.arabicText,
        transliteration: transliteration ?? this.transliteration,
        meaning: meaning ?? this.meaning,
        virtue: virtue ?? this.virtue,
        hadith: hadith ?? this.hadith,
        isCustom: isCustom ?? this.isCustom,
        defaultTarget: defaultTarget ?? this.defaultTarget,
      );
}
