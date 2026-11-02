import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for WardsApi
void main() {
  final instance = FieldopsApi().getWardsApi();

  group(WardsApi, () {
    // Is a point inside the ward or within the 25 m edge allowance?
    //
    //Future<LocationCheckResultDto> wardsControllerCheckLocation(String id, LocationCheckDto locationCheckDto) async
    test('test wardsControllerCheckLocation', () async {
      // TODO
    });

    // Create a ward (ADMIN)
    //
    //Future<WardDto> wardsControllerCreate(CreateWardDto createWardDto) async
    test('test wardsControllerCreate', () async {
      // TODO
    });

    // Get one ward with its boundary
    //
    //Future<WardDto> wardsControllerGet(String id) async
    test('test wardsControllerGet', () async {
      // TODO
    });

    // List wards (paged, by code)
    //
    //Future<WardPageDto> wardsControllerList({ int page, int pageSize }) async
    test('test wardsControllerList', () async {
      // TODO
    });

    // Update a ward (ADMIN, optimistic locking via expectedVersion)
    //
    //Future<WardDto> wardsControllerUpdate(String id, UpdateWardDto updateWardDto) async
    test('test wardsControllerUpdate', () async {
      // TODO
    });

  });
}
