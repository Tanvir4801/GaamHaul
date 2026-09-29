enum WorkType {
  farm('farm'),
  nursery('nursery'),
  construction('construction'),
  shifting('shifting'),
  shop('shop'),
  other('other');

  final String value;
  const WorkType(this.value);

  factory WorkType.fromString(String value) {
    return WorkType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown WorkType: $value'),
    );
  }
}
