import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:firebase_auth/firebase_auth.dart';

final saathiRequestRepositoryProvider = Provider<SaathiRequestRepository>((ref) {
  return SaathiRequestRepository(FirebaseFirestore.instance);
});

class SaathiRequestRepository {
  final FirebaseFirestore _firestore;

  SaathiRequestRepository(this._firestore);

  Stream<List<RequestModel>> watchIncomingRequests(List<String> vehicleIds) {
    if (vehicleIds.isEmpty) {
      return Stream.value([]);
    }
    
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(Collections.requests)
        .where('shortlistedSaathiIds', arrayContains: uid)
        .where('status', isEqualTo: RequestStatus.open.value)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => RequestModel.fromFirestore(doc)).toList());
  }

  Stream<RequestModel?> watchRequest(String requestId) {
    return _firestore
        .collection(Collections.requests)
        .doc(requestId)
        .snapshots()
        .map((doc) => doc.exists ? RequestModel.fromFirestore(doc) : null);
  }

  Future<void> markInterested({
    required String requestId,
    required String vehicleId,
  }) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('markInterested');
      await callable.call({
        'requestId': requestId,
        'vehicleId': vehicleId,
      });
    } catch (e) {
      throw Exception('Failed to express interest: $e');
    }
  }

  Future<void> markJobComplete(String requestId) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('markJobCompleted');
      await callable.call({
        'requestId': requestId,
      });
    } catch (e) {
      throw Exception('Failed to mark job complete: $e');
    }
  }
}
