import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/features/request/presentation/waiting_screen.dart';
import 'package:customer_app/features/request/data/request_repository.dart';

void main() {
  group('WaitingScreen Tests', () {
    testWidgets('Displays finding saathis state when open and no interested saathis', (WidgetTester tester) async {
      final mockRequest = RequestModel(
        id: 'test-req-id',
        customerId: 'test-cust',
        vehicleTypeRequested: VehicleType.pickup,
        workType: WorkType.farm,
        timing: RequestTiming.now,
        durationType: DurationType.twoHour,
        pickupLocation: const GeoPoint(0, 0),
        estimatedPriceMin: 350,
        estimatedPriceMax: 500,
        status: RequestStatus.open,
        shortlistedVehicleIds: const [],
        interestedSaathis: const [],
        createdAt: Timestamp.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            requestStreamProvider.overrideWith((ref, arg) {
              return Stream.value(mockRequest);
            }),
          ],
          child: const MaterialApp(
            home: WaitingScreen(requestId: 'test-req-id'),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Finding nearby Vahan Saathis'), findsOneWidget);
      expect(find.text('Vehicle: PICKUP'), findsOneWidget);
      expect(find.text('Work: FARM'), findsOneWidget);
      expect(find.text('Cancel Request'), findsOneWidget);
    });

    testWidgets('Displays cancelled state when request is cancelled', (WidgetTester tester) async {
      final mockRequest = RequestModel(
        id: 'test-req-id',
        customerId: 'test-cust',
        vehicleTypeRequested: VehicleType.pickup,
        workType: WorkType.farm,
        timing: RequestTiming.now,
        durationType: DurationType.twoHour,
        pickupLocation: const GeoPoint(0, 0),
        estimatedPriceMin: 350,
        estimatedPriceMax: 500,
        status: RequestStatus.cancelled,
        shortlistedVehicleIds: const [],
        interestedSaathis: const [],
        createdAt: Timestamp.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            requestStreamProvider.overrideWith((ref, arg) {
              return Stream.value(mockRequest);
            }),
          ],
          child: const MaterialApp(
            home: WaitingScreen(requestId: 'test-req-id'),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Request cancelled'), findsOneWidget);
      expect(find.text('This request is no longer active.'), findsOneWidget);
    });
  });
}
