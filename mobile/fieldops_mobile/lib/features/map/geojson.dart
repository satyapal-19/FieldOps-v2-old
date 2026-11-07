import 'package:latlong2/latlong.dart';

/// Outer rings of a GeoJSON Polygon or MultiPolygon (ward boundary from
/// `WardDto.boundary`), as map points. Anything else gives an empty list.
List<List<LatLng>> outerRings(Object? geometry) {
  if (geometry is! Map) return const [];
  final coords = geometry['coordinates'];
  List<LatLng> ring(Object? r) => r is List
      ? r
          .whereType<List>()
          .where((p) => p.length >= 2 && p[0] is num && p[1] is num)
          .map((p) => LatLng((p[1] as num).toDouble(), (p[0] as num).toDouble()))
          .toList()
      : const [];
  switch (geometry['type']) {
    case 'Polygon':
      return coords is List && coords.isNotEmpty ? [ring(coords.first)] : const [];
    case 'MultiPolygon':
      return coords is List
          ? coords.whereType<List>().where((poly) => poly.isNotEmpty).map((poly) => ring(poly.first)).toList()
          : const [];
    default:
      return const [];
  }
}
