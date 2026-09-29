import 'package:cloud_firestore/cloud_firestore.dart';

class InterestedSaathiModel {
  final String saathiId;
  final String vehicleId;
  final Timestamp markedAt;

  InterestedSaathiModel({
    required this.saathiId,
    required this.vehicleId,
    required this.markedAt,
  });

  factory InterestedSaathiModel.fromMap(Map<String, dynamic> map) {
    return InterestedSaathiModel(
      saathiId: map['saathiId'] as String,
      vehicleId: map['vehicleId'] as String,
      markedAt: map['markedAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'saathiId': saathiId,
      'vehicleId': vehicleId,
      'markedAt': markedAt,
    };
  }
}
