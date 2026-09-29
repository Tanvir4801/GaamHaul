import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:saathi_app/features/auth/presentation/phone_login_screen.dart';
import 'package:saathi_app/features/auth/presentation/saathi_onboarding_screen.dart';
import 'package:saathi_app/features/home/presentation/saathi_home_screen.dart';
import 'package:saathi_app/features/vehicle/data/vehicle_provider.dart';
import 'package:saathi_app/features/auth/presentation/unexpected_role_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Saathi Auth UI Tests', () {
    testWidgets('PhoneLoginScreen validates empty input', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PhoneLoginScreen(),
          ),
        ),
      );

      expect(find.text('Welcome, Vahan Saathi'), findsOneWidget);
      
      await tester.tap(find.text('Send OTP'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your mobile number'), findsOneWidget);
    });

    testWidgets('SaathiOnboardingScreen validates empty inputs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SaathiOnboardingScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Complete Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your village'), findsOneWidget);
      expect(find.text('Please enter your taluka'), findsOneWidget);
    });

    testWidgets('UnexpectedRoleScreen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: UnexpectedRoleScreen(role: 'customer'),
          ),
        ),
      );

      expect(find.text('Wrong Application'), findsOneWidget);
      expect(find.textContaining('registered as a "customer"'), findsOneWidget);
    });

    testWidgets('SaathiHomeScreen displays boundary', (WidgetTester tester) async {
      final mockSaathi = UserModel(
        id: 'saathi-1',
        role: UserRole.vahanSaathi,
        phone: '+919999999999',
        name: 'Ramesh',
        village: 'Anand',
        taluka: 'Anand',
        createdAt: Timestamp.now(),
        banned: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            saathiVehiclesProvider.overrideWith((ref) => Future.value([])),
          ],
          child: MaterialApp(
            home: SaathiHomeScreen(user: mockSaathi),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Namaste, Ramesh'), findsOneWidget);
      expect(find.text('Your Vehicles'), findsOneWidget);
      expect(find.text('No Vehicles Registered'), findsOneWidget);
    });
  });
}
