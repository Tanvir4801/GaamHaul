import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/saathi_theme.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/phone_login_screen.dart';
import '../features/auth/presentation/otp_verification_screen.dart';
import '../features/auth/presentation/saathi_onboarding_screen.dart';
import '../features/auth/presentation/banned_screen.dart';
import '../features/home/presentation/saathi_home_screen.dart';
import '../features/auth/presentation/unexpected_role_screen.dart';
import '../features/auth/domain/auth_state.dart';

class GaamHaulSaathiApp extends ConsumerWidget {
  const GaamHaulSaathiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return MaterialApp(
      title: 'GaamHaul Saathi',
      theme: SaathiTheme.theme,
      debugShowCheckedModeBanner: false,
      home: _getScreenForState(authState),
    );
  }

  Widget _getScreenForState(AuthState state) {
    return switch (state) {
      AuthUnauthenticated() => const PhoneLoginScreen(),
      AuthLoading() || AuthAuthenticating() || AuthLoadingProfile() => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      AuthOtpSent() => const OtpVerificationScreen(),
      AuthProfileIncomplete() => const SaathiOnboardingScreen(),
      AuthProfileComplete(user: final user) => SaathiHomeScreen(user: user),
      AuthBanned() => const BannedScreen(),
      AuthUnexpectedRole(role: final role) => UnexpectedRoleScreen(role: role),
      AuthError(message: final msg) => Scaffold(
          body: Center(child: Text("Error: $msg")),
        ),
    };
  }
}
