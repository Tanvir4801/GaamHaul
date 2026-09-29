import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../auth/data/auth_repository.dart';
import '../data/saathi_vehicle_repository.dart';

final vehicleRegistrationControllerProvider =
    NotifierProvider<VehicleRegistrationController, VehicleRegistrationState>(
        VehicleRegistrationController.new);

class VehicleRegistrationState {
  final VehicleType? type;
  final String registrationNumber;
  final File? vehiclePhoto;
  final File? rcPhoto;
  final bool isLoading;
  final String? error;

  VehicleRegistrationState({
    this.type,
    this.registrationNumber = '',
    this.vehiclePhoto,
    this.rcPhoto,
    this.isLoading = false,
    this.error,
  });

  VehicleRegistrationState copyWith({
    VehicleType? type,
    String? registrationNumber,
    File? vehiclePhoto,
    File? rcPhoto,
    bool? isLoading,
    String? error,
  }) {
    return VehicleRegistrationState(
      type: type ?? this.type,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      vehiclePhoto: vehiclePhoto ?? this.vehiclePhoto,
      rcPhoto: rcPhoto ?? this.rcPhoto,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Don't copy old error
    );
  }
}

class VehicleRegistrationController extends Notifier<VehicleRegistrationState> {
  @override
  VehicleRegistrationState build() {
    return VehicleRegistrationState();
  }

  void setType(VehicleType type) {
    state = state.copyWith(type: type);
  }

  void setRegistrationNumber(String regNumber) {
    state = state.copyWith(registrationNumber: regNumber.trim().toUpperCase());
  }

  void setVehiclePhoto(File file) {
    state = state.copyWith(vehiclePhoto: file);
  }

  void setRcPhoto(File file) {
    state = state.copyWith(rcPhoto: file);
  }

  Future<bool> submit() async {
    if (state.type == null ||
        state.registrationNumber.isEmpty ||
        state.vehiclePhoto == null ||
        state.rcPhoto == null) {
      state = state.copyWith(error: 'Please complete all fields and select photos.');
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final repo = ref.read(saathiVehicleRepositoryProvider);
      
      await repo.registerVehicle(
        ownerId: user.uid,
        type: state.type!,
        registrationNumber: state.registrationNumber,
        vehiclePhoto: state.vehiclePhoto!,
        rcPhoto: state.rcPhoto!,
      );

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
