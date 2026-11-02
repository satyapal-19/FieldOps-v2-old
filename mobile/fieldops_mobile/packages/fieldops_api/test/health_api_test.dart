import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for HealthApi
void main() {
  final instance = FieldopsApi().getHealthApi();

  group(HealthApi, () {
    // Liveness: the process is up
    //
    //Future<HealthDto> healthControllerHealth() async
    test('test healthControllerHealth', () async {
      // TODO
    });

    // Readiness: database reachable and all migrations applied
    //
    //Future<ReadyDto> healthControllerReady() async
    test('test healthControllerReady', () async {
      // TODO
    });

  });
}
