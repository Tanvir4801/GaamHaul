import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/user_role.dart';

class UserModel {
  final String id;
  final UserRole role;
  final String phone;
  final String name;
  final String village;
  final String taluka;
  final Timestamp createdAt;
  final bool banned;

  UserModel({
    required this.id,
    required this.role,
    required this.phone,
    required this.name,
    required this.village,
    required this.taluka,
    required this.createdAt,
    required this.banned,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      role: UserRole.fromString(data['role'] as String),
      phone: data['phone'] as String,
      name: data['name'] as String,
      village: data['village'] as String,
      taluka: data['taluka'] as String,
      createdAt: data['createdAt'] as Timestamp,
      banned: data['banned'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'role': role.value,
      'phone': phone,
      'name': name,
      'village': village,
      'taluka': taluka,
      'createdAt': createdAt,
      'banned': banned,
    };
  }
}
