import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for AlertsApi
void main() {
  final instance = FieldopsApi().getAlertsApi();

  group(AlertsApi, () {
    // One alert
    //
    //Future<AlertDto> alertsControllerGet(String id) async
    test('test alertsControllerGet', () async {
      // TODO
    });

    // Alerts in your scope, newest first (admin all, ward inspector ward, inspector team)
    //
    //Future<AlertPageDto> alertsControllerList({ bool isResolved, String alertType, String severity, String staffId, DateTime from, DateTime to, int page, int pageSize }) async
    test('test alertsControllerList', () async {
      // TODO
    });

    // Resolve an open alert with an optional note (never one about yourself)
    //
    //Future<AlertDto> alertsControllerResolve(String id, ResolveAlertDto resolveAlertDto) async
    test('test alertsControllerResolve', () async {
      // TODO
    });

  });
}
