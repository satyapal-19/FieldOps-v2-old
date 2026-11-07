import 'package:dio/dio.dart';
import 'package:fieldops_api/fieldops_api.dart';
import 'package:fieldops_mobile/core/api/api_service.dart';
import 'package:fieldops_mobile/core/api/session_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_adapter.dart';

void main() {
  late FakeAdapter adapter;
  late ApiService api;
  late int refreshes;

  setUp(() async {
    refreshes = 0;
    adapter = FakeAdapter((o) async {
      if (o.path.endsWith('/auth/refresh')) {
        refreshes++;
        return (200, tokensJson('a2', 'r2'));
      }
      if (o.path.endsWith('/auth/me')) {
        return o.headers['Authorization'] == 'Bearer a2'
            ? (200, profileJson())
            : (401, {'code': 'UNAUTHENTICATED', 'requestId': 'req-1', 'status': 401});
      }
      if (o.path.endsWith('/public/app-config')) {
        return (200, {
          'minVersionCode': 1,
          'latestVersionCode': 2,
          'faceProvider': 'local',
          'pingIntervalSeconds': 600,
          'silentGapMinutes': 30,
          'serverTime': '2026-11-03T06:00:00.000Z',
        });
      }
      return (404, {'code': 'NOT_FOUND'});
    });
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter;
    api = ApiService(storage: MemoryKeyValue(), baseUrl: 'http://api.test', dioOverride: dio);
    // The real refresher uses its own Dio; send it through the same fake.
    final refreshDio = Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter;
    final refreshApi = FieldopsApi(dio: refreshDio, interceptors: const []).getAuthApi();
    api.session.refresher = (rt) async => ApiService.sessionFromTokens((await refreshApi
            .authControllerRefresh(refreshDto: RefreshDto((b) => b..refreshToken = rt)))
        .data!);
    await api.session.save(StoredSession(
      accessToken: 'a1',
      accessExpiresAt: DateTime.now().toUtc().add(const Duration(minutes: 10)),
      refreshToken: 'r1',
      refreshExpiresAt: DateTime.now().toUtc().add(const Duration(days: 30)),
    ));
  });

  test('adds the bearer token and retries once after a 401', () async {
    final me = await api.auth.authControllerMe();
    expect(me.data!.fullName, 'Test Worker');
    final sent = [
      for (var i = 0; i < adapter.requests.length; i++)
        if (adapter.requests[i].path.endsWith('/auth/me')) adapter.authHeaders[i],
    ];
    expect(sent, ['Bearer a1', 'Bearer a2']);
    expect(refreshes, 1);
    expect((await api.session.current())!.refreshToken, 'r2');
  });

  test('public calls carry no token', () async {
    final info = await api.public.appInfoControllerGet();
    expect(info.data!.minVersionCode, 1);
    final call = adapter.requests.singleWhere((r) => r.path.endsWith('/public/app-config'));
    expect(call.headers.containsKey('Authorization'), isFalse);
  });

  test('profile survives the local cache round trip', () async {
    final me = (await api.auth.authControllerMe()).data!;
    final raw = api.encode(StaffProfileDto.serializer, me);
    expect(api.decode(StaffProfileDto.serializer, raw), me);
    expect(api.decode(StaffProfileDto.serializer, 'not json'), isNull);
  });
}
