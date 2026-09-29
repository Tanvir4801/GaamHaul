import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/verification_status.dart';

class VahanSaathiModel {
  final String id;
  final List<String> vehicles;
  final double ratingAvg;
  final int ratingCount;
  final VerificationStatus verificationStatus;

  VahanSaathiModel({
    required this.id,
    required this.vehicles,
    required this.ratingAvg,
    required this.ratingCount,
    required this.verificationStatus,
  });

  factory VahanSaathiModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VahanSaathiModel(
      id: doc.id,
      vehicles: List<String>.from(data['vehicles'] ?? []),
      ratingAvg: (data['rating_avg'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (data['rating_count'] as num?)?.toInt() ?? 0,
      verificationStatus: VerificationStatus.fromString(data['verificationStatus'] as String? ?? 'pending'),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'vehicles': vehicles,
      'rating_avg': ratingAvg,
      'rating_count': ratingCount,
      'verificationStatus': verificationStatus.value,
    };
  }
}
