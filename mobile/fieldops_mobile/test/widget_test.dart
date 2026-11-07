import 'package:dio/dio.dart';
import 'package:fieldops_mobile/core/api/api_service.dart';
import 'package:fieldops_mobile/core/api/session_store.dart';
import 'package:fieldops_mobile/core/outbox/outbox.dart';
import 'package:fieldops_mobile/core/outbox/outbox_service.dart';
import 'package:fieldops_mobile/features/auth/screens/otp_login_screen.dart';
import 'package:fieldops_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_adapter.dart';

void main() {
  testWidgets('starts without a session and lands on OTP sign-in', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..httpClientAdapter = FakeAdapter((o) async => (503, {'code': 'SERVICE_UNAVAILABLE'}));
    Get.put(ApiService(storage: MemoryKeyValue(), baseUrl: 'http://api.test', dioOverride: dio), permanent: true);
    Get.put(OutboxService(MemoryOutboxStore()), permanent: true);

    await tester.pumpWidget(const FieldOpsApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, const Duration(seconds: 5));
    expect(find.byType(OtpLoginScreen), findsOneWidget);

    // Stop the outbox's wake-up timer before the test ends.
    Get.find<OutboxService>().onClose();
    Get.reset();
  });
}
