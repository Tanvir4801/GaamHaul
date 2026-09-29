enum DurationType {
  oneHour('1hr'),
  twoHour('2hr'),
  halfDay('half_day'),
  fullDay('full_day'),
  custom('custom');

  final String value;
  const DurationType(this.value);

  factory DurationType.fromString(String value) {
    return DurationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown DurationType: $value'),
    );
  }
}
