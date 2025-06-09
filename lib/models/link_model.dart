import 'package:cloud_firestore/cloud_firestore.dart';

class LinkModel {
  final String? id;
  final String title;
  final String summary;
  final String tag;
  final String website;
  final String? userId;
  final String? webPageName;
  final List<String>? scrapedLinks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LinkModel(
    {
    this.id,
    required this.title,
    required this.summary,
    required this.tag,
    required this.website,
    this.userId,
     this.webPageName,
    this.scrapedLinks,
    this.createdAt,
    this.updatedAt,
  });

  // Convert Link object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'summary': summary,
      'tag': tag,
      'webPageName': webPageName,
      'website': website,
      'userId': userId,
      'scrapedLinks': scrapedLinks,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Create Link object from Firestore document
  factory LinkModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LinkModel(
      id: doc.id,
      title: data['title'] ?? '',
      summary: data['summary'] ?? '',
      tag: data['tag'] ?? '',
      webPageName: data['webPageName'] ?? '',
      website: data['website'] ?? '',
      userId: data['userId'],
      scrapedLinks: data['scrapedLinks'] != null 
          ? List<String>.from(data['scrapedLinks']) 
          : null,
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  // Create Link object from Map
  factory LinkModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return LinkModel(
      id: id,
      title: map['title'] ?? '',
      summary: map['summary'] ?? '',
      tag: map['tag'] ?? '',
      webPageName: map['webPageName'],
      website: map['website'] ?? '',
      userId: map['userId'],
      scrapedLinks: map['scrapedLinks'] != null 
          ? List<String>.from(map['scrapedLinks']) 
          : null,
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'tag': tag,
      'website': website,
      'webPageName': webPageName,
      'userId': userId,
      'scrapedLinks': scrapedLinks,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      id: json['id'],
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      tag: json['tag'] ?? '',
      webPageName: json['webPageNamee'] ?? '',
      website: json['website'] ?? '',
      userId: json['userId'],
      scrapedLinks: json['scrapedLinks'] != null 
          ? List<String>.from(json['scrapedLinks']) 
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  // Copy with method for updating specific fields
  LinkModel copyWith({
    String? id,
    String? title,
    String? summary,
    String? tag,
    String? website,
    String? userId,
    List<String>? scrapedLinks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LinkModel(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      tag: tag ?? this.tag,
      website: website ?? this.website,
      webPageName: webPageName ?? this.webPageName,
      userId: userId ?? this.userId,
      scrapedLinks: scrapedLinks ?? this.scrapedLinks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Link(id: $id, title: $title, summary: $summary, tag: $tag, website: $website, userId: $userId, scrapedLinks: $scrapedLinks, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LinkModel &&
        other.id == id &&
        other.title == title &&
        other.summary == summary &&
        other.tag == tag &&
        other.website == website &&
        other.userId == userId &&
        other.scrapedLinks == scrapedLinks;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        summary.hashCode ^
        tag.hashCode ^
        website.hashCode ^
        userId.hashCode ^
        scrapedLinks.hashCode;
  }
}
