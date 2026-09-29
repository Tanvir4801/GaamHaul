enum VehicleType {
  eLoader('e_loader'),
  pickup('pickup'),
  tempo('tempo'),
  miniTruck('mini_truck'),
  tractor('tractor');

  final String value;
  const VehicleType(this.value);

  factory VehicleType.fromString(String value) {
    return VehicleType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown VehicleType: $value'),
    );
  }
}
