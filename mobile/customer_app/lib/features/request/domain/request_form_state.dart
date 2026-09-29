import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_package/shared_package.dart';

class RequestFormState {
  final int currentStep;
  final VehicleType? vehicleType;
  final WorkType? workType;
  final RequestTiming? timing;
  final DateTime? scheduledAt;
  final DurationType? durationType;
  final String? customDurationText;
  final GeoPoint? pickupLocation;
  final GeoPoint? destinationLocation;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;
  final String? createdRequestId;

  RequestFormState({
    this.currentStep = 0,
    this.vehicleType,
    this.workType,
    this.timing,
    this.scheduledAt,
    this.durationType,
    this.customDurationText,
    this.pickupLocation,
    this.destinationLocation,
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
    this.createdRequestId,
  });

  RequestFormState copyWith({
    int? currentStep,
    VehicleType? vehicleType,
    WorkType? workType,
    RequestTiming? timing,
    DateTime? scheduledAt,
    DurationType? durationType,
    String? customDurationText,
    GeoPoint? pickupLocation,
    GeoPoint? destinationLocation,
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
    String? createdRequestId,
  }) {
    return RequestFormState(
      currentStep: currentStep ?? this.currentStep,
      vehicleType: vehicleType ?? this.vehicleType,
      workType: workType ?? this.workType,
      timing: timing ?? this.timing,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationType: durationType ?? this.durationType,
      customDurationText: customDurationText ?? this.customDurationText,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage, // We typically want to clear it if not explicitly passed, but let's allow explicit nulls. We'll just reset it manually.
      isSuccess: isSuccess ?? this.isSuccess,
      createdRequestId: createdRequestId ?? this.createdRequestId,
    );
  }

  RequestFormState clearError() {
    return RequestFormState(
      currentStep: currentStep,
      vehicleType: vehicleType,
      workType: workType,
      timing: timing,
      scheduledAt: scheduledAt,
      durationType: durationType,
      customDurationText: customDurationText,
      pickupLocation: pickupLocation,
      destinationLocation: destinationLocation,
      isSubmitting: isSubmitting,
      errorMessage: null,
      isSuccess: isSuccess,
      createdRequestId: createdRequestId,
    );
  }
}
