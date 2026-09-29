import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers.dart';

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final saathiVehicleRepositoryProvider = Provider<SaathiVehicleRepository>((ref) {
  return SaathiVehicleRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseStorageProvider),
  );
});

class SaathiVehicleRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final _uuid = const Uuid();

  SaathiVehicleRepository(this._firestore, this._storage);

  String generateVehicleId() {
    return _uuid.v4();
  }

  Future<String> uploadImage(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> registerVehicle({
    required String ownerId,
    required VehicleType type,
    required String registrationNumber,
    required File vehiclePhoto,
    required File rcPhoto,
  }) async {
    final vehicleId = generateVehicleId();

    String? uploadedVehiclePhotoUrl;
    String? uploadedRcPhotoUrl;

    try {
      // 1. Upload Photos
      uploadedVehiclePhotoUrl = await uploadImage(
        vehiclePhoto,
        'vehicles/$ownerId/$vehicleId/vehicle.jpg',
      );
      uploadedRcPhotoUrl = await uploadImage(
        rcPhoto,
        'vehicles/$ownerId/$vehicleId/rc.jpg',
      );

      // 2. Prepare VehicleModel
      final vehicleModel = VehicleModel(
        id: vehicleId,
        ownerId: ownerId,
        type: type,
        registrationNumber: registrationNumber,
        photoUrl: uploadedVehiclePhotoUrl,
        rcPhotoUrl: uploadedRcPhotoUrl,
        status: VehicleStatus.offDuty,
        // Explicitly nulls per requirement
        lastKnownLocation: null,
        lastUpdatedAt: null,
        geohash: null,
      );

      // 3. Batch write
      final batch = _firestore.batch();
      final vehicleRef = _firestore.collection(Collections.vehicles).doc(vehicleId);
      final saathiRef = _firestore.collection(Collections.vahanSaathis).doc(ownerId);

      batch.set(vehicleRef, vehicleModel.toFirestore());
      batch.update(saathiRef, {
        'vehicles': FieldValue.arrayUnion([vehicleId]),
      });

      await batch.commit();
    } catch (e) {
      // NOTE: In MVP we are not implementing a distributed saga.
      // If Firestore fails after storage uploads, the images are orphaned.
      throw Exception('Failed to register vehicle: $e');
    }
  }

  Future<void> setVehicleOnDuty({
    required String vehicleId,
    required String ownerId,
    required GeoPoint location,
  }) async {
    final vehicleRef = _firestore.collection(Collections.vehicles).doc(vehicleId);
    
    // Application-layer validation: Ensure we only update if ownerId matches.
    // Real security is enforced in Phase 8 rules.
    final doc = await vehicleRef.get();
    if (!doc.exists || doc.data()?['ownerId'] != ownerId) {
      throw Exception('Vehicle not found or unauthorized');
    }

    await vehicleRef.update({
      'status': VehicleStatus.onDuty.value,
      'lastKnownLocation': location,
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setVehicleOffDuty({
    required String vehicleId,
    required String ownerId,
  }) async {
    final vehicleRef = _firestore.collection(Collections.vehicles).doc(vehicleId);
    
    final doc = await vehicleRef.get();
    if (!doc.exists || doc.data()?['ownerId'] != ownerId) {
      throw Exception('Vehicle not found or unauthorized');
    }

    // Only update status. Preserve location/timestamp.
    await vehicleRef.update({
      'status': VehicleStatus.offDuty.value,
    });
  }

  Future<void> refreshVehicleLocation({
    required String vehicleId,
    required String ownerId,
    required GeoPoint location,
  }) async {
    final vehicleRef = _firestore.collection(Collections.vehicles).doc(vehicleId);
    
    final doc = await vehicleRef.get();
    if (!doc.exists || doc.data()?['ownerId'] != ownerId) {
      throw Exception('Vehicle not found or unauthorized');
    }

    await vehicleRef.update({
      'lastKnownLocation': location,
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    });
  }
}
