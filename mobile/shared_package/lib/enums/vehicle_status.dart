enum VehicleStatus {
  onDuty('on_duty'),
  offDuty('off_duty'),
  busy('busy');

  final String value;
  const VehicleStatus(this.value);

  factory VehicleStatus.fromString(String value) {
    return VehicleStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown VehicleStatus: $value'),
    );
  }
}
