enum RequestTiming {
  now('now'),
  scheduled('scheduled');

  final String value;
  const RequestTiming(this.value);

  factory RequestTiming.fromString(String value) {
    return RequestTiming.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown RequestTiming: $value'),
    );
  }
}
