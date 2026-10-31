import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Offline queue for attendance check-ins and location pings.
/// Stores failed uploads as JSON and replays them on reconnect.
class OfflineQueueService {
  static const _checkInKey  = 'offline_checkin_queue';
  static const _pingKey     = 'offline_ping_queue';
  static const _checkOutKey = 'offline_checkout_queue';

  // ── Check-in queue ─────────────────────────────────────────

  Future<void> enqueueCheckIn(Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    final list  = _getList(prefs, _checkInKey);
    list.add(jsonEncode(payload));
    await prefs.setStringList(_checkInKey, list);
  }

  Future<List<Map<String, dynamic>>> getPendingCheckIns() async {
    final prefs = await SharedPreferences.getInstance();
    return _getList(prefs, _checkInKey)
        .map((s) => jsonDecode(s) as Map<String, dynamic>)
        .toList();
  }

  Future<void> clearCheckInQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_checkInKey);
  }

  // ── Check-out queue ────────────────────────────────────────

  Future<void> enqueueCheckOut(Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    final list  = _getList(prefs, _checkOutKey);
    list.add(jsonEncode(payload));
    await prefs.setStringList(_checkOutKey, list);
  }

  Future<List<Map<String, dynamic>>> getPendingCheckOuts() async {
    final prefs = await SharedPreferences.getInstance();
    return _getList(prefs, _checkOutKey)
        .map((s) => jsonDecode(s) as Map<String, dynamic>)
        .toList();
  }

  Future<void> clearCheckOutQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_checkOutKey);
  }

  // ── Location ping queue ────────────────────────────────────

  Future<void> enqueuePing(Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    final list  = _getList(prefs, _pingKey);
    // Keep max 200 pings to avoid unbounded growth
    if (list.length >= 200) list.removeAt(0);
    list.add(jsonEncode(payload));
    await prefs.setStringList(_pingKey, list);
  }

  Future<List<Map<String, dynamic>>> getPendingPings() async {
    final prefs = await SharedPreferences.getInstance();
    return _getList(prefs, _pingKey)
        .map((s) => jsonDecode(s) as Map<String, dynamic>)
        .toList();
  }

  Future<void> clearPingQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pingKey);
  }

  // ── Helpers ────────────────────────────────────────────────

  List<String> _getList(SharedPreferences prefs, String key) {
    return List<String>.from(prefs.getStringList(key) ?? []);
  }

  Future<bool> hasAnyPending() async {
    final checkIns  = await getPendingCheckIns();
    final checkOuts = await getPendingCheckOuts();
    final pings     = await getPendingPings();
    return checkIns.isNotEmpty || checkOuts.isNotEmpty || pings.isNotEmpty;
  }
}
