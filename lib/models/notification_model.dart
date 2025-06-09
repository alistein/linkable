import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String? referralId;
  final String? redeemId;
  final DateTime? createdAt;
  final int type;
  final bool isSeen;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    this.referralId,
    this.redeemId,
    this.createdAt,
    required this.userId,
    required this.type,
    required this.isSeen,
  });

  factory NotificationModel.fromFirestore(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      userId: data['userId'] as String,
      title: data['title'] as String? ?? 'No Title',
      content: data['content'] as String? ?? 'No Content',
      referralId: data['referralId'] as String?,
      redeemId: data['redeemId'] as String?,
      type: (data['type'] as num?)?.toInt() ?? 0,
      isSeen: data['isSeen'] as bool? ?? false,
      createdAt: (data["createdAt"] as Timestamp?)?.toDate(), 
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'userId': userId,
      'content': content,
      'referralId': referralId,
      'redeemId': redeemId,
      'type': type,
      'isSeen': isSeen,
    };
  }
}