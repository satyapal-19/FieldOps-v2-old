import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Request permissions and return current position.
  /// Returns null if permissions denied or GPS unavailable.
  Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('LocationService: GPS service disabled');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('LocationService: permission denied');
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        debugPrint('LocationService: permission permanently denied');
        return null;
      }

      // Try high accuracy first; fall back to balanced if it times out
      try {
        return await Geolocator.getCurrentPosition(
          locationSettings: AndroidSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 20),
          ),
        );
      } catch (_) {
        // Fallback: lower accuracy with longer timeout
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
          ),
        );
      }
    } catch (e) {
      debugPrint('LocationService error: $e');
      return null;
    }
  }

  /// Check if GPS accuracy is acceptable (<= 80m — accommodates emulators slightly)
  bool isAccuracyAcceptable(Position position) => position.accuracy <= 80.0;

  /// Calculate distance in meters between two lat/lng points
  double distanceBetween(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }

  /// Simple point-in-polygon check for ward geofence.
  /// If polygon is empty → allow check-in (no ward boundary configured).
  bool isInsidePolygon(
    double lat,
    double lng,
    List<Map<String, double>> polygon,
  ) {
    if (polygon.isEmpty) return true;
    int n = polygon.length;
    bool inside = false;
    int j = n - 1;
    for (int i = 0; i < n; j = i++) {
      final xi = polygon[i]['lng']!;
      final yi = polygon[i]['lat']!;
      final xj = polygon[j]['lng']!;
      final yj = polygon[j]['lat']!;
      if (((yi > lat) != (yj > lat)) &&
          (lng < (xj - xi) * (lat - yi) / (yj - yi) + xi)) {
        inside = !inside;
      }
    }
    return inside;
  }

  /// Get human-readable location status color
  Color statusColor(bool withinZone, bool accuracyOk) {
    if (!accuracyOk) return Colors.orange;
    return withinZone ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
  }
}
