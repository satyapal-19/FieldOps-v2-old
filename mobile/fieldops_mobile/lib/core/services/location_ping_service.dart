import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'offline_queue_service.dart';

const _taskName       = 'smkmc_location_ping';
const _syncTaskName   = 'smkmc_offline_sync';

// Default demo staff ID (Ramesh Patil) used if user hasn't explicitly logged in yet
const _defaultStaffId = '20000000-0000-0000-0000-000000000011';

/// Top-level callback required by Workmanager (must be @pragma)
@pragma('vm:entry-point')
void workmanagerCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case _taskName:
        await _recordLocationPing(inputData);
        break;
      case _syncTaskName:
        await _syncOfflineQueue();
        break;
    }
    return true;
  });
}

Future<SupabaseClient?> _getOrInitSupabase() async {
  try {
    return Supabase.instance.client;
  } catch (_) {
    try {
      await Supabase.initialize(
        url: const String.fromEnvironment('SUPABASE_URL'),
        // ignore: deprecated_member_use
        anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      );
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }
}

Future<String> _resolveStaffId(String? passedStaffId) async {
  if (passedStaffId != null && passedStaffId.isNotEmpty) {
    return passedStaffId;
  }
  try {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('cached_staff_profile');
    if (cached != null && cached.isNotEmpty) {
      final regExp = RegExp(r'"id"\s*:\s*"([^"]+)"');
      final match = regExp.firstMatch(cached);
      if (match != null && match.group(1) != null) {
        return match.group(1)!;
      }
    }
  } catch (_) {}
  return _defaultStaffId;
}

Future<void> _recordLocationPing(Map<String, dynamic>? inputData) async {
  try {
    final staffId = await _resolveStaffId(inputData?['staff_id'] as String?);
    final logId   = inputData?['attendance_log_id'] as String?;

    // Check GPS permissions before querying
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 12),
      ),
    );

    // Dynamically resolve ward polygon and staff info from cached profile
    List<Map<String, double>> activePolygon = const [
      {'lat': 16.8431, 'lng': 74.6008},
      {'lat': 16.8431, 'lng': 74.6032},
      {'lat': 16.8455, 'lng': 74.6032},
      {'lat': 16.8455, 'lng': 74.6008},
      {'lat': 16.8431, 'lng': 74.6008},
    ];
    String activeWardId = '11111111-0000-0000-0000-000000000004';
    String staffName = 'Ramesh Vishnu Patil';
    String staffNameMr = 'रमेश विष्णू पाटील';

    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString('cached_staff_profile');
      if (cachedJson != null && cachedJson.isNotEmpty) {
        final profile = jsonDecode(cachedJson) as Map<String, dynamic>;
        if (profile['name'] != null) staffName = profile['name'].toString();
        if (profile['name_mr'] != null) staffNameMr = profile['name_mr'].toString();
        if (profile['ward_id'] != null) activeWardId = profile['ward_id'].toString();

        final ward = profile['wards'] as Map<String, dynamic>?;
        var boundary = ward?['boundary'];
        if (boundary is String) boundary = jsonDecode(boundary);
        if (boundary != null && boundary['coordinates'] != null) {
          final coords = (boundary['coordinates'][0] as List)
              .map((c) => {
                    'lat': (c[1] as num).toDouble(),
                    'lng': (c[0] as num).toDouble(),
                  })
              .toList();
          if (coords.length >= 3) {
            activePolygon = List<Map<String, double>>.from(coords);
          }
        }
      }
    } catch (_) {}

    int n = activePolygon.length;
    bool isWithinWard = false;
    int j = n - 1;
    for (int i = 0; i < n; j = i++) {
      final xi = activePolygon[i]['lng']!;
      final yi = activePolygon[i]['lat']!;
      final xj = activePolygon[j]['lng']!;
      final yj = activePolygon[j]['lat']!;
      if (((yi > position.latitude) != (yj > position.latitude)) &&
          (position.longitude < (xj - xi) * (position.latitude - yi) / (yj - yi) + xi)) {
        isWithinWard = !isWithinWard;
      }
    }

    final payload = <String, dynamic>{
      'staff_id': staffId,
      if (logId != null && logId.isNotEmpty) 'attendance_log_id': logId,
      'lat': position.latitude,
      'lng': position.longitude,
      'accuracy_m': position.accuracy,
      'is_within_ward': isWithinWard,
      'recorded_at': DateTime.now().toUtc().toIso8601String(),
      'synced_from_offline': false,
    };

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = !connectivity.contains(ConnectivityResult.none);

    if (isOnline) {
      final supabase = await _getOrInitSupabase();
      if (supabase != null) {
        await supabase.from('location_pings').insert(payload);
        debugPrint('[GPS Ping] Sent live ping to Web Dashboard: ${position.latitude}, ${position.longitude} (in ward: $isWithinWard)');

        // If outside assigned ward geofence, send real-time OUT_OF_ZONE alert to supervisor
        if (!isWithinWard) {
          try {
            final now = DateTime.now().toUtc().toIso8601String();
            await supabase.from('alerts').insert({
              'staff_id': staffId,
              'ward_id': activeWardId,
              'alert_type': 'OUT_OF_ZONE',
              'severity': 'HIGH',
              'message': 'Shift Breadcrumb Alert: $staffName is OUTSIDE assigned geofence (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})',
              'message_mr': 'थेट बीट अलर्ट: $staffNameMr हे नियुक्त प्रभागाबाहेर आढळले.',
              'location_lat': position.latitude,
              'location_lng': position.longitude,
              'is_resolved': false,
              'resolved': false,
              'triggered_at': now,
              'created_at': now,
            });
          } catch (e) {
            debugPrint('[Ping OutOfZone Alert]: $e');
          }
        }
      } else {
        await OfflineQueueService().enqueuePing(payload);
      }
    } else {
      await OfflineQueueService().enqueuePing(payload);
    }
  } catch (e) {
    debugPrint('[GPS Ping] Non-fatal ping error: $e');
  }
}

Future<void> _syncOfflineQueue() async {
  try {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none) && connectivity.length == 1) return;

    final queue    = OfflineQueueService();
    final supabase = await _getOrInitSupabase();
    if (supabase == null) return;

    // Sync location pings
    final pings = await queue.getPendingPings();
    if (pings.isNotEmpty) {
      await supabase.from('location_pings').insert(pings);
      await queue.clearPingQueue();
    }

    // Sync check-ins
    final checkIns = await queue.getPendingCheckIns();
    for (final ci in checkIns) {
      await supabase.from('attendance_logs').upsert(ci);
    }
    if (checkIns.isNotEmpty) await queue.clearCheckInQueue();

    // Sync check-outs
    final checkOuts = await queue.getPendingCheckOuts();
    for (final co in checkOuts) {
      final id = co['id'];
      await supabase.from('attendance_logs').update(co).eq('id', id);
    }
    if (checkOuts.isNotEmpty) await queue.clearCheckOutQueue();
  } catch (_) {}
}

/// Service to manage background & foreground live location pings
class LocationPingService {
  static final LocationPingService _instance = LocationPingService._internal();
  factory LocationPingService() => _instance;
  LocationPingService._internal();

  Timer? _foregroundTimer;
  String? _activeStaffId;
  String? _activeAttendanceLogId;

  /// Send immediate live GPS location to Supabase / Web Dashboard right now
  Future<void> sendLivePing({String? staffId, String? attendanceLogId}) async {
    try {
      final resolvedStaff = staffId ?? _activeStaffId;
      final resolvedLog = attendanceLogId ?? _activeAttendanceLogId;
      await _recordLocationPing({
        if (resolvedStaff != null) 'staff_id': resolvedStaff,
        if (resolvedLog != null) 'attendance_log_id': resolvedLog,
      });
    } catch (e) {
      debugPrint('[LocationPingService] sendLivePing note: $e');
    }
  }

  /// Start live tracking: sends immediately on open, then repeats every 10 minutes in foreground & background
  Future<void> startLiveTracking({
    String? staffId,
    String? attendanceLogId,
  }) async {
    if (staffId != null) _activeStaffId = staffId;
    if (attendanceLogId != null) _activeAttendanceLogId = attendanceLogId;

    // 1. Immediately send live location on app open
    await sendLivePing(staffId: _activeStaffId, attendanceLogId: _activeAttendanceLogId);

    // 2. Set up foreground/app timer to fire every 10 minutes continuously
    _foregroundTimer?.cancel();
    _foregroundTimer = Timer.periodic(const Duration(minutes: 10), (_) async {
      debugPrint('[LocationPingService] 10-minute periodic ping triggering...');
      await sendLivePing(staffId: _activeStaffId, attendanceLogId: _activeAttendanceLogId);
    });

    // 3. Register background Workmanager task for when app is minimized or backgrounded
    final effectiveStaff = await _resolveStaffId(_activeStaffId);
    try {
      await Workmanager().registerPeriodicTask(
        _taskName,
        _taskName,
        frequency: const Duration(minutes: 15), // Android Workmanager standard periodic frequency
        inputData: {
          'staff_id': effectiveStaff,
          if (_activeAttendanceLogId != null) 'attendance_log_id': _activeAttendanceLogId,
        },
        constraints: Constraints(
          networkType: NetworkType.notRequired, // Collects offline & syncs when online
        ),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      );
    } catch (e) {
      debugPrint('[LocationPingService] Workmanager register note: $e');
    }
  }

  /// Backward compatible alias for startLiveTracking
  Future<void> startPinging({String? staffId, String? attendanceLogId}) =>
      startLiveTracking(staffId: staffId, attendanceLogId: attendanceLogId);

  /// Stop tracking
  Future<void> stopTracking() async {
    _foregroundTimer?.cancel();
    _foregroundTimer = null;
    try {
      await Workmanager().cancelByUniqueName(_taskName);
    } catch (_) {}
  }

  /// Backward compatible alias for stopTracking
  Future<void> stopPinging() => stopTracking();

  /// Register periodic offline sync
  Future<void> registerOfflineSync() async {
    try {
      await Workmanager().registerPeriodicTask(
        _syncTaskName,
        _syncTaskName,
        frequency: const Duration(minutes: 15),
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
    } catch (_) {}
  }
}
