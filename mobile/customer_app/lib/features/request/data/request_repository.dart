import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  return RequestRepository(ref.watch(firestoreProvider));
});

final requestStreamProvider = StreamProvider.family<RequestModel?, String>((ref, requestId) {
  final repo = ref.watch(requestRepositoryProvider);
  return repo.watchRequest(requestId);
});

class RequestRepository {
  final FirebaseFirestore _firestore;

  RequestRepository(this._firestore);

  Future<void> createRequest(RequestModel request) async {
    try {
      final docRef = _firestore.collection(Collections.requests).doc(request.id);
      await docRef.set(request.toFirestore());
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  String generateId() {
    return _firestore.collection(Collections.requests).doc().id;
  }

  Stream<RequestModel?> watchRequest(String requestId) {
    return _firestore.collection(Collections.requests).doc(requestId).snapshots().map((doc) {
      if (doc.exists) {
        return RequestModel.fromFirestore(doc);
      }
      return null;
    });
  }

  Future<void> cancelRequest(String requestId) async {
    try {
      await _firestore.collection(Collections.requests).doc(requestId).update({
        'status': RequestStatus.cancelled.value,
      });
    } catch (e) {
      throw Exception('Failed to cancel request: $e');
    }
  }

  Future<void> selectSaathi({
    required String requestId,
    required String saathiId,
    required String vehicleId,
  }) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('selectSaathi');
      await callable.call({
        'requestId': requestId,
        'saathiId': saathiId,
        'vehicleId': vehicleId,
      });
    } catch (e) {
      throw Exception('Failed to select Saathi: $e');
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

  Future<List<RequestModel>> getCustomerHistory(String customerId) async {
    try {
      final snapshot = await _firestore
          .collection(Collections.requests)
          .where('customerId', isEqualTo: customerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => RequestModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch request history: $e');
    }
  }
}
