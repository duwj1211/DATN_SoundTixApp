import 'dart:convert';

class User {
  int? userId;
  String userName;
  String email;
  String phoneNumber;
  String passWord;
  String fullName;
  String role;
  DateTime birthDay;
  String sex;
  String status;
  String avatar;
  String qrCode;
  DateTime dateAdded;
  DateTime lastUpdated;

  User({
    this.userId,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.passWord,
    required this.fullName,
    required this.role,
    required this.birthDay,
    required this.sex,
    required this.status,
    required this.avatar,
    required this.qrCode,
    required this.dateAdded,
    required this.lastUpdated,
  });

  User copyWith({
    int? userId,
    String? userName,
    String? email,
    String? phoneNumber,
    String? passWord,
    String? fullName,
    String? role,
    DateTime? birthDay,
    String? sex,
    String? status,
    String? avatar,
    String? qrCode,
    DateTime? dateAdded,
    DateTime? lastUpdated,
  }) {
    return User(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      passWord: passWord ?? this.passWord,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      birthDay: birthDay ?? this.birthDay,
      sex: sex ?? this.sex,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      qrCode: qrCode ?? this.qrCode,
      dateAdded: dateAdded ?? this.dateAdded,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'passWord': passWord,
      'fullName': fullName,
      'role': role,
      'birthDay': birthDay,
      'sex': sex,
      'status': status,
      'avatar': avatar,
      'qrCode': qrCode,
      'dateAdded': dateAdded,
      'lastUpdated': lastUpdated,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] != null ? map['userId'] as int : null,
      userName: map['userName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      passWord: map['passWord'] as String,
      fullName: map['fullName'] as String,
      role: map['role'] as String,
      birthDay: DateTime.parse(map['birthDay']),
      sex: map['sex'] as String,
      status: map['status'] as String,
      avatar: map['avatar'] as String,
      qrCode: map['qrCode'] as String,
      dateAdded: map['dateAdded'] != null ? DateTime.parse(map['dateAdded']) : DateTime.now(),
      lastUpdated: map['lastUpdated'] != null ? DateTime.parse(map['lastUpdated']) : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $userId, userName: $userName, email: $email, phoneNumber: $phoneNumber, passWord: $passWord, fullName: $fullName, role: $role, birthDay: $birthDay, sex: $sex, status: $status, avatar: $avatar, qrCode: $qrCode, dateAdded: $dateAdded, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.userName == userName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.passWord == passWord &&
        other.fullName == fullName &&
        other.role == role &&
        other.birthDay == birthDay &&
        other.sex == sex &&
        other.status == status &&
        other.avatar == avatar &&
        other.qrCode == qrCode &&
        other.dateAdded == dateAdded &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        passWord.hashCode ^
        fullName.hashCode ^
        role.hashCode ^
        birthDay.hashCode ^
        sex.hashCode ^
        status.hashCode ^
        avatar.hashCode ^
        qrCode.hashCode ^
        dateAdded.hashCode ^
        lastUpdated.hashCode;
  }
}
