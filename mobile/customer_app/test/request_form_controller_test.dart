import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:customer_app/features/request/presentation/request_form_controller.dart';

void main() {
  group('RequestFormController Tests', () {
    test('Initial state is step 0', () {
      final container = ProviderContainer();
      final state = container.read(requestFormControllerProvider);
      expect(state.currentStep, 0);
    });

    test('Validates and proceeds to next step', () {
      final container = ProviderContainer();
      final controller = container.read(requestFormControllerProvider.notifier);

      // Try next step without selecting vehicle -> should fail
      var next = controller.nextStep();
      expect(next, false);
      expect(container.read(requestFormControllerProvider).errorMessage, 'Please select a vehicle type.');

      // Select vehicle -> should pass
      controller.setVehicle(VehicleType.pickup);
      next = controller.nextStep();
      expect(next, true);
      expect(container.read(requestFormControllerProvider).currentStep, 1);
    });

    test('Estimated price is calculated', () {
      final container = ProviderContainer();
      final controller = container.read(requestFormControllerProvider.notifier);

      controller.setVehicle(VehicleType.pickup);
      controller.setDuration(DurationType.halfDay);

      final priceRange = controller.getEstimatedPrice();
      expect(priceRange, isNotNull);
      expect(priceRange!.min, 900);
      expect(priceRange.max, 1200);
    });
  });
}
