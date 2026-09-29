import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';

class GeohashUtil {
  static final GeoHasher _geoHasher = GeoHasher();

  /// Converts a [GeoPoint] to a geohash string.
  /// Standard precision for our matching is typically 9 characters (close range).
  static String encodeGeoPoint(GeoPoint point, {int precision = 9}) {
    return _geoHasher.encode(point.longitude, point.latitude, precision: precision);
  }

  /// Encodes latitude and longitude directly.
  static String encode(double lat, double lon, {int precision = 9}) {
    return _geoHasher.encode(lon, lat, precision: precision);
  }
}
