import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/vehicle_type.dart';
import 'price_range.dart';

class RateCardModel {
  final String id;
  final VehicleType vehicleType;
  final PriceRange oneHour;
  final PriceRange twoHour;
  final PriceRange halfDay;
  final PriceRange fullDay;

  RateCardModel({
    required this.id,
    required this.vehicleType,
    required this.oneHour,
    required this.twoHour,
    required this.halfDay,
    required this.fullDay,
  });

  factory RateCardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RateCardModel(
      id: doc.id,
      vehicleType: VehicleType.fromString(data['vehicleType'] as String),
      oneHour: PriceRange.fromMap(data['oneHour'] as Map<String, dynamic>),
      twoHour: PriceRange.fromMap(data['twoHour'] as Map<String, dynamic>),
      halfDay: PriceRange.fromMap(data['halfDay'] as Map<String, dynamic>),
      fullDay: PriceRange.fromMap(data['fullDay'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'vehicleType': vehicleType.value,
      'oneHour': oneHour.toMap(),
      'twoHour': twoHour.toMap(),
      'halfDay': halfDay.toMap(),
      'fullDay': fullDay.toMap(),
    };
  }
}
