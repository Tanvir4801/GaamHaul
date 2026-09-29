import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/providers.dart';
import '../../auth/data/auth_repository.dart';

final saathiVehiclesProvider = FutureProvider<List<VehicleModel>>((ref) async {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return [];

  final firestore = ref.watch(firestoreProvider);
  final querySnapshot = await firestore
      .collection(Collections.vehicles)
      .where('ownerId', isEqualTo: user.uid)
      .get();

  return querySnapshot.docs.map((doc) => VehicleModel.fromFirestore(doc)).toList();
});
