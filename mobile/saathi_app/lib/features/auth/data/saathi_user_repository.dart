import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/providers.dart';

final saathiUserRepositoryProvider = Provider<SaathiUserRepository>((ref) {
  return SaathiUserRepository(ref.watch(firestoreProvider));
});

class SaathiUserRepository {
  final FirebaseFirestore _firestore;

  SaathiUserRepository(this._firestore);

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(Collections.users).doc(uid).get();
      if (!doc.exists) {
        return null;
      }
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<void> createSaathiProfile({
    required String uid,
    required String phone,
    required String name,
    required String village,
    required String taluka,
  }) async {
    try {
      final batch = _firestore.batch();
      final userRef = _firestore.collection(Collections.users).doc(uid);
      final saathiRef = _firestore.collection(Collections.vahanSaathis).doc(uid);

      final userModel = UserModel(
        id: uid,
        role: UserRole.vahanSaathi,
        phone: phone,
        name: name,
        village: village,
        taluka: taluka,
        createdAt: Timestamp.now(),
        banned: false,
      );

      final saathiModel = VahanSaathiModel(
        id: uid,
        vehicles: const [],
        ratingAvg: 0.0,
        ratingCount: 0,
        verificationStatus: VerificationStatus.pending,
      );

      batch.set(userRef, userModel.toFirestore());
      batch.set(saathiRef, saathiModel.toFirestore());

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to create Saathi profile: $e');
    }
  }
}
