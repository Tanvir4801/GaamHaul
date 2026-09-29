import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String id;
  final String requestId;
  final String fromUserId;
  final String toUserId;
  final double stars;
  final String? tag;
  final Timestamp createdAt;

  RatingModel({
    required this.id,
    required this.requestId,
    required this.fromUserId,
    required this.toUserId,
    required this.stars,
    this.tag,
    required this.createdAt,
  });

  factory RatingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RatingModel(
      id: doc.id,
      requestId: data['requestId'] as String,
      fromUserId: data['fromUserId'] as String,
      toUserId: data['toUserId'] as String,
      stars: (data['stars'] as num).toDouble(),
      tag: data['tag'] as String?,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'requestId': requestId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'stars': stars,
      if (tag != null) 'tag': tag,
      'createdAt': createdAt,
    };
  }
}
