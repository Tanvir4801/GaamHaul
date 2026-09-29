enum VerificationStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected');

  final String value;
  const VerificationStatus(this.value);

  factory VerificationStatus.fromString(String value) {
    return VerificationStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown VerificationStatus: $value'),
    );
  }
}
