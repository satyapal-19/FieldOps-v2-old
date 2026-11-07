import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for SpotChecksApi
void main() {
  final instance = FieldopsApi().getSpotChecksApi();

  group(SpotChecksApi, () {
    // Spot checks in your scope (admin all, ward inspector ward, inspector team)
    //
    //Future<SpotCheckPageDto> spotChecksControllerList({ String date, String status, int page, int pageSize }) async
    test('test spotChecksControllerList', () async {
      // TODO
    });

    // My spot checks waiting for an answer (poll while on duty)
    //
    //Future<BuiltList<SpotCheckDto>> spotChecksControllerMine() async
    test('test spotChecksControllerMine', () async {
      // TODO
    });

    // Order a spot check now for someone on duty in your scope
    //
    //Future<SpotCheckDto> spotChecksControllerOrder(OrderSpotCheckDto orderSpotCheckDto) async
    test('test spotChecksControllerOrder', () async {
      // TODO
    });

    // Answer: a fresh challenge, the face and where you are (same proof as a punch)
    //
    // A face mismatch can be retried until the deadline; outside the ward is recorded and escalated.
    //
    //Future<SpotCheckDto> spotChecksControllerRespond(String id, RespondSpotCheckDto respondSpotCheckDto) async
    test('test spotChecksControllerRespond', () async {
      // TODO
    });

    // Ask for 10 more minutes, once
    //
    //Future<SpotCheckDto> spotChecksControllerSnooze(String id) async
    test('test spotChecksControllerSnooze', () async {
      // TODO
    });

  });
}
