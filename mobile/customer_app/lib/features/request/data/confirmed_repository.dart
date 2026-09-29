import 'package:shared_package/shared_package.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';


class ConfirmedData {
  final RequestModel request;
  final UserModel saathiUser;
  final VahanSaathiModel saathiProfile;
  final VehicleModel? vehicle;

  ConfirmedData({
    required this.request,
    required this.saathiUser,
    required this.saathiProfile,
    this.vehicle,
  });
}

final confirmedDataProvider = FutureProvider.family<ConfirmedData, String>((ref, requestId) async {
  final firestore = ref.watch(firestoreProvider);
  
  // 1. Fetch request
  final requestDoc = await firestore.collection(Collections.requests).doc(requestId).get();
  if (!requestDoc.exists) {
    throw Exception('Request not found');
  }
  final request = RequestModel.fromFirestore(requestDoc);

  if ((request.status != RequestStatus.matched &&
       request.status != RequestStatus.inProgress &&
       request.status != RequestStatus.completed) || 
      request.selectedSaathiId == null) {
    throw Exception('Request is not in a confirmed state');
  }

  final saathiId = request.selectedSaathiId!;

  // 2. Fetch User Model for Name and Phone
  final userDoc = await firestore.collection(Collections.users).doc(saathiId).get();
  if (!userDoc.exists) {
    throw Exception('Saathi user profile not found');
  }
  final saathiUser = UserModel.fromFirestore(userDoc);

  // 3. Fetch VahanSaathiModel for Ratings
  final profileDoc = await firestore.collection(Collections.vahanSaathis).doc(saathiId).get();
  if (!profileDoc.exists) {
    throw Exception('Vahan Saathi profile not found');
  }
  final saathiProfile = VahanSaathiModel.fromFirestore(profileDoc);

  // 4. Determine Vehicle ID if possible
  VehicleModel? vehicle;
  try {
    final interested = request.interestedSaathis.firstWhere((element) => element.saathiId == saathiId);
    final vehicleDoc = await firestore.collection(Collections.vehicles).doc(interested.vehicleId).get();
    if (vehicleDoc.exists) {
      vehicle = VehicleModel.fromFirestore(vehicleDoc);
    }
  } catch (e) {
    // If not found in interested array, we simply proceed without a specific vehicle model
  }

  return ConfirmedData(
    request: request,
    saathiUser: saathiUser,
    saathiProfile: saathiProfile,
    vehicle: vehicle,
  );
});
