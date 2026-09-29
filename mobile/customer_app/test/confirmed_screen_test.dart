import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/features/request/presentation/confirmed_screen.dart';
import 'package:customer_app/features/request/data/confirmed_repository.dart';

void main() {
  group('ConfirmedScreen Tests', () {
    testWidgets('Displays confirmed saathi details and request summary', (WidgetTester tester) async {
      final mockRequest = RequestModel(
        id: 'req-1',
        customerId: 'cust-1',
        vehicleTypeRequested: VehicleType.pickup,
        workType: WorkType.farm,
        timing: RequestTiming.now,
        durationType: DurationType.twoHour,
        pickupLocation: const GeoPoint(0, 0),
        estimatedPriceMin: 350,
        estimatedPriceMax: 500,
        status: RequestStatus.matched,
        shortlistedVehicleIds: const [],
        interestedSaathis: [
          InterestedSaathiModel(saathiId: 'saathi-1', vehicleId: 'veh-1', markedAt: Timestamp.now()),
        ],
        selectedSaathiId: 'saathi-1',
        createdAt: Timestamp.now(),
      );

      final mockUser = UserModel(
        id: 'saathi-1',
        role: UserRole.vahanSaathi,
        phone: '+919999999999',
        name: 'Ramesh Bhai',
        village: 'Anand',
        taluka: 'Anand',
        createdAt: Timestamp.now(),
        banned: false,
      );

      final mockProfile = VahanSaathiModel(
        id: 'saathi-1',
        vehicles: ['veh-1'],
        ratingAvg: 4.8,
        ratingCount: 120,
        verificationStatus: VerificationStatus.approved,
      );

      final mockData = ConfirmedData(
        request: mockRequest,
        saathiUser: mockUser,
        saathiProfile: mockProfile,
        vehicle: null,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            confirmedDataProvider.overrideWith((ref, arg) {
              return mockData;
            }),
          ],
          child: const MaterialApp(
            home: ConfirmedScreen(requestId: 'req-1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Your Vahan Saathi is confirmed'), findsOneWidget);
      expect(find.text('Name: Ramesh Bhai'), findsOneWidget);
      expect(find.text('Rating: 4.8 ⭐️'), findsOneWidget);
      expect(find.text('Vehicle: PICKUP'), findsOneWidget);
      expect(find.text('Registration: Available on arrival'), findsOneWidget);
      
      expect(find.text('Call'), findsOneWidget);
      expect(find.text('WhatsApp'), findsOneWidget);

      expect(find.text('Work: FARM'), findsOneWidget);
      expect(find.text('Estimated: ₹350 – ₹500'), findsOneWidget);
    });

    testWidgets('Displays completion CTA when inProgress', (WidgetTester tester) async {
      final mockRequest = RequestModel(
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
        interestedSaathis: [
          InterestedSaathiModel(saathiId: 'saathi-1', vehicleId: 'veh-1', markedAt: Timestamp.now()),
        ],
        selectedSaathiId: 'saathi-1',
        createdAt: Timestamp.now(),
      );

      final mockUser = UserModel(
        id: 'saathi-1',
        role: UserRole.vahanSaathi,
        phone: '+919999999999',
        name: 'Ramesh Bhai',
        village: 'Anand',
        taluka: 'Anand',
        createdAt: Timestamp.now(),
        banned: false,
      );

      final mockProfile = VahanSaathiModel(
        id: 'saathi-1',
        vehicles: ['veh-1'],
        ratingAvg: 4.8,
        ratingCount: 120,
        verificationStatus: VerificationStatus.approved,
      );

      final mockData = ConfirmedData(
        request: mockRequest,
        saathiUser: mockUser,
        saathiProfile: mockProfile,
        vehicle: null,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            confirmedDataProvider.overrideWith((ref, arg) {
              return mockData;
            }),
          ],
          child: const MaterialApp(
            home: ConfirmedScreen(requestId: 'req-1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Job in Progress'), findsOneWidget);
      expect(find.text('Mark Job Complete'), findsOneWidget);
    });

    testWidgets('Displays rating CTA when completed', (WidgetTester tester) async {
      final mockRequest = RequestModel(
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
        interestedSaathis: [
          InterestedSaathiModel(saathiId: 'saathi-1', vehicleId: 'veh-1', markedAt: Timestamp.now()),
        ],
        selectedSaathiId: 'saathi-1',
        createdAt: Timestamp.now(),
      );

      final mockUser = UserModel(
        id: 'saathi-1',
        role: UserRole.vahanSaathi,
        phone: '+919999999999',
        name: 'Ramesh Bhai',
        village: 'Anand',
        taluka: 'Anand',
        createdAt: Timestamp.now(),
        banned: false,
      );

      final mockProfile = VahanSaathiModel(
        id: 'saathi-1',
        vehicles: ['veh-1'],
        ratingAvg: 4.8,
        ratingCount: 120,
        verificationStatus: VerificationStatus.approved,
      );

      final mockData = ConfirmedData(
        request: mockRequest,
        saathiUser: mockUser,
        saathiProfile: mockProfile,
        vehicle: null,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            confirmedDataProvider.overrideWith((ref, arg) {
              return mockData;
            }),
          ],
          child: const MaterialApp(
            home: ConfirmedScreen(requestId: 'req-1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Job Completed'), findsOneWidget);
      expect(find.text('Rate Vahan Saathi'), findsOneWidget);
    });
  });
}
