import 'package:flutter_test/flutter_test.dart';
import 'package:shared_package/shared_package.dart';

void main() {
  group('Haversine distance tests', () {
    test('calculateDistanceMeters should calculate correct distance', () {
      // coordinates of two places roughly known
      // Paris
      const lat1 = 48.8566;
      const lon1 = 2.3522;
      // London
      const lat2 = 51.5074;
      const lon2 = -0.1278;

      final distance = HaversineUtil.calculateDistanceKm(lat1, lon1, lat2, lon2);
      // Roughly 343 km
      expect(distance, closeTo(343.0, 10.0));
      
      final distMeters = HaversineUtil.calculateDistanceMeters(lat1, lon1, lat2, lon2);
      expect(distMeters, closeTo(343000.0, 10000.0));
    });

    test('calculateDistance should return 0 for identical coordinates', () {
      final distance = HaversineUtil.calculateDistanceMeters(10.0, 10.0, 10.0, 10.0);
      expect(distance, 0.0);
    });
  });
}
