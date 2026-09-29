import 'dart:math' as math;

class HaversineUtil {
  static const double earthRadiusKm = 6371.0;
  static const double earthRadiusMeters = 6371000.0;

  /// Calculates the Haversine distance in meters between two coordinates.
  static double calculateDistanceMeters(double lat1, double lon1, double lat2, double lon2) {
    return _calculateDistance(lat1, lon1, lat2, lon2, earthRadiusMeters);
  }

  /// Calculates the Haversine distance in kilometers between two coordinates.
  static double calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    return _calculateDistance(lat1, lon1, lat2, lon2, earthRadiusKm);
  }

  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2, double radius) {
    final latDistance = _degreesToRadians(lat2 - lat1);
    final lonDistance = _degreesToRadians(lon2 - lon1);

    final a = math.sin(latDistance / 2) * math.sin(latDistance / 2) +
        math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) *
            math.sin(lonDistance / 2) * math.sin(lonDistance / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return radius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }
}
