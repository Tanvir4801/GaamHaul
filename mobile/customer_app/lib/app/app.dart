import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../core/theme/customer_theme.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/phone_login_screen.dart';
import '../features/auth/presentation/otp_verification_screen.dart';
import '../features/auth/presentation/profile_onboarding_screen.dart';
import '../features/auth/presentation/banned_screen.dart';
import '../features/home/presentation/customer_home_screen.dart';
import '../features/auth/presentation/unexpected_role_screen.dart';
import '../features/auth/domain/auth_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';
import '../core/providers/language_provider.dart';

class GaamHaulCustomerApp extends ConsumerWidget {
  const GaamHaulCustomerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final locale = ref.watch(languageProvider);

    return MaterialApp(
      title: AppConstants.appName,
      theme: CustomerTheme.theme,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('gu'),
      ],
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
      AuthProfileIncomplete() => const ProfileOnboardingScreen(),
      AuthProfileComplete(user: final user) => CustomerHomeScreen(user: user),
      AuthBanned() => const BannedScreen(),
      AuthUnexpectedRole(role: final role) => UnexpectedRoleScreen(role: role),
      AuthError(message: final msg) => Scaffold(
          body: Center(child: Text("Error: $msg")),
        ),
    };
  }
}
