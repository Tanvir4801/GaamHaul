import 'package:flutter_test/flutter_test.dart';
import 'package:shared_package/shared_package.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('GeohashUtil tests', () {
    test('encodeGeoPoint returns correct hash', () {
      const geoPoint = GeoPoint(23.022505, 72.571362); // Ahmedabad
      final hash = GeohashUtil.encodeGeoPoint(geoPoint, precision: 9);
      expect(hash, isNotEmpty);
      expect(hash.length, 9);
    });

    test('encode returns deterministic hash', () {
      final hash1 = GeohashUtil.encode(23.022505, 72.571362);
      final hash2 = GeohashUtil.encode(23.022505, 72.571362);
      expect(hash1, hash2);
    });
  });
}
