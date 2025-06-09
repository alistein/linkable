import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardModel {
  final String userId;
  final String name;
  final String surname;
  final int totalPoints;

  LeaderboardModel({
    required this.userId,
    required this.name,
    required this.totalPoints,
    required this.surname
  });

  factory LeaderboardModel.fromDocument(DocumentSnapshot doc, int rank) {
    final data = doc.data() as Map<String, dynamic>;
    return LeaderboardModel(
      userId: doc.id,
      name: data['name'] ?? 'Unknown',
      totalPoints: data['totalPoints'] ?? 0,
      surname: data['surname'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toMap(int rank, bool isCurrentUser) {
    return {
      'rank': rank,
      'name': '$name $surname',
      'points': totalPoints,
      if (isCurrentUser) 'highlight': true,
      'userId': userId,
    };
  }
}