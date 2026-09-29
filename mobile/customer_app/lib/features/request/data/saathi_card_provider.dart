import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/providers.dart';
import '../../../widgets/gh_saathi_card.dart';

final saathiCardDataProvider = FutureProvider.family<SaathiCardData, InterestedSaathiModel>((ref, interest) async {
  final firestore = ref.watch(firestoreProvider);

  // Fetch Saathi User Profile
  final userDoc = await firestore.collection(Collections.users).doc(interest.saathiId).get();
  final saathiName = userDoc.data()?['name'] as String? ?? 'Vahan Saathi';

  // Fetch Vehicle
  final vehicleDoc = await firestore.collection(Collections.vehicles).doc(interest.vehicleId).get();
  final vehicleData = vehicleDoc.data();
  
  VehicleType vehicleType = VehicleType.eLoader; // fallback
  String? vehiclePhotoUrl;
  String? registrationNumber;

  if (vehicleData != null) {
    vehiclePhotoUrl = vehicleData['photoUrl'] as String?;
    registrationNumber = vehicleData['registrationNumber'] as String?;
    final typeStr = vehicleData['type'] as String?;
    if (typeStr != null) {
      try {
        vehicleType = VehicleType.values.firstWhere((e) => e.value == typeStr);
      } catch (_) {}
    }
  }

  // Fetch Saathi Stats (from vahan_saathis collection if it exists, otherwise fallback)
  final statsDoc = await firestore.collection('vahan_saathis').doc(interest.saathiId).get();
  final statsData = statsDoc.data();
  double ratingAvg = 5.0;
  int completedTrips = 0;

  if (statsData != null) {
    ratingAvg = (statsData['ratingAvg'] as num?)?.toDouble() ?? 5.0;
    completedTrips = (statsData['completedTrips'] as num?)?.toInt() ?? 0;
  }

  return SaathiCardData(
    saathiId: interest.saathiId,
    name: saathiName,
    vehicleType: vehicleType,
    vehicleId: interest.vehicleId,
    ratingAvg: ratingAvg,
    completedTrips: completedTrips,
    vehiclePhotoUrl: vehiclePhotoUrl,
    vehicleRegistrationNumber: registrationNumber, 
    markedAt: interest.markedAt.toDate(),
  );
});
