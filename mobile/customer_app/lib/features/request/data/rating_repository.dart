import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/providers.dart';

final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return RatingRepository(ref.watch(firestoreProvider));
});

class RatingRepository {
  final FirebaseFirestore _firestore;

  RatingRepository(this._firestore);

  Future<void> submitRating(RatingModel rating) async {
    try {
      await _firestore.collection(Collections.ratings).doc(rating.id).set(rating.toFirestore());
    } catch (e) {
      throw Exception('Failed to submit rating: $e');
    }
  }

  Future<bool> hasRated(String requestId, String customerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(Collections.ratings)
          .where('requestId', isEqualTo: requestId)
          .where('fromUserId', isEqualTo: customerId)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false; // Safely default to false on error, or could throw.
    }
  }

  String generateId() {
    return _firestore.collection(Collections.ratings).doc().id;
  }
}
