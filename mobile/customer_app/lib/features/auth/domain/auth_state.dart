import 'package:shared_package/shared_package.dart';

sealed class AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthAuthenticating extends AuthState {}

class AuthOtpSent extends AuthState {
  final String verificationId;
  final String phoneNumber;
  AuthOtpSent({required this.verificationId, required this.phoneNumber});
}

class AuthLoadingProfile extends AuthState {}

class AuthProfileIncomplete extends AuthState {
  final String uid;
  final String phone;
  AuthProfileIncomplete({required this.uid, required this.phone});
}

class AuthProfileComplete extends AuthState {
  final UserModel user;
  AuthProfileComplete({required this.user});
}

class AuthBanned extends AuthState {}

class AuthUnexpectedRole extends AuthState {
  final String role;
  AuthUnexpectedRole({required this.role});
}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
