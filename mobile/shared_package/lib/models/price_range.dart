class PriceRange {
  final double min;
  final double max;

  const PriceRange({
    required this.min,
    required this.max,
  });

  factory PriceRange.fromMap(Map<String, dynamic> map) {
    return PriceRange(
      min: (map['min'] as num).toDouble(),
      max: (map['max'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'min': min,
      'max': max,
    };
  }
}
