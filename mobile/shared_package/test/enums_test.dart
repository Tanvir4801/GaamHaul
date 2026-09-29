import 'package:flutter_test/flutter_test.dart';
import 'package:shared_package/shared_package.dart';

void main() {
  group('Enums Serialization Tests', () {
    test('VehicleType serialization', () {
      expect(VehicleType.miniTruck.value, 'mini_truck');
      expect(VehicleType.fromString('mini_truck'), VehicleType.miniTruck);

      expect(() => VehicleType.fromString('invalid_type'), throwsArgumentError);
    });

    test('WorkType serialization', () {
      expect(WorkType.farm.value, 'farm');
      expect(WorkType.fromString('farm'), WorkType.farm);
    });

    test('RequestTiming serialization', () {
      expect(RequestTiming.scheduled.value, 'scheduled');
      expect(RequestTiming.fromString('scheduled'), RequestTiming.scheduled);
    });
  });
}
