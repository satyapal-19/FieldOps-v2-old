import 'dart:async';
import 'dart:math';

import 'package:fieldops_mobile/core/outbox/outbox.dart';
import 'package:flutter_test/flutter_test.dart';

class _NoJitter implements Random {
  @override
  double nextDouble() => 0;
  @override
  bool nextBool() => false;
  @override
  int nextInt(int max) => 0;
}

void main() {
  late MemoryOutboxStore store;
  late DateTime now;
  late List<List<String>> sent;
  late Future<SendOutcome> Function(OutboxKind, List<OutboxItem>) reply;
  late Outbox outbox;

  setUp(() {
    store = MemoryOutboxStore();
    now = DateTime.utc(2026, 11, 3, 6);
    sent = [];
    reply = (kind, items) async => SendOutcome(done: items.map((i) => i.clientUuid).toSet());
    outbox = Outbox(
      store: store,
      sender: (kind, items) {
        sent.add(items.map((i) => i.clientUuid).toList());
        return reply(kind, items);
      },
      now: () => now,
      random: _NoJitter(),
    );
  });

  test('sent items leave the outbox', () async {
    await outbox.enqueue(OutboxKind.ping, 'p1', '{}');
    await outbox.enqueue(OutboxKind.ping, 'p2', '{}');
    expect(await outbox.flush(), 2);
    expect(sent, [
      ['p1', 'p2'],
    ]);
    expect(await outbox.pending(), 0);
  });

  test('the same client UUID is stored once', () async {
    await outbox.enqueue(OutboxKind.ping, 'p1', '{}');
    await outbox.enqueue(OutboxKind.ping, 'p1', '{}');
    expect(await outbox.pending(), 1);
  });

  test('pings go in batches of 200', () async {
    for (var i = 0; i < 450; i++) {
      await outbox.enqueue(OutboxKind.ping, 'p$i', '{}');
    }
    await outbox.flush();
    expect(sent.map((b) => b.length), [200, 200, 50]);
  });

  test('task updates go one at a time in recorded order', () async {
    await outbox.enqueue(OutboxKind.taskUpdate, 'start', '{}', ref: 't1');
    await outbox.enqueue(OutboxKind.taskUpdate, 'submit', '{}', ref: 't1');
    await outbox.flush();
    expect(sent, [
      ['start'],
      ['submit'],
    ]);
  });

  test('a failed send waits for its backoff, then goes again', () async {
    reply = (_, __) async => throw const RetryLater('NETWORK');
    await outbox.enqueue(OutboxKind.ping, 'p1', '{}');
    expect(await outbox.flush(), 0);
    expect(store.rows.single.attempts, 1);

    reply = (kind, items) async => SendOutcome(done: items.map((i) => i.clientUuid).toSet());
    now = now.add(const Duration(seconds: 29));
    await outbox.flush();
    expect(await outbox.pending(), 1, reason: 'not due before 30 s');

    now = now.add(const Duration(seconds: 1));
    expect(await outbox.flush(), 1);
    expect(await outbox.pending(), 0);
  });

  test('a stuck task update holds back the ones after it', () async {
    reply = (kind, items) async => throw const RetryLater('SERVICE_UNAVAILABLE');
    await outbox.enqueue(OutboxKind.taskUpdate, 'start', '{}', ref: 't1');
    await outbox.enqueue(OutboxKind.taskUpdate, 'submit', '{}', ref: 't1');
    await outbox.flush();
    expect(sent, [
      ['start'],
    ]);
  });

  test('items refused for good are dropped, the rest kept', () async {
    reply = (kind, items) async => const SendOutcome(done: {'ok'}, rejected: {'bad': 'VALIDATION_FAILED'});
    await outbox.enqueue(OutboxKind.ping, 'ok', '{}');
    await outbox.enqueue(OutboxKind.ping, 'bad', '{}');
    await outbox.enqueue(OutboxKind.ping, 'unknown', '{}');
    expect(await outbox.flush(), 2);
    expect(store.rows.map((r) => r.clientUuid), ['unknown']);
    expect(store.rows.single.attempts, 1);
  });

  test('calls during a flush share it', () async {
    final gate = Completer<SendOutcome>();
    reply = (_, __) => gate.future;
    await outbox.enqueue(OutboxKind.ping, 'p1', '{}');
    final a = outbox.flush();
    final b = outbox.flush();
    gate.complete(const SendOutcome(done: {'p1'}));
    expect(await a, 1);
    expect(await b, 1);
    expect(sent.length, 1);
  });

  test('a phone offline for weeks keeps only the newest rows', () async {
    for (var i = 0; i < OutboxPolicy.maxRows(OutboxKind.tamper) + 5; i++) {
      await outbox.enqueue(OutboxKind.tamper, 't$i', '{}');
    }
    expect(await outbox.pending(OutboxKind.tamper), OutboxPolicy.maxRows(OutboxKind.tamper));
    expect(store.rows.first.clientUuid, 't5');
  });

  test('backoff doubles from 30 s and stops at 30 min, jitter adds up to 20 %', () {
    expect(OutboxPolicy.backoff(0), const Duration(seconds: 30));
    expect(OutboxPolicy.backoff(1), const Duration(minutes: 1));
    expect(OutboxPolicy.backoff(3), const Duration(minutes: 4));
    expect(OutboxPolicy.backoff(6), const Duration(minutes: 30));
    expect(OutboxPolicy.backoff(50), const Duration(minutes: 30));
    expect(OutboxPolicy.backoff(0, 1), const Duration(seconds: 36));
  });
}
