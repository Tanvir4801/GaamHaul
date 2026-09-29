import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/request_form_state.dart';
import '../data/request_repository.dart';

final requestFormControllerProvider = NotifierProvider<RequestFormController, RequestFormState>(RequestFormController.new);

class RequestFormController extends Notifier<RequestFormState> {
  @override
  RequestFormState build() {
    return RequestFormState();
  }

  void setVehicle(VehicleType type) {
    state = state.clearError().copyWith(vehicleType: type);
  }

  void setWorkType(WorkType type) {
    state = state.clearError().copyWith(workType: type);
  }

  void setTiming(RequestTiming timing, {DateTime? scheduledAt}) {
    state = state.clearError().copyWith(timing: timing, scheduledAt: scheduledAt);
  }

  void setDuration(DurationType type, {String? customText}) {
    state = state.clearError().copyWith(durationType: type, customDurationText: customText);
  }

  void setPickupLocation(GeoPoint location) {
    state = state.clearError().copyWith(pickupLocation: location);
  }

  void setDestinationLocation(GeoPoint? location) {
    state = state.clearError().copyWith(destinationLocation: location);
  }

  bool nextStep() {
    if (!_validateCurrentStep()) return false;
    
    if (state.currentStep < 5) {
      state = state.clearError().copyWith(currentStep: state.currentStep + 1);
      return true;
    }
    return false;
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.clearError().copyWith(currentStep: state.currentStep - 1);
    }
  }

  bool _validateCurrentStep() {
    switch (state.currentStep) {
      case 0: // Vehicle
        if (state.vehicleType == null) {
          state = state.copyWith(errorMessage: 'Please select a vehicle type.');
          return false;
        }
        break;
      case 1: // Work
        if (state.workType == null) {
          state = state.copyWith(errorMessage: 'Please select a work type.');
          return false;
        }
        break;
      case 2: // Location
        if (state.pickupLocation == null) {
          state = state.copyWith(errorMessage: 'Please select a pickup location.');
          return false;
        }
        break;
      case 3: // Timing
        if (state.timing == null) {
          state = state.copyWith(errorMessage: 'Please select timing.');
          return false;
        }
        if (state.timing == RequestTiming.scheduled) {
          if (state.scheduledAt == null) {
            state = state.copyWith(errorMessage: 'Please select a scheduled time.');
            return false;
          }
          if (state.scheduledAt!.isBefore(DateTime.now())) {
            state = state.copyWith(errorMessage: 'Scheduled time must be in the future.');
            return false;
          }
        }
        break;
      case 4: // Duration
        if (state.durationType == null) {
          state = state.copyWith(errorMessage: 'Please select a duration.');
          return false;
        }
        break;
      case 5: // Review (no next step validation needed here, handled by submit)
        break;
    }
    return true;
  }

  PriceRange? getEstimatedPrice() {
    if (state.vehicleType != null && state.durationType != null) {
      return RateCardCalculator.calculateEstimatedPrice(
        vehicleType: state.vehicleType!,
        durationType: state.durationType!,
      );
    }
    return null;
  }

  Future<void> submitRequest() async {
    if (state.isSubmitting) return; // Prevent double submit
    if (!_validateCurrentStep()) return;

    final priceRange = getEstimatedPrice();
    if (priceRange == null) {
      state = state.copyWith(errorMessage: 'Cannot calculate price estimate. Missing selections.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = state.copyWith(errorMessage: 'User not authenticated.');
      return;
    }

    state = state.clearError().copyWith(isSubmitting: true);

    try {
      final repo = ref.read(requestRepositoryProvider);
      final reqId = repo.generateId();

      final request = RequestModel(
        id: reqId,
        customerId: user.uid,
        vehicleTypeRequested: state.vehicleType!,
        workType: state.workType!,
        timing: state.timing!,
        scheduledAt: state.timing == RequestTiming.scheduled 
            ? Timestamp.fromDate(state.scheduledAt!) 
            : null,
        durationType: state.durationType!,
        pickupLocation: state.pickupLocation!,
        destinationLocation: state.destinationLocation,
        estimatedPriceMin: priceRange.min,
        estimatedPriceMax: priceRange.max,
        status: RequestStatus.open,
        shortlistedVehicleIds: const [],
        interestedSaathis: const [],
        selectedSaathiId: null,
        finalPrice: null,
        createdAt: Timestamp.now(),
        matchedAt: null,
        completedAt: null,
      );

      await repo.createRequest(request);
      state = state.copyWith(isSubmitting: false, isSuccess: true, createdRequestId: reqId);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to submit request. Please try again.',
      );
    }
  }

  void jumpToStep(int step) {
    if (step >= 0 && step <= 5) {
      state = state.clearError().copyWith(currentStep: step);
    }
  }

  void resetFlow() {
    state = RequestFormState();
  }
}
