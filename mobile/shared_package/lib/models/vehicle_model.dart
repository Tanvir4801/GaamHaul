import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/vehicle_type.dart';
import '../enums/vehicle_status.dart';

class VehicleModel {
  final String id;
  final String ownerId;
  final VehicleType type;
  final String registrationNumber;
  final String photoUrl;
  final String rcPhotoUrl;
  final VehicleStatus status;
  final GeoPoint? lastKnownLocation;
  final Timestamp? lastUpdatedAt;
  final String? geohash;

  VehicleModel({
    required this.id,
    required this.ownerId,
    required this.type,
    required this.registrationNumber,
    required this.photoUrl,
    required this.rcPhotoUrl,
    required this.status,
    this.lastKnownLocation,
    this.lastUpdatedAt,
    this.geohash,
  });

  factory VehicleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VehicleModel(
      id: doc.id,
      ownerId: data['ownerId'] as String,
      type: VehicleType.fromString(data['type'] as String),
      registrationNumber: data['registrationNumber'] as String,
      photoUrl: data['photoUrl'] as String,
      rcPhotoUrl: data['rcPhotoUrl'] as String,
      status: VehicleStatus.fromString(data['status'] as String),
      lastKnownLocation: data['lastKnownLocation'] as GeoPoint?,
      lastUpdatedAt: data['lastUpdatedAt'] as Timestamp?,
      geohash: data['geohash'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'type': type.value,
      'registrationNumber': registrationNumber,
      'photoUrl': photoUrl,
      'rcPhotoUrl': rcPhotoUrl,
      'status': status.value,
      if (lastKnownLocation != null) 'lastKnownLocation': lastKnownLocation,
      if (lastUpdatedAt != null) 'lastUpdatedAt': lastUpdatedAt,
      if (geohash != null) 'geohash': geohash,
    };
  }
}
