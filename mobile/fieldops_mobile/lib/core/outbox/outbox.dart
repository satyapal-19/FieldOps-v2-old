import 'dart:async';
import 'dart:math';

/// What an outbox row carries. Every kind is retry-safe on the server because
/// each item has its own client UUID with a unique constraint.
enum OutboxKind {
  /// `POST /attendance/pings`, sent in batches of up to 200.
  ping,

  /// `POST /attendance/tamper-events`, batched.
  tamper,

  /// `POST /tasks/{ref}/updates`, one at a time in the order recorded.
  taskUpdate,
}

class OutboxItem {
  final int? id;
  final OutboxKind kind;
  final String clientUuid;

  /// Wire JSON of the request item (a serialized DTO).
  final String payload;

  /// Path parameter, e.g. the task ID of a task update.
  final String? ref;
  final int attempts;
  final DateTime nextAttemptAt;
  final DateTime createdAt;
  final String? lastError;

  const OutboxItem({
    this.id,
    required this.kind,
    required this.clientUuid,
    required this.payload,
    this.ref,
    this.attempts = 0,
    required this.nextAttemptAt,
    required this.createdAt,
    this.lastError,
  });
}

/// Storage port: SQLite in the app, memory in tests.
abstract class OutboxStore {
  Future<void> add(OutboxItem item);

  /// Items of [kind] due at [now], oldest first.
  Future<List<OutboxItem>> due(OutboxKind kind, DateTime now, int limit);
  Future<void> remove(List<int> ids);
  Future<void> reschedule(List<int> ids, DateTime nextAttemptAt, String error);
  Future<int> count([OutboxKind? kind]);

  /// Drops the oldest rows of [kind] beyond [max] (a phone offline for weeks).
  Future<void> trim(OutboxKind kind, int max);
}

/// Outcome of sending a group of items.
class SendOutcome {
  /// Stored on the server, or already there (duplicate client UUID): remove.
  final Set<String> done;

  /// Refused for good (validation, not allowed): remove, never resend.
  final Map<String, String> rejected;

  const SendOutcome({this.done = const {}, this.rejected = const {}});
}

/// Thrown by a sender when the whole group should be tried again later
/// (no network, server error, rate limit).
class RetryLater implements Exception {
  final String reason;
  const RetryLater(this.reason);
  @override
  String toString() => 'RetryLater($reason)';
}

typedef OutboxSender = Future<SendOutcome> Function(
    OutboxKind kind, List<OutboxItem> items);

/// Pure retry rules.
class OutboxPolicy {
  static const base = Duration(seconds: 30);
  static const cap = Duration(minutes: 30);

  static int batchSize(OutboxKind kind) => switch (kind) {
        OutboxKind.ping => 200,
        OutboxKind.tamper => 50,
        OutboxKind.taskUpdate => 1,
      };

  /// Rows kept per kind while offline: 10-min pings for ~3 weeks of shifts.
  static int maxRows(OutboxKind kind) => switch (kind) {
        OutboxKind.ping => 5000,
        OutboxKind.tamper => 500,
        OutboxKind.taskUpdate => 1000,
      };

  /// 30 s, 60 s, 2 min … capped at 30 min, plus up to 20 % jitter so 4,000
  /// phones coming back online together do not hit the server in one second.
  static Duration backoff(int attempts, [double jitter = 0]) {
    final exp = min(attempts, 10);
    final ms = min(base.inMilliseconds * pow(2, exp), cap.inMilliseconds).toInt();
    return Duration(milliseconds: ms + (ms * 0.2 * jitter.clamp(0, 1)).toInt());
  }
}

/// Queues writes and drains them, one flush at a time.
class Outbox {
  final OutboxStore store;
  final OutboxSender sender;
  final DateTime Function() _now;
  final Random _random;
  Future<int>? _flushing;

  Outbox({
    required this.store,
    required this.sender,
    DateTime Function()? now,
    Random? random,
  })  : _now = now ?? (() => DateTime.now().toUtc()),
        _random = random ?? Random();

  Future<void> enqueue(
    OutboxKind kind,
    String clientUuid,
    String payload, {
    String? ref,
  }) async {
    final now = _now();
    await store.add(OutboxItem(
      kind: kind,
      clientUuid: clientUuid,
      payload: payload,
      ref: ref,
      nextAttemptAt: now,
      createdAt: now,
    ));
    await store.trim(kind, OutboxPolicy.maxRows(kind));
  }

  Future<int> pending([OutboxKind? kind]) => store.count(kind);

  /// Sends everything due. Returns how many items left the outbox. Calls made
  /// while a flush runs share it.
  Future<int> flush() {
    final running = _flushing;
    if (running != null) return running;
    final f = _flushAll();
    _flushing = f;
    return f.whenComplete(() => _flushing = null);
  }

  Future<int> _flushAll() async {
    var sent = 0;
    for (final kind in OutboxKind.values) {
      sent += await _flushKind(kind);
    }
    return sent;
  }

  Future<int> _flushKind(OutboxKind kind) async {
    var sent = 0;
    final size = OutboxPolicy.batchSize(kind);
    while (true) {
      final batch = await store.due(kind, _now(), size);
      if (batch.isEmpty) return sent;
      SendOutcome outcome;
      try {
        outcome = await sender(kind, batch);
      } on RetryLater catch (e) {
        await _retry(batch, e.reason);
        return sent;
      } catch (e) {
        await _retry(batch, e.toString());
        return sent;
      }
      final finished = <int>[];
      final left = <OutboxItem>[];
      for (final item in batch) {
        if (outcome.done.contains(item.clientUuid) ||
            outcome.rejected.containsKey(item.clientUuid)) {
          finished.add(item.id!);
        } else {
          left.add(item);
        }
      }
      await store.remove(finished);
      sent += finished.length;
      if (left.isNotEmpty) {
        // The server did not say what happened to these: try them later.
        await _retry(left, 'no result');
        return sent;
      }
      if (batch.length < size) return sent;
    }
  }

  Future<void> _retry(List<OutboxItem> items, String reason) async {
    // One schedule per group, from the item tried most.
    final attempts = items.map((i) => i.attempts).reduce(max);
    final next = _now().add(OutboxPolicy.backoff(attempts, _random.nextDouble()));
    await store.reschedule(items.map((i) => i.id!).toList(), next, reason);
  }
}

class MemoryOutboxStore implements OutboxStore {
  final List<OutboxItem> rows = [];
  int _seq = 0;

  @override
  Future<void> add(OutboxItem item) async {
    if (rows.any((r) => r.kind == item.kind && r.clientUuid == item.clientUuid)) return;
    rows.add(OutboxItem(
      id: ++_seq,
      kind: item.kind,
      clientUuid: item.clientUuid,
      payload: item.payload,
      ref: item.ref,
      attempts: item.attempts,
      nextAttemptAt: item.nextAttemptAt,
      createdAt: item.createdAt,
    ));
  }

  @override
  Future<List<OutboxItem>> due(OutboxKind kind, DateTime now, int limit) async =>
      rows
          .where((r) => r.kind == kind && !r.nextAttemptAt.isAfter(now))
          .take(limit)
          .toList();

  @override
  Future<void> remove(List<int> ids) async => rows.removeWhere((r) => ids.contains(r.id));

  @override
  Future<void> reschedule(List<int> ids, DateTime nextAttemptAt, String error) async {
    for (var i = 0; i < rows.length; i++) {
      final r = rows[i];
      if (!ids.contains(r.id)) continue;
      rows[i] = OutboxItem(
        id: r.id,
        kind: r.kind,
        clientUuid: r.clientUuid,
        payload: r.payload,
        ref: r.ref,
        attempts: r.attempts + 1,
        nextAttemptAt: nextAttemptAt,
        createdAt: r.createdAt,
        lastError: error,
      );
    }
  }

  @override
  Future<int> count([OutboxKind? kind]) async =>
      rows.where((r) => kind == null || r.kind == kind).length;

  @override
  Future<void> trim(OutboxKind kind, int max) async {
    final ofKind = rows.where((r) => r.kind == kind).toList();
    final extra = ofKind.length - max;
    if (extra > 0) {
      final drop = ofKind.take(extra).map((r) => r.id).toSet();
      rows.removeWhere((r) => drop.contains(r.id));
    }
  }
}
