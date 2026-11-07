import 'dart:async';

import 'package:fieldops_mobile/core/api/session_manager.dart';
import 'package:fieldops_mobile/core/api/session_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final t0 = DateTime.utc(2026, 11, 3, 6);

  StoredSession session(String access, {Duration accessLeft = const Duration(minutes: 10)}) => StoredSession(
        accessToken: access,
        accessExpiresAt: t0.add(accessLeft),
        refreshToken: 'r-$access',
        refreshExpiresAt: t0.add(const Duration(days: 30)),
      );

  late MemoryKeyValue store;
  late SessionManager mgr;
  late int calls;

  setUp(() {
    store = MemoryKeyValue();
    calls = 0;
    mgr = SessionManager(storage: store, now: () => t0);
  });

  test('a fresh token is returned without refreshing', () async {
    await mgr.save(session('a1'));
    mgr.refresher = (_) async => throw StateError('no refresh expected');
    expect(await mgr.accessToken(), 'a1');
  });

  test('refreshes 60 s before expiry and stores the new tokens', () async {
    await mgr.save(session('a1', accessLeft: const Duration(seconds: 59)));
    mgr.refresher = (rt) async {
      calls++;
      expect(rt, 'r-a1');
      return session('a2');
    };
    expect(await mgr.accessToken(), 'a2');
    expect(calls, 1);
    final reloaded = SessionManager(storage: store, now: () => t0);
    expect((await reloaded.current())!.accessToken, 'a2');
  });

  test('parallel callers share one refresh (refresh tokens rotate)', () async {
    await mgr.save(session('a1', accessLeft: Duration.zero));
    final gate = Completer<StoredSession>();
    mgr.refresher = (_) {
      calls++;
      return gate.future;
    };
    final results = Future.wait([mgr.accessToken(), mgr.accessToken(), mgr.accessToken()]);
    await Future<void>.delayed(Duration.zero);
    gate.complete(session('a2'));
    expect(await results, ['a2', 'a2', 'a2']);
    expect(calls, 1);
  });

  test('a stale 401 reuses a token another request already refreshed', () async {
    await mgr.save(session('a2'));
    mgr.refresher = (_) async => throw StateError('no refresh expected');
    expect((await mgr.refresh(staleAccessToken: 'a1'))!.accessToken, 'a2');
  });

  test('a refused refresh clears the session and reports it', () async {
    await mgr.save(session('a1', accessLeft: Duration.zero));
    var expired = 0;
    mgr.onExpired = () => expired++;
    mgr.refresher = (_) async => throw const SessionExpiredException();
    await expectLater(mgr.accessToken(), throwsA(isA<SessionExpiredException>()));
    expect(await mgr.hasSession, isFalse);
    expect(store.values, isEmpty);
    expect(expired, 1);
  });

  test('a network failure keeps the session for later', () async {
    await mgr.save(session('a1', accessLeft: Duration.zero));
    mgr.refresher = (_) async => throw StateError('offline');
    await expectLater(mgr.accessToken(), throwsStateError);
    expect(await mgr.hasSession, isTrue);
  });

  test('an expired refresh token signs out without calling the server', () async {
    await mgr.save(StoredSession(
      accessToken: 'a1',
      accessExpiresAt: t0,
      refreshToken: 'r',
      refreshExpiresAt: t0.subtract(const Duration(seconds: 1)),
    ));
    mgr.refresher = (_) async {
      calls++;
      return session('a2');
    };
    await expectLater(mgr.accessToken(), throwsA(isA<SessionExpiredException>()));
    expect(calls, 0);
  });

  test('no session means no token', () async {
    expect(await mgr.accessToken(), isNull);
  });
}
