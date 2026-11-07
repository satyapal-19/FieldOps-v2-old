import 'dart:async';

import 'package:fieldops_api/fieldops_api.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

import '../api/api_service.dart';
import '../outbox/outbox_service.dart';
import '../outbox/sqlite_outbox_store.dart';

const _pingTask = 'smkmc_location_ping';
const _syncTask = 'smkmc_outbox_sync';

/// Set while a field shift is checked in: pings are sent only then.
const _trackingKey = 'tracking_active';

/// Workmanager entry point. Runs in its own isolate, so it builds its own
/// API client and opens the same SQLite outbox.
@pragma('vm:entry-point')
void workmanagerCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      if (!Get.isRegistered<ApiService>()) Get.put(ApiService(), permanent: true);
      final outbox = OutboxService(await SqliteOutboxStore.open());
      if (taskName == _pingTask) {
        final prefs = await SharedPreferences.getInstance();
        if (prefs.getBool(_trackingKey) ?? false) {
          await LocationPingService.recordPing(outbox);
        }
      }
      await outbox.flush();
    } catch (e) {
      debugPrint('[Workmanager] $taskName: $e');
    }
    return true;
  });
}

/// Breadcrumb pings during a field shift (about every 10 minutes) and the
/// tamper watchdog. Pings never decide anything on the phone: the server
/// checks the geofence and raises OUT_OF_ZONE itself.
class LocationPingService {
  static final LocationPingService _instance = LocationPingService._internal();
  factory LocationPingService() => _instance;
  LocationPingService._internal();

  static const interval = Duration(minutes: 10);
  static const _uuid = Uuid();

  Timer? _timer;
  StreamSubscription<ServiceStatus>? _gpsStatus;
  DateTime? _gpsOffSince;
  bool _mockReported = false;

  /// Takes one fix and stores it in the outbox (sent now or when online).
  static Future<void> recordPing(OutboxService outbox) async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await outbox.addTamper(_tamper(TamperEventDtoEventTypeEnum.PERMISSION_REVOKED));
      return;
    }
    if (!await Geolocator.isLocationServiceEnabled()) return; // watchdog records it
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );
    await outbox.addPing(PingDto((b) => b
      ..clientUuid = _uuid.v4()
      ..latitude = pos.latitude
      ..longitude = pos.longitude
      ..accuracyM = pos.accuracy
      ..isMocked = pos.isMocked
      ..fromOffline = false
      ..recordedAt = pos.timestamp.toUtc()));
  }

  static TamperEventDto _tamper(
    TamperEventDtoEventTypeEnum type, {
    DateTime? startedAt,
    DateTime? resolvedAt,
    Position? last,
  }) =>
      TamperEventDto((b) => b
        ..clientUuid = _uuid.v4()
        ..eventType = type
        ..startedAt = (startedAt ?? DateTime.now()).toUtc()
        ..resolvedAt = resolvedAt?.toUtc()
        ..lastLatitude = last?.latitude
        ..lastLongitude = last?.longitude);

  OutboxService? get _outbox =>
      Get.isRegistered<OutboxService>() ? Get.find<OutboxService>() : null;

  /// After a field check-in: ping now, then every 10 minutes, in the
  /// foreground (timer) and background (Workmanager, every 15 minutes).
  Future<void> startLiveTracking() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_trackingKey, true);
    _mockReported = false;

    await sendLivePing();
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => sendLivePing());
    _watchGps();
    try {
      await Workmanager().registerPeriodicTask(
        _pingTask,
        _pingTask,
        frequency: const Duration(minutes: 15),
        constraints: Constraints(networkType: NetworkType.notRequired),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      );
    } catch (e) {
      debugPrint('[LocationPingService] Workmanager register: $e');
    }
  }

  /// Only starts tracking if the stored state says a shift is checked in
  /// (app restarted during a shift).
  Future<void> resumeIfActive() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_trackingKey) ?? false) await startLiveTracking();
  }

  Future<void> sendLivePing() async {
    final outbox = _outbox;
    if (outbox == null) return;
    try {
      await recordPing(outbox);
      final pos = await Geolocator.getLastKnownPosition();
      if (pos != null && pos.isMocked && !_mockReported) {
        _mockReported = true;
        await outbox.addTamper(_tamper(TamperEventDtoEventTypeEnum.MOCK_LOCATION, last: pos));
      }
    } catch (e) {
      debugPrint('[LocationPingService] ping: $e');
    }
  }

  void _watchGps() {
    _gpsStatus?.cancel();
    try {
      _gpsStatus = Geolocator.getServiceStatusStream().listen((status) async {
        if (status == ServiceStatus.disabled) {
          _gpsOffSince ??= DateTime.now();
          return;
        }
        final since = _gpsOffSince;
        _gpsOffSince = null;
        if (since == null) return;
        await _outbox?.addTamper(_tamper(
          TamperEventDtoEventTypeEnum.GPS_DISABLED,
          startedAt: since,
          resolvedAt: DateTime.now(),
          last: await Geolocator.getLastKnownPosition(),
        ));
        await sendLivePing();
      });
    } catch (e) {
      debugPrint('[LocationPingService] GPS status stream: $e');
    }
  }

  /// At check-out or sign-out.
  Future<void> stopLiveTracking() async {
    _timer?.cancel();
    _timer = null;
    final since = _gpsOffSince;
    _gpsOffSince = null;
    if (since != null) {
      await _outbox?.addTamper(_tamper(TamperEventDtoEventTypeEnum.GPS_DISABLED,
          startedAt: since, resolvedAt: DateTime.now()));
    }
    await _gpsStatus?.cancel();
    _gpsStatus = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_trackingKey, false);
    try {
      await Workmanager().cancelByUniqueName(_pingTask);
    } catch (_) {}
  }

  /// Sends whatever is waiting in the outbox every 15 minutes when online.
  Future<void> registerOutboxSync() async {
    try {
      await Workmanager().registerPeriodicTask(
        _syncTask,
        _syncTask,
        frequency: const Duration(minutes: 15),
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
    } catch (_) {}
  }
}
