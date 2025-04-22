import 'dart:convert';

class Artist {
  int? artistId;
  String name;
  String sex;
  String genre;
  DateTime birthDay;
  String nationality;
  String bio;
  DateTime debutDate;
  String avatar;

  Artist({
    this.artistId,
    required this.name,
    required this.sex,
    required this.genre,
    required this.birthDay,
    required this.nationality,
    required this.bio,
    required this.debutDate,
    required this.avatar,
  });

  Artist copyWith({
    int? artistId,
    String? name,
    String? sex,
    String? genre,
    DateTime? birthDay,
    String? nationality,
    String? bio,
    DateTime? debutDate,
    String? avatar,
  }) {
    return Artist(
      artistId: artistId ?? this.artistId,
      name: name ?? this.name,
      sex: sex ?? this.sex,
      genre: genre ?? this.genre,
      birthDay: birthDay ?? this.birthDay,
      nationality: nationality ?? this.nationality,
      bio: bio ?? this.bio,
      debutDate: debutDate ?? this.debutDate,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'artistId': artistId,
      'name': name,
      'sex': sex,
      'genre': genre,
      'birthDay': birthDay,
      'nationality': nationality,
      'bio': bio,
      'debutDate': debutDate,
      'avatar': avatar,
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      artistId: map['artistId'] != null ? map['artistId'] as int : null,
      name: map['name'] as String,
      sex: map['sex'] as String,
      genre: map['genre'] as String,
      birthDay: DateTime.parse(map['birthDay']),
      nationality: map['nationality'] as String,
      bio: map['bio'] as String,
      debutDate: DateTime.parse(map['debutDate']),
      avatar: map['avatar'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Artist.fromJson(String source) => Artist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Artist(artistId: $artistId, name: $name, sex: $sex, genre: $genre, birthDay: $birthDay, nationality: $nationality, bio: $bio, debuteDate: $debutDate, avatar: $avatar)';

  @override
  bool operator ==(covariant Artist other) {
    if (identical(this, other)) return true;

    return other.artistId == artistId &&
        other.name == name &&
        other.sex == sex &&
        other.genre == genre &&
        other.birthDay == birthDay &&
        other.nationality == nationality &&
        other.bio == bio &&
        other.debutDate == debutDate &&
        other.avatar == avatar;
  }

  @override
  int get hashCode =>
      artistId.hashCode ^
      name.hashCode ^
      sex.hashCode ^
      genre.hashCode ^
      birthDay.hashCode ^
      nationality.hashCode ^
      bio.hashCode ^
      debutDate.hashCode ^
      avatar.hashCode;
}
