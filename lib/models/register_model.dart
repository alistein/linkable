
import 'package:linkable/models/phone_model.dart';

class RegisterModel {
  String name;
  String surname;
  PhoneModel phoneNumber;
  String? email;
  String password;
  bool isNotificationEnabled;
  bool isVerified;
  String referredCode;
  String referralCode;
  int points;
  int totalPoints;

  RegisterModel(
      {required this.name,
      required this.surname,
      required this.phoneNumber,
      this.email,
      required this.isVerified,
      required this.password,
      required this.referredCode,
      required this.isNotificationEnabled,
      required this.referralCode,
      required this.points,
      required this.totalPoints});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      name: json['name'],
      surname: json['surname'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      password: json['password'],
      isVerified: json['isVerified'],
      isNotificationEnabled: json['isNotificationEnabled'],
      referredCode: json['referredCode'],
      referralCode: json['referralCode'],
      totalPoints: json['totalPoints'],
      points: json["points"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber.toJson(),
      'isNotificationEnabled': isNotificationEnabled,
      'isVerified': isVerified,
      'referredCode': referredCode,
      'referralCode': referralCode,
      'totalPoints': totalPoints,
      'exceededApThreshold': false,
      'points': points
    };
  }
}
