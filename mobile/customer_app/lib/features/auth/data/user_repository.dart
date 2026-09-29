import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/providers.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(firestoreProvider));
});

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(Collections.users).doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      // Re-throw to be handled by controller
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<void> createCustomerProfile({
    required String uid,
    required String phone,
    required String name,
    required String village,
    required String taluka,
  }) async {
    try {
      final userModel = UserModel(
        id: uid,
        role: UserRole.customer,
        phone: phone,
        name: name,
        village: village,
        taluka: taluka,
        createdAt: Timestamp.now(),
        banned: false,
      );
      
      await _firestore.collection(Collections.users).doc(uid).set(userModel.toFirestore());
    } catch (e) {
      throw Exception('Failed to create customer profile: $e');
    }
  }
}
