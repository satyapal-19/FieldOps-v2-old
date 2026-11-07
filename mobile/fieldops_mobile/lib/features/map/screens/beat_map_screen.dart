import 'package:fieldops_api/fieldops_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/api/api_service.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/notify.dart';
import '../../attendance/attendance_rules.dart';
import '../geojson.dart';

/// My ward for today, where I am, and the route the server recorded for my
/// current shift (`GET /staff/{me}/route`). OpenStreetMap tiles; the tile
/// server is set with `--dart-define=TILE_URL=...` (own tile pack later).
class BeatMapScreen extends StatefulWidget {
  const BeatMapScreen({super.key});

  @override
  State<BeatMapScreen> createState() => _BeatMapScreenState();
}

class _BeatMapScreenState extends State<BeatMapScreen> {
  static const _tileUrl = String.fromEnvironment(
    'TILE_URL',
    defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );
  // Sangli city centre, only until the first fix or ward arrives.
  static const _fallbackCentre = LatLng(16.8524, 74.5815);

  final _map = MapController();
  final _auth = Get.find<AuthController>();
  WardDto? _ward;
  RouteDto? _route;
  Position? _me;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final staffId = _auth.staffId;
    if (staffId == null) return;
    setState(() => _loading = true);
    final api = Get.find<ApiService>();
    try {
      _me = await Geolocator.getLastKnownPosition();
    } catch (_) {}
    try {
      _route = (await api.attendance.routeControllerRoute(
        id: staffId,
        date: AttendanceRules.istDate(DateTime.now().toUtc()),
      ))
          .data;
    } catch (_) {
      _route = null; // no shift today yet
    }
    final wardId = _route?.shift?.wardId ?? _auth.profile.value?.homeWardId;
    try {
      if (wardId != null) {
        _ward = wardId == _auth.homeWard.value?.id
            ? _auth.homeWard.value
            : (await api.wards.wardsControllerGet(id: wardId)).data;
      }
    } catch (e) {
      Notify.failure(e);
    }
    if (!mounted) return;
    setState(() => _loading = false);
    final rings = _rings;
    if (rings.isNotEmpty && rings.first.length > 2) {
      _map.fitCamera(CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(rings.expand((r) => r).toList()),
        padding: const EdgeInsets.all(32),
      ));
    } else if (_me != null) {
      _map.move(LatLng(_me!.latitude, _me!.longitude), 16);
    }
  }

  List<List<LatLng>> get _rings {
    final b = _ward?.boundary;
    if (b == null) return const [];
    return outerRings(b.toMap().map((k, v) => MapEntry(k, v?.value)));
  }

  @override
  Widget build(BuildContext context) {
    final route = _route?.points.map((p) => LatLng(p.latitude.toDouble(), p.longitude.toDouble())).toList() ?? [];
    final wardName = _ward == null ? '' : (AuthController.lang == 'mr' ? _ward!.nameMr : _ward!.name);
    return Scaffold(
      appBar: AppBar(
        title: Text(wardName.isEmpty ? 'nav_map'.tr : wardName),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loading ? null : _load),
        ],
      ),
      body: Stack(children: [
        FlutterMap(
          mapController: _map,
          options: const MapOptions(initialCenter: _fallbackCentre, initialZoom: 14),
          children: [
            TileLayer(urlTemplate: _tileUrl, userAgentPackageName: 'com.smkmc.fieldops_mobile'),
            PolygonLayer(polygons: [
              for (final r in _rings)
                Polygon(
                  points: r,
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderColor: AppColors.primary,
                  borderStrokeWidth: 2,
                ),
            ]),
            if (route.length > 1)
              PolylineLayer(polylines: [
                Polyline(points: route, strokeWidth: 4, color: AppColors.holiday),
              ]),
            if (_me != null)
              MarkerLayer(markers: [
                Marker(
                  point: LatLng(_me!.latitude, _me!.longitude),
                  width: 36,
                  height: 36,
                  child: const Icon(Icons.my_location, color: AppColors.error, size: 30),
                ),
              ]),
            const RichAttributionWidget(attributions: [TextSourceAttribution('OpenStreetMap contributors')]),
          ],
        ),
        if (_loading) const LinearProgressIndicator(),
        if (_route != null)
          Positioned(
            left: 12,
            right: 12,
            bottom: 24,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _route!.pointsPurged
                      ? 'route_purged'.tr
                      : 'route_points'.trParams({'n': '${_route!.points.length}'}),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
