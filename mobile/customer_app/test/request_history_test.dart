import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/features/request/data/history_provider.dart';
import 'package:customer_app/features/request/presentation/request_history_screen.dart';
import 'package:customer_app/features/request/presentation/request_history_detail_screen.dart';

void main() {
  group('RequestHistoryScreen Tests', () {
    testWidgets('Displays empty state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customerHistoryProvider('cust-1').overrideWith((ref) => Future.value([])),
          ],
          child: const MaterialApp(
            home: RequestHistoryScreen(customerId: 'cust-1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No requests yet'), findsOneWidget);
      expect(find.text('Your request history will appear here.'), findsOneWidget);
    });

    testWidgets('Displays list of requests', (WidgetTester tester) async {
      final mockRequests = [
        RequestModel(
          id: 'req-1',
          customerId: 'cust-1',
          vehicleTypeRequested: VehicleType.pickup,
          workType: WorkType.farm,
          timing: RequestTiming.now,
          durationType: DurationType.twoHour,
          pickupLocation: const GeoPoint(0, 0),
          estimatedPriceMin: 350,
          estimatedPriceMax: 500,
          status: RequestStatus.completed,
          shortlistedVehicleIds: const [],
          interestedSaathis: const [],
          createdAt: Timestamp.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customerHistoryProvider('cust-1').overrideWith((ref) => Future.value(mockRequests)),
          ],
          child: const MaterialApp(
            home: RequestHistoryScreen(customerId: 'cust-1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('FARM'), findsOneWidget);
      expect(find.text('Vehicle: PICKUP'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });
  });

  group('RequestHistoryDetailScreen Tests', () {
    testWidgets('Displays active request routing CTA', (WidgetTester tester) async {
      final req = RequestModel(
        id: 'req-1',
        customerId: 'cust-1',
        vehicleTypeRequested: VehicleType.pickup,
        workType: WorkType.farm,
        timing: RequestTiming.now,
        durationType: DurationType.twoHour,
        pickupLocation: const GeoPoint(0, 0),
        estimatedPriceMin: 350,
        estimatedPriceMax: 500,
        status: RequestStatus.inProgress,
        shortlistedVehicleIds: const [],
        interestedSaathis: const [],
        createdAt: Timestamp.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: RequestHistoryDetailScreen(request: req),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Job In Progress'), findsOneWidget);
      expect(find.text('View Active Request'), findsOneWidget);
    });
  });
}
