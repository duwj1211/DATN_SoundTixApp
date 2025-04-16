import 'dart:convert';

class Language {
  int? languageId;
  String name;
  String defaultValue;
  String valueVie;
  String valueEng;

  Language({
    this.languageId,
    required this.name,
    required this.defaultValue,
    required this.valueVie,
    required this.valueEng,
  });

  Language copyWith({
    int? languageId,
    String? name,
    String? defaultValue,
    String? valueVie,
    String? valueEng,
  }) {
    return Language(
      languageId: languageId ?? this.languageId,
      name: name ?? this.name,
      defaultValue: defaultValue ?? this.defaultValue,
      valueVie: valueVie ?? this.valueVie,
      valueEng: valueEng ?? this.valueEng,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'languageId': languageId,
      'name': name,
      'defaultValue': defaultValue,
      'valueVie': valueVie,
      'valueEng': valueEng,
    };
  }

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      languageId: map['languageId'] != null ? map['languageId'] as int : null,
      name: map['name'] as String,
      defaultValue: map['defaultValue'] as String,
      valueVie:  map['valueVie'] as String,
      valueEng:  map['valueEng'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Language.fromJson(String source) => Language.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Artist(languageId: $languageId, name: $name, defaultValue: $defaultValue, valueVie: $valueVie, valueEnd: $valueEng)';

  @override
  bool operator ==(covariant Language other) {
    if (identical(this, other)) return true;

    return other.languageId == languageId &&
        other.name == name &&
        other.defaultValue == defaultValue &&
        other.valueVie == valueVie &&
        other.valueEng == valueEng;
  }

  @override
  int get hashCode => languageId.hashCode ^ name.hashCode ^ defaultValue.hashCode ^ valueVie.hashCode ^ valueEng.hashCode;
}
