import 'package:linkable/models/phone_model.dart';

class UserModel {
  String name;
  String surname;
  PhoneModel phoneNumber;
  String email;
  bool isNotificationEnabled;
  bool isVerified;
  String referredCode;
  String referralCode;
  String? profilePhotoUrl;
  int points;
  int totalPoints;
  List<String>? tags;

  UserModel(
      {required this.name,
      required this.surname,
      required this.phoneNumber,
      required this.email,
      required this.isVerified,
      required this.isNotificationEnabled,
      required this.referredCode,
      required this.profilePhotoUrl,
      required this.referralCode,
      required this.points,
      required this.totalPoints,
      required this.tags});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      surname: json['surname'],
      phoneNumber: PhoneModel.fromJson(json['phoneNumber']),
      email: '',
      profilePhotoUrl: json['profilePhotoUrl'],
      isNotificationEnabled: json['isNotificationEnabled'],
      isVerified: json['isVerified'],
      referredCode: json['referredCode'],
      referralCode: json['referralCode'],
      totalPoints: json['totalPoints'],
      tags: List<String>.from(json['tags'] ?? []),
      points: json["points"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name, 
      'surname': surname,
      'phoneNumber': phoneNumber,
      'isNotificationEnabled': isNotificationEnabled,
      'email': email,
      'isVerified': isVerified,
      'referredCode': referredCode,
      'referralCode': referralCode,
      'totalPoints': totalPoints,
      'tags': tags,
      'points':points
    };
  }
}
