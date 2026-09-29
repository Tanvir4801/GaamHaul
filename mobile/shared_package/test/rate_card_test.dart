import 'package:flutter_test/flutter_test.dart';
import 'package:shared_package/shared_package.dart';

void main() {
  group('RateCardCalculator tests', () {
    test('getRateCard returns valid seed for all vehicles', () {
      for (final type in VehicleType.values) {
        final card = RateCardCalculator.getRateCard(type);
        expect(card.vehicleType, type);
        expect(card.oneHour.min, greaterThan(0));
        expect(card.twoHour.max, greaterThan(card.oneHour.min));
      }
    });

    test('calculateEstimatedPrice returns correct bounds', () {
      final bounds = RateCardCalculator.calculateEstimatedPrice(
        vehicleType: VehicleType.miniTruck,
        durationType: DurationType.halfDay,
      );

      // From prompt: mini truck half_day 1600-2200
      expect(bounds.min, 1600);
      expect(bounds.max, 2200);
    });
  });
}
