enum RequestStatus {
  open('open'),
  matched('matched'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled');

  final String value;
  const RequestStatus(this.value);

  factory RequestStatus.fromString(String value) {
    return RequestStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown RequestStatus: $value'),
    );
  }
}
