import 'package:flutter_test/flutter_test.dart';
import 'package:shared_package/shared_package.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('RequestModel tests', () {
    test('handles nullable fields properly in toFirestore', () {
      final request = RequestModel(
        id: 'test_req',
        customerId: 'customer_1',
        vehicleTypeRequested: VehicleType.tractor,
        workType: WorkType.farm,
        timing: RequestTiming.now,
        durationType: DurationType.twoHour,
        pickupLocation: const GeoPoint(23.0, 72.0),
        estimatedPriceMin: 600,
        estimatedPriceMax: 850,
        status: RequestStatus.open,
        shortlistedVehicleIds: [],
        interestedSaathis: [],
        createdAt: Timestamp.now(),
        // Nullable fields
        scheduledAt: null,
        destinationLocation: null,
        selectedSaathiId: null,
        finalPrice: null,
        matchedAt: null,
        completedAt: null,
      );

      final map = request.toFirestore();
      
      expect(map.containsKey('scheduledAt'), isFalse);
      expect(map.containsKey('destinationLocation'), isFalse);
      expect(map.containsKey('selectedSaathiId'), isFalse);
      expect(map.containsKey('finalPrice'), isFalse);
    });
  });
}
