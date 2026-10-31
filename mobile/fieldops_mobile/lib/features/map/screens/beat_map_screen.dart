import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../attendance/controllers/attendance_controller.dart';
import 'qr_scanner_screen.dart';

class BeatMapScreen extends StatefulWidget {
  const BeatMapScreen({super.key});

  @override
  State<BeatMapScreen> createState() => _BeatMapScreenState();
}

class _BeatMapScreenState extends State<BeatMapScreen> {
  final _mapController = MapController();
  final _attendance    = Get.find<AttendanceController>();
  final _supabase      = Supabase.instance.client;

  // SMKMC centers for the 3 civic divisions
  static const _sangliCenter = LatLng(16.8524, 74.5815);
  static const _mirajCenter  = LatLng(16.8270, 74.6460);
  static const _kupwadCenter = LatLng(16.8830, 74.6180);

  String _selectedZone = 'SANGLI'; // 'SANGLI', 'MIRAJ', 'KUPWAD'

  bool _showRoute   = true;
  final bool _showPings   = true;
  bool _showBeacons = true;

  List<Map<String, dynamic>> _problemBeacons = [];
  List<LatLng> _liveTrail = [];

  @override
  void initState() {
    super.initState();
    _loadBeacons();
    _loadLivePings();
  }

  Future<void> _loadLivePings() async {
    try {
      final staffId = Get.find<AuthController>().currentStaff.value?['id'];
      if (staffId == null) return;
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final res = await _supabase
          .from('location_pings')
          .select('lat, lng')
          .eq('staff_id', staffId)
          .gte('recorded_at', '${today}T00:00:00Z')
          .order('recorded_at', ascending: true);
      if (mounted && res.isNotEmpty) {
        setState(() {
          _liveTrail = res
              .map((p) => LatLng((p['lat'] as num).toDouble(), (p['lng'] as num).toDouble()))
              .toList();
        });
      }
    } catch (_) {}
  }

  Future<void> _loadBeacons() async {
    try {
      final res = await _supabase
          .from('citizen_complaints')
          .select()
          .neq('status', 'RESOLVED')
          .order('created_at', ascending: false)
          .limit(20);

      if (mounted) {
        setState(() {
          _problemBeacons = List<Map<String, dynamic>>.from(res as List);
        });
      }
    } catch (e) {
      debugPrint('Error loading problem beacons: $e');
    }
  }

  void _switchZone(String zone) {
    setState(() => _selectedZone = zone);
    final target = switch (zone) {
      'MIRAJ'  => _mirajCenter,
      'KUPWAD' => _kupwadCenter,
      _        => _sangliCenter,
    };
    _mapController.move(target, 14.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(children: [
        // ── Map ──────────────────────────────────────────────
        FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: _sangliCenter,
            initialZoom: 14.5,
            interactionOptions: InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            // Base tile layer — OpenStreetMap
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.smkmc.fieldops',
              maxZoom: 19,
            ),

            // Ward boundary polygons
            _buildWardPolygons(),

            // Beat route polyline
            if (_showRoute) _buildBeatRoute(),

            // Problem Beacons (Reported issues)
            if (_showBeacons) _buildBeaconMarkers(),

            // Checkpoints markers
            _buildCheckpointMarkers(),

            // Location ping trail (today's movement)
            if (_showPings) _buildPingTrail(),

            // Staff current location
            _buildStaffMarker(),
          ],
        ),

        // ── Top Zone Selector & Stats Card ───────────────────
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 12, right: 12,
          child: Column(
            children: [
              // Zone Switcher Chips
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildZoneChip('SANGLI', 'सांगली (Sangli)'),
                    _buildZoneChip('MIRAJ', 'मिरज (Miraj)'),
                    _buildZoneChip('KUPWAD', 'कुपवाड (Kupwad)'),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Ward and Checkpoints strip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6)],
                ),
                child: Obx(() {
                  final done  = _attendance.checkpointsDone.value;
                  final total = _attendance.checkpointsTotal.value;
                  return Row(children: [
                    const Icon(Icons.share_location, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'SMKMC $_selectedZone Ward Map',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$done/$total CP Scanned',
                        style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]);
                }),
              ),
            ],
          ),
        ),

        // ── Bottom right map controls ─────────────────────────
        Positioned(
          bottom: 90, right: 12,
          child: Column(children: [
            _MapFab(
              icon: Icons.my_location,
              tooltip: 'माझे स्थान',
              onTap: () {
                final pos = _attendance.gpsPosition.value;
                if (pos != null) {
                  _mapController.move(LatLng(pos.latitude, pos.longitude), 16);
                } else {
                  _mapController.move(_sangliCenter, 15);
                }
              },
            ),
            const SizedBox(height: 8),
            _MapFab(
              icon: Icons.refresh,
              tooltip: 'बीकन्स रीफ्रेश करा',
              onTap: _loadBeacons,
              active: true,
            ),
            const SizedBox(height: 8),
            _MapFab(
              icon: _showBeacons ? Icons.warning : Icons.warning_amber,
              tooltip: 'बीकन्स टॉगल',
              onTap: () => setState(() => _showBeacons = !_showBeacons),
              active: _showBeacons,
            ),
            const SizedBox(height: 8),
            _MapFab(
              icon: _showRoute ? Icons.route : Icons.route_outlined,
              tooltip: 'मार्ग टॉगल',
              onTap: () => setState(() => _showRoute = !_showRoute),
              active: _showRoute,
            ),
          ]),
        ),

        // ── Legend ───────────────────────────────────────────
        Positioned(
          bottom: 90, left: 12,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const _LegendItem(color: AppColors.primary, label: 'बीट मार्ग (Beat Route)'),
                const _LegendItem(color: Colors.orange,     label: 'चेकपॉईंट (Checkpoint)'),
                _LegendItem(color: Colors.red.shade700,    label: 'समस्या बीकन (${_problemBeacons.length})'),
                const _LegendItem(color: Colors.green,      label: 'जीपीएस स्थान (GPS Ping)'),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildZoneChip(String zoneKey, String label) {
    final isSelected = _selectedZone == zoneKey;
    return GestureDetector(
      onTap: () => _switchZone(zoneKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF374151),
            fontFamily: 'NotoSansDevanagari',
          ),
        ),
      ),
    );
  }

  // ── Map layer builders ────────────────────────────────────

  Widget _buildWardPolygons() {
    // Polygons for Sangli, Miraj, and Kupwad civic sectors
    final sangliWard = [
      const LatLng(16.8620, 74.5680),
      const LatLng(16.8620, 74.5940),
      const LatLng(16.8420, 74.5940),
      const LatLng(16.8420, 74.5680),
    ];
    final mirajWard = [
      const LatLng(16.8380, 74.6350),
      const LatLng(16.8380, 74.6600),
      const LatLng(16.8150, 74.6600),
      const LatLng(16.8150, 74.6350),
    ];
    final kupwadWard = [
      const LatLng(16.8950, 74.6050),
      const LatLng(16.8950, 74.6320),
      const LatLng(16.8700, 74.6320),
      const LatLng(16.8700, 74.6050),
    ];

    final walchandCollegeWard = [
      const LatLng(16.8455, 74.6008),
      const LatLng(16.8455, 74.6032),
      const LatLng(16.8431, 74.6032),
      const LatLng(16.8431, 74.6008),
    ];

    return PolygonLayer(polygons: [
      Polygon(
        points: sangliWard,
        color: AppColors.primary.withValues(alpha: 0.06),
        borderColor: AppColors.primary,
        borderStrokeWidth: _selectedZone == 'SANGLI' ? 2.5 : 1,
      ),
      Polygon(
        points: walchandCollegeWard,
        color: const Color(0xFF0052CC).withValues(alpha: 0.18),
        borderColor: const Color(0xFF0052CC),
        borderStrokeWidth: 3.0,
      ),
      Polygon(
        points: mirajWard,
        color: Colors.blue.withValues(alpha: 0.06),
        borderColor: const Color(0xFF1565C0),
        borderStrokeWidth: _selectedZone == 'MIRAJ' ? 2.5 : 1,
      ),
      Polygon(
        points: kupwadWard,
        color: Colors.purple.withValues(alpha: 0.06),
        borderColor: const Color(0xFF6A1B9A),
        borderStrokeWidth: _selectedZone == 'KUPWAD' ? 2.5 : 1,
      ),
    ]);
  }

  Widget _buildBeatRoute() {
    final routePoints = switch (_selectedZone) {
      'MIRAJ' => [
        const LatLng(16.8270, 74.6460),
        const LatLng(16.8290, 74.6480),
        const LatLng(16.8320, 74.6510),
        const LatLng(16.8280, 74.6530),
        const LatLng(16.8250, 74.6490),
        const LatLng(16.8270, 74.6460),
      ],
      'KUPWAD' => [
        const LatLng(16.8830, 74.6180),
        const LatLng(16.8850, 74.6200),
        const LatLng(16.8880, 74.6230),
        const LatLng(16.8840, 74.6250),
        const LatLng(16.8800, 74.6210),
        const LatLng(16.8830, 74.6180),
      ],
      _ => [
        const LatLng(16.8524, 74.5815),
        const LatLng(16.8540, 74.5830),
        const LatLng(16.8555, 74.5850),
        const LatLng(16.8545, 74.5870),
        const LatLng(16.8530, 74.5880),
        const LatLng(16.8510, 74.5865),
        const LatLng(16.8500, 74.5840),
        const LatLng(16.8524, 74.5815),
      ],
    };

    return PolylineLayer(polylines: [
      Polyline(
        points: routePoints,
        strokeWidth: 3.5,
        color: AppColors.primary.withValues(alpha: 0.8),
      ),
    ]);
  }

  Widget _buildCheckpointMarkers() {
    // 18 Mapped checkpoints across Sangli, Miraj, and Kupwad
    final checkpoints = [
      // Sangli checkpoints
      (const LatLng(16.8540, 74.5830), 'CP-S1 — गणपती पेठ चौक', true, 'SANGLI'),
      (const LatLng(16.8555, 74.5850), 'CP-S2 — राजवाडा परिसर', true, 'SANGLI'),
      (const LatLng(16.8545, 74.5870), 'CP-S3 — शासकीय रुग्णालय', false, 'SANGLI'),
      (const LatLng(16.8510, 74.5865), 'CP-S4 — मध्यवर्ती बस स्थानक', false, 'SANGLI'),
      (const LatLng(16.8480, 74.5820), 'CP-S5 — कृष्णा घाट गेट', false, 'SANGLI'),
      (const LatLng(16.8570, 74.5890), 'CP-S6 — विश्रामबाग चौक', false, 'SANGLI'),

      // Miraj checkpoints
      (const LatLng(16.8270, 74.6460), 'CP-M1 — मिरज रेल्वे जंक्शन', true, 'MIRAJ'),
      (const LatLng(16.8290, 74.6480), 'CP-M2 — वानलेस मिशन हॉस्पिटल', false, 'MIRAJ'),
      (const LatLng(16.8320, 74.6510), 'CP-M3 — गांधी चौक मिरज', true, 'MIRAJ'),
      (const LatLng(16.8280, 74.6530), 'CP-M4 — ब्राह्मणपुरी पोस्ट', false, 'MIRAJ'),
      (const LatLng(16.8240, 74.6440), 'CP-M5 — मिरज बस स्टँड', false, 'MIRAJ'),

      // Kupwad checkpoints
      (const LatLng(16.8830, 74.6180), 'CP-K1 — कुपवाड MIDC मेन गेट', true, 'KUPWAD'),
      (const LatLng(16.8850, 74.6200), 'CP-K2 — ग्रामपंचायत चौक', false, 'KUPWAD'),
      (const LatLng(16.8880, 74.6230), 'CP-K3 — MIDC अग्निशामक केंद्र', false, 'KUPWAD'),
      (const LatLng(16.8820, 74.6250), 'CP-K4 — शांतिनगर पाण्याची टाकी', false, 'KUPWAD'),
    ];

    final filtered = checkpoints.where((cp) => cp.$4 == _selectedZone).toList();

    return MarkerLayer(markers: filtered.map((cp) => Marker(
      point: cp.$1,
      width: 36, height: 36,
      child: GestureDetector(
        onTap: () => _showCheckpointInfo(cp.$2, cp.$3),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cp.$3 ? AppColors.primary : Colors.white,
            border: Border.all(color: AppColors.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
              ),
            ],
          ),
          child: Icon(
            cp.$3 ? Icons.check : Icons.qr_code,
            color: cp.$3 ? Colors.white : AppColors.primary,
            size: 18,
          ),
        ),
      ),
    )).toList());
  }

  // ── Problem Beacons Layer (Reported issues on the map) ─────
  Widget _buildBeaconMarkers() {
    if (_problemBeacons.isEmpty) {
      // Mock seed beacons if none in DB for visual display
      final defaultBeacons = [
        {'id': 'b1', 'lat': 16.8535, 'lng': 74.5842, 'category': 'GARBAGE', 'description': 'कचरा कुंडी भरून वाहणे - पेठ रस्ता', 'status': 'RECEIVED'},
        {'id': 'b2', 'lat': 16.8560, 'lng': 74.5865, 'category': 'WATER', 'description': 'मुख्य पाईपलाईन गळती - सिव्हिल कॉर्नर', 'status': 'RECEIVED'},
        {'id': 'b3', 'lat': 16.8285, 'lng': 74.6475, 'category': 'DRAIN', 'description': 'सांडपाणी नाला अडकला - स्टेशन रोड मिरज', 'status': 'RECEIVED'},
        {'id': 'b4', 'lat': 16.8845, 'lng': 74.6210, 'category': 'ROAD', 'description': 'रस्त्यावर मोठा खड्डा - कुपवाड MIDC', 'status': 'RECEIVED'},
      ];
      return _renderBeaconList(defaultBeacons);
    }
    return _renderBeaconList(_problemBeacons);
  }

  Widget _renderBeaconList(List<Map<String, dynamic>> beacons) {
    return MarkerLayer(
      markers: beacons.map((b) {
        final lat = (b['lat'] as num?)?.toDouble() ?? 16.8524;
        final lng = (b['lng'] as num?)?.toDouble() ?? 74.5815;
        final cat = (b['category'] as String? ?? 'GARBAGE').toUpperCase();

        IconData icon = switch (cat) {
          'DRAIN' => Icons.water_damage,
          'ROAD'  => Icons.add_road,
          'WATER' => Icons.water_drop,
          'LIGHT' => Icons.lightbulb,
          _       => Icons.delete,
        };

        Color color = switch (cat) {
          'DRAIN' => Colors.blue,
          'ROAD'  => Colors.brown,
          'WATER' => Colors.teal,
          'LIGHT' => Colors.amber,
          _       => Colors.deepOrange,
        };

        return Marker(
          point: LatLng(lat, lng),
          width: 44,
          height: 44,
          child: GestureDetector(
            onTap: () => _showBeaconDetails(b),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pulsing radar glow
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.25),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showBeaconDetails(Map<String, dynamic> beacon) {
    final cat = beacon['category'] ?? 'GARBAGE';
    final desc = beacon['description'] ?? 'समस्या नोंदवली';
    final photoUrl = beacon['photo_url'] as String?;
    final lat = (beacon['lat'] as num?)?.toDouble() ?? 16.8524;
    final lng = (beacon['lng'] as num?)?.toDouble() ?? 74.5815;
    final id = beacon['id'];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.share_location, color: Colors.red.shade700, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'समस्या बीकन ($cat)',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'NotoSansDevanagari'),
                        ),
                        Text(
                          'स्थान: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: Get.back),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                desc,
                style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937), height: 1.3),
              ),
              if (photoUrl != null && photoUrl.isNotEmpty) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    photoUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Action button to complete work for this beacon!
              FilledButton.icon(
                onPressed: () => _resolveBeacon(id),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'हे काम पूर्ण करा (Resolve Beacon)',
                  style: TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resolveBeacon(dynamic beaconId) async {
    Get.back(); // close details sheet

    // Open live camera to capture completion proof
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, maxWidth: 1024, imageQuality: 85);

    if (picked != null) {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        barrierDismissible: false,
      );

      try {
        if (beaconId != null && !beaconId.toString().startsWith('b')) {
          await _supabase
              .from('citizen_complaints')
              .update({
                'status': 'RESOLVED',
                'resolved_at': DateTime.now().toIso8601String(),
              })
              .eq('id', beaconId);
        }

        await _loadBeacons(); // Refresh beacons
        Get.back(); // close progress

        Get.snackbar(
          'काम पूर्ण झाले ✓',
          'समस्या बीकन यशस्वीरित्या पूर्ण म्हणून नोंदवले गेले आहे.',
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.back();
        Get.snackbar('त्रुटी', 'नोंदवता आले नाही: $e');
      }
    }
  }

  Widget _buildPingTrail() {
    final points = _liveTrail.isNotEmpty
        ? _liveTrail
        : const [
            LatLng(16.8524, 74.5815),
            LatLng(16.8530, 74.5822),
            LatLng(16.8537, 74.5828),
            LatLng(16.8543, 74.5836),
          ];

    return MarkerLayer(markers: points.map((pt) => Marker(
      point: pt,
      width: 12, height: 12,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green.shade600,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      ),
    )).toList());
  }

  Widget _buildStaffMarker() {
    return Obx(() {
      final pos = _attendance.gpsPosition.value;
      final loc = pos != null
          ? LatLng(pos.latitude, pos.longitude)
          : _sangliCenter;

      return MarkerLayer(markers: [
        Marker(
          point: loc,
          width: 48, height: 48,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade700,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.4), blurRadius: 10)],
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ),
      ]);
    });
  }

  void _showCheckpointInfo(String name, bool scanned) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(scanned ? Icons.check_circle : Icons.qr_code_scanner,
              color: scanned ? AppColors.primary : AppColors.subtle, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 12),
        Text(scanned ? '✅ Checkpoint scan झाला आहे' : '⏳ अजून scan झाला नाही',
          style: TextStyle(
            fontFamily: 'NotoSansDevanagari',
            color: scanned ? AppColors.primary : AppColors.subtle,
          )),
        if (!scanned) ...[
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              Get.back(); // close sheet
              Get.to(() => const QrScannerScreen());
            },
            icon: const Icon(Icons.qr_code_scanner, size: 18),
            label: const Text('QR Scan करा (Live Only)', style: TextStyle(fontFamily: 'NotoSansDevanagari')),
          ),
        ],
      ]),
    ));
  }
}

class _MapFab extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool active;

  const _MapFab({required this.icon, required this.tooltip, required this.onTap, this.active = true});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 44, height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.primary : AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 6)],
      ),
      child: Icon(icon, color: active ? Colors.white : AppColors.subtle, size: 22),
    ),
  );
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.5),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 10, color: AppColors.onSurface, fontWeight: FontWeight.w500)),
    ]),
  );
}
