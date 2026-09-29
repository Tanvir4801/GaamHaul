import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/vehicle_type.dart';
import '../enums/work_type.dart';
import '../enums/request_timing.dart';
import '../enums/duration_type.dart';
import '../enums/request_status.dart';
import 'interested_saathi_model.dart';

class RequestModel {
  final String id;
  final String customerId;
  final VehicleType vehicleTypeRequested;
  final WorkType workType;
  final RequestTiming timing;
  final Timestamp? scheduledAt;
  final DurationType durationType;
  final GeoPoint pickupLocation;
  final GeoPoint? destinationLocation;
  final double estimatedPriceMin;
  final double estimatedPriceMax;
  final RequestStatus status;
  final List<String> shortlistedVehicleIds;
  final List<InterestedSaathiModel> interestedSaathis;
  final String? selectedSaathiId;
  final double? finalPrice;
  final Timestamp createdAt;
  final Timestamp? matchedAt;
  final Timestamp? completedAt;

  RequestModel({
    required this.id,
    required this.customerId,
    required this.vehicleTypeRequested,
    required this.workType,
    required this.timing,
    this.scheduledAt,
    required this.durationType,
    required this.pickupLocation,
    this.destinationLocation,
    required this.estimatedPriceMin,
    required this.estimatedPriceMax,
    required this.status,
    required this.shortlistedVehicleIds,
    required this.interestedSaathis,
    this.selectedSaathiId,
    this.finalPrice,
    required this.createdAt,
    this.matchedAt,
    this.completedAt,
  });

  factory RequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RequestModel(
      id: doc.id,
      customerId: data['customerId'] as String,
      vehicleTypeRequested: VehicleType.fromString(data['vehicleTypeRequested'] as String),
      workType: WorkType.fromString(data['workType'] as String),
      timing: RequestTiming.fromString(data['timing'] as String),
      scheduledAt: data['scheduledAt'] as Timestamp?,
      durationType: DurationType.fromString(data['durationType'] as String),
      pickupLocation: data['pickupLocation'] as GeoPoint,
      destinationLocation: data['destinationLocation'] as GeoPoint?,
      estimatedPriceMin: (data['estimatedPriceMin'] as num).toDouble(),
      estimatedPriceMax: (data['estimatedPriceMax'] as num).toDouble(),
      status: RequestStatus.fromString(data['status'] as String),
      shortlistedVehicleIds: List<String>.from(data['shortlistedVehicleIds'] ?? []),
      interestedSaathis: (data['interestedSaathis'] as List<dynamic>? ?? [])
          .map((e) => InterestedSaathiModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      selectedSaathiId: data['selectedSaathiId'] as String?,
      finalPrice: (data['finalPrice'] as num?)?.toDouble(),
      createdAt: data['createdAt'] as Timestamp,
      matchedAt: data['matchedAt'] as Timestamp?,
      completedAt: data['completedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customerId': customerId,
      'vehicleTypeRequested': vehicleTypeRequested.value,
      'workType': workType.value,
      'timing': timing.value,
      if (scheduledAt != null) 'scheduledAt': scheduledAt,
      'durationType': durationType.value,
      'pickupLocation': pickupLocation,
      if (destinationLocation != null) 'destinationLocation': destinationLocation,
      'estimatedPriceMin': estimatedPriceMin,
      'estimatedPriceMax': estimatedPriceMax,
      'status': status.value,
      'shortlistedVehicleIds': shortlistedVehicleIds,
      'interestedSaathis': interestedSaathis.map((e) => e.toMap()).toList(),
      if (selectedSaathiId != null) 'selectedSaathiId': selectedSaathiId,
      if (finalPrice != null) 'finalPrice': finalPrice,
      'createdAt': createdAt,
      if (matchedAt != null) 'matchedAt': matchedAt,
      if (completedAt != null) 'completedAt': completedAt,
    };
  }
}
