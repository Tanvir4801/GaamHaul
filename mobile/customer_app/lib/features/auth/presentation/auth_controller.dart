import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:shared_package/shared_package.dart';
import '../domain/auth_state.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    _initAuthStream();
    return AuthLoading();
  }

  void _initAuthStream() {
    final authRepo = ref.read(authRepositoryProvider);
    authRepo.authStateChanges().listen((User? user) {
      if (user == null) {
        state = AuthUnauthenticated();
      } else {
        _checkUserProfile(user);
      }
    });
  }

  Future<void> _checkUserProfile(User user) async {
    state = AuthLoadingProfile();
    try {
      final userRepo = ref.read(userRepositoryProvider);
      final userModel = await userRepo.getUser(user.uid);
      
      if (userModel == null) {
        state = AuthProfileIncomplete(uid: user.uid, phone: user.phoneNumber ?? '');
      } else {
        if (userModel.banned) {
          state = AuthBanned();
        } else if (userModel.role != UserRole.customer) {
          state = AuthUnexpectedRole(role: userModel.role.value);
        } else {
          state = AuthProfileComplete(user: userModel);
          // Initialize FCM Token
          ref.read(fcmServiceProvider).initializeAndRegisterToken();
        }
      }
    } catch (e) {
      state = AuthError(message: e.toString());
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = AuthAuthenticating();
    final authRepo = ref.read(authRepositoryProvider);
    try {
      await authRepo.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await authRepo.signInWithCredential(credential);
          // authStateChanges will trigger _checkUserProfile
        },
        verificationFailed: (FirebaseAuthException e) {
          state = AuthError(message: e.message ?? 'Verification failed');
          // Revert to unauthenticated so user can try again
          Future.delayed(const Duration(seconds: 3), () {
            if (state is AuthError) {
               state = AuthUnauthenticated();
            }
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          state = AuthOtpSent(verificationId: verificationId, phoneNumber: phoneNumber);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      state = AuthError(message: e.toString());
      Future.delayed(const Duration(seconds: 3), () {
        if (state is AuthError) state = AuthUnauthenticated();
      });
    }
  }

  Future<void> verifyOtp(String verificationId, String smsCode) async {
    final prevState = state;
    state = AuthAuthenticating();
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await authRepo.signInWithCredential(credential);
    } catch (e) {
      state = AuthError(message: 'Invalid OTP or network error. Please try again.');
      Future.delayed(const Duration(seconds: 3), () {
        if (state is AuthError) state = prevState; // Revert to OTP sent state
      });
    }
  }

  Future<void> createProfile({
    required String name,
    required String village,
    required String taluka,
  }) async {
    if (state is! AuthProfileIncomplete) return;
    
    final incompleteState = state as AuthProfileIncomplete;
    state = AuthLoadingProfile();
    
    try {
      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.createCustomerProfile(
        uid: incompleteState.uid,
        phone: incompleteState.phone,
        name: name,
        village: village,
        taluka: taluka,
      );
      final createdUser = UserModel(
        id: incompleteState.uid,
        role: UserRole.customer,
        phone: incompleteState.phone,
        name: name,
        village: village,
        taluka: taluka,
        createdAt: cloud_firestore.Timestamp.now(),
        banned: false,
      );
      state = AuthProfileComplete(user: createdUser);
      ref.read(fcmServiceProvider).initializeAndRegisterToken();
    } catch (e) {
      state = AuthError(message: e.toString());
      Future.delayed(const Duration(seconds: 3), () {
        if (state is AuthError) state = incompleteState;
      });
    }
  }

  Future<void> signOut() async {
    try {
      await ref.read(fcmServiceProvider).unregisterToken();
    } catch (_) {} // Ignore unregister errors on signout
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.signOut();
  }
}
