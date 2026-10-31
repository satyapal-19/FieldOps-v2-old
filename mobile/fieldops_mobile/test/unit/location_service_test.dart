import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fieldops_mobile/core/services/location_service.dart';

void main() {
  group('LocationService Tests', () {
    final locationService = LocationService();

    test('isAccuracyAcceptable returns true for accuracy <= 80m', () {
      final accuratePos = Position(
        latitude: 16.8524,
        longitude: 74.5815,
        timestamp: DateTime.now(),
        accuracy: 15.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
      expect(locationService.isAccuracyAcceptable(accuratePos), isTrue);

      final boundaryPos = Position(
        latitude: 16.8524,
        longitude: 74.5815,
        timestamp: DateTime.now(),
        accuracy: 80.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
      expect(locationService.isAccuracyAcceptable(boundaryPos), isTrue);

      final poorPos = Position(
        latitude: 16.8524,
        longitude: 74.5815,
        timestamp: DateTime.now(),
        accuracy: 120.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
      expect(locationService.isAccuracyAcceptable(poorPos), isFalse);
    });

    test('isInsidePolygon works with polygon boundaries and empty polygons', () {
      // Sangli Ward mock bounding box
      final polygon = [
        {'lat': 16.8500, 'lng': 74.5800},
        {'lat': 16.8600, 'lng': 74.5800},
        {'lat': 16.8600, 'lng': 74.5900},
        {'lat': 16.8500, 'lng': 74.5900},
      ];

      // Point inside
      expect(locationService.isInsidePolygon(16.8550, 74.5850, polygon), isTrue);

      // Point outside
      expect(locationService.isInsidePolygon(16.8700, 74.5850, polygon), isFalse);

      // Empty boundary fallback — allows check-in when ward boundary is not configured
      expect(locationService.isInsidePolygon(16.8550, 74.5850, []), isTrue);
    });

    test('distanceBetween calculates real-world geodesic distance accurately', () {
      // Sangli (16.8524, 74.5815) to Miraj (16.8222, 74.6465) is approx 7.5 - 8.5 km
      final dist = locationService.distanceBetween(
        16.8524, 74.5815,
        16.8222, 74.6465,
      );
      expect(dist, greaterThan(7000));
      expect(dist, lessThan(9000));
    });

    test('statusColor returns correct status indicators', () {
      expect(locationService.statusColor(true, true), const Color(0xFF2E7D32));
      expect(locationService.statusColor(false, true), const Color(0xFFC62828));
      expect(locationService.statusColor(true, false), Colors.orange);
      expect(locationService.statusColor(false, false), Colors.orange);
    });
  });
}
