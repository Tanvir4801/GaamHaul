import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:customer_app/features/home/presentation/customer_home_screen.dart';
import 'package:customer_app/features/request/presentation/request_flow_screen.dart';
import 'package:customer_app/features/request/presentation/request_history_screen.dart';
import 'package:customer_app/features/request/data/history_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('CustomerHomeScreen Tests', () {
    final mockUser = UserModel(
      id: 'test-uid',
      role: UserRole.customer,
      phone: '+919999999999',
      name: 'Rajesh',
      village: 'Anand',
      taluka: 'Anand',
      createdAt: Timestamp.now(),
      banned: false,
    );

    testWidgets('Displays greeting, CTA, and work types', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customerHistoryProvider(mockUser.id).overrideWith((ref) => Future.value([])),
          ],
          child: MaterialApp(
            home: CustomerHomeScreen(user: mockUser),
          ),
        ),
      );

      expect(find.text('Good morning, Rajesh'), findsOneWidget);
      expect(find.text('Need a vehicle today?'), findsOneWidget);
      expect(find.text('🚚 Request a Vehicle'), findsOneWidget);
      expect(find.text('Find a nearby Vahan Saathi'), findsOneWidget);
    });

    testWidgets('Tapping Request Vehicle opens RequestFlowScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customerHistoryProvider(mockUser.id).overrideWith((ref) => Future.value([])),
          ],
          child: MaterialApp(
            home: CustomerHomeScreen(user: mockUser),
          ),
        ),
      );

      await tester.tap(find.text('🚚 Request a Vehicle'));
      await tester.pumpAndSettle();

      // Verify we navigated to step 1
      expect(find.text('Step 1 of 6'), findsOneWidget);
      expect(find.byType(RequestFlowScreen), findsOneWidget);
    });

    testWidgets('Tapping History tab switches to history view', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customerHistoryProvider(mockUser.id).overrideWith((ref) => Future.value([])),
          ],
          child: MaterialApp(
            home: CustomerHomeScreen(user: mockUser),
          ),
        ),
      );

      expect(find.text('Good morning, Rajesh'), findsOneWidget);
      
      // Tap History icon/label in bottom nav
      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      expect(find.text('Request History'), findsOneWidget);
      expect(find.byType(RequestHistoryScreen), findsOneWidget);
    });
  });
}
