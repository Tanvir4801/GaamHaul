import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saathi_app/features/request/presentation/incoming_requests_screen.dart';
import 'package:saathi_app/features/request/presentation/incoming_request_details_screen.dart';
import 'package:saathi_app/features/request/data/saathi_request_provider.dart';
import 'package:saathi_app/features/vehicle/data/vehicle_provider.dart';
import 'package:shared_package/shared_package.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('IncomingRequestsScreen UI Tests', () {
    testWidgets('displays empty state when no requests', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            incomingRequestsProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: const MaterialApp(home: IncomingRequestsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No Requests Available'), findsOneWidget);
    });

    testWidgets('displays requests and navigates to details', (WidgetTester tester) async {
      final mockRequest = RequestModel(
        id: 'req1',
        customerId: 'cust1',
        vehicleTypeRequested: VehicleType.pickup,
        workType: WorkType.farm,
        timing: RequestTiming.now,
        durationType: DurationType.twoHour,
        pickupLocation: const GeoPoint(23.0, 72.0),
        estimatedPriceMin: 500,
        estimatedPriceMax: 600,
        status: RequestStatus.open,
        shortlistedVehicleIds: ['veh1'],
        interestedSaathis: [],
        createdAt: Timestamp.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            incomingRequestsProvider.overrideWith((ref) => Stream.value([mockRequest])),
            saathiRequestProvider(mockRequest.id).overrideWith((ref) => Stream.value(mockRequest)),
            saathiVehiclesProvider.overrideWith((ref) => Future.value([
              VehicleModel(
                id: 'veh1',
                ownerId: 'saathi1',
                type: VehicleType.pickup,
                registrationNumber: 'GJ-01-XX-1234',
                photoUrl: '',
                rcPhotoUrl: '',
                status: VehicleStatus.offDuty,
              )
            ])),
          ],
          child: const MaterialApp(home: IncomingRequestsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Check if card is displayed
      expect(find.text('FARM'), findsOneWidget);
      expect(find.text('₹500 - ₹600'), findsOneWidget);

      // Tap on the card
      await tester.tap(find.text('FARM'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Details screen should appear
      expect(find.byType(IncomingRequestDetailsScreen), findsOneWidget);
      expect(find.text('Request Details'), findsOneWidget);
      expect(find.text('Matched to your PICKUP (GJ-01-XX-1234)'), findsOneWidget);
      expect(find.text('Express Interest'), findsOneWidget);

      // Tap Express Interest
      final buttonFinder = find.text('Express Interest');
      await tester.ensureVisible(buttonFinder);
      await tester.tap(buttonFinder);
      await tester.pump(); // start snackbar animation
      await tester.pump(const Duration(milliseconds: 50)); // let snackbar render

      // Snackbar should appear
      expect(find.text('Interest submission will be processed by the backend (Phase 6 Boundary).'), findsOneWidget);

      // Finish the simulated network delay timer and the snackbar timer
      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('displays read-only state for cancelled request', (WidgetTester tester) async {
      final mockRequest = RequestModel(
        id: 'req2',
        customerId: 'cust1',
        vehicleTypeRequested: VehicleType.pickup,
        workType: WorkType.farm,
        timing: RequestTiming.now,
        durationType: DurationType.twoHour,
        pickupLocation: const GeoPoint(23.0, 72.0),
        estimatedPriceMin: 500,
        estimatedPriceMax: 600,
        status: RequestStatus.cancelled,
        shortlistedVehicleIds: ['veh1'],
        interestedSaathis: [],
        createdAt: Timestamp.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            saathiRequestProvider(mockRequest.id).overrideWith((ref) => Stream.value(mockRequest)),
            saathiVehiclesProvider.overrideWith((ref) => Future.value([])),
          ],
          child: MaterialApp(home: IncomingRequestDetailsScreen(request: mockRequest)),
        ),
      );

      await tester.pumpAndSettle();

      // Check read-only state
      expect(find.text('This request is CANCELLED.'), findsOneWidget);
      expect(find.text('You can no longer express interest.'), findsOneWidget);
      expect(find.text('Express Interest'), findsNothing);
    });
  });
}
