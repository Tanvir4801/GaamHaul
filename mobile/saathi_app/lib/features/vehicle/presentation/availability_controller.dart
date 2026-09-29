import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/providers.dart';
import '../data/vehicle_provider.dart';

class LoadingMapNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => {};

  void setLoading(String id, bool loading) {
    state = { ...state, id: loading };
  }
}

final availabilityLoadingProvider = NotifierProvider<LoadingMapNotifier, Map<String, bool>>(
  LoadingMapNotifier.new,
);

class AvailabilityController {
  final Ref ref;
  final String vehicleId;
  final FirebaseFirestore _firestore;

  AvailabilityController(this.ref, this.vehicleId) 
      : _firestore = ref.read(firestoreProvider);

  Future<void> updateStatus(VehicleStatus status, GeoPoint? location) async {
    ref.read(availabilityLoadingProvider.notifier).setLoading(vehicleId, true);
    try {
      final updates = <String, dynamic>{
        'status': status.value,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (location != null) {
        updates['currentLocation'] = location;
      }
      
      await _firestore.collection(Collections.vehicles).doc(vehicleId).update(updates);
      ref.invalidate(saathiVehiclesProvider);
    } finally {
      ref.read(availabilityLoadingProvider.notifier).setLoading(vehicleId, false);
    }
  }
}

final availabilityControllerProvider = Provider.family<AvailabilityController, String>(
  (ref, vehicleId) => AvailabilityController(ref, vehicleId),
);
