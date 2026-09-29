import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saathi_app/features/vehicle/presentation/vehicle_registration_controller.dart';
import 'package:shared_package/shared_package.dart';

void main() {
  group('VehicleRegistrationController logic tests', () {
    test('submit fails if inputs are missing', () async {
      final container = ProviderContainer();
      final controller = container.read(vehicleRegistrationControllerProvider.notifier);
      
      final success = await controller.submit();
      
      expect(success, false);
      expect(container.read(vehicleRegistrationControllerProvider).error, 'Please complete all fields and select photos.');
    });

    test('state updating works', () {
      final container = ProviderContainer();
      final controller = container.read(vehicleRegistrationControllerProvider.notifier);
      
      controller.setType(VehicleType.miniTruck);
      controller.setRegistrationNumber(' gj01ab1234 ');
      
      final state = container.read(vehicleRegistrationControllerProvider);
      expect(state.type, VehicleType.miniTruck);
      expect(state.registrationNumber, 'GJ01AB1234');
    });
  });
}
