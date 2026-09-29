enum UserRole {
  customer('customer'),
  vahanSaathi('vahan_saathi');

  final String value;
  const UserRole(this.value);

  factory UserRole.fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown UserRole: $value'),
    );
  }
}
