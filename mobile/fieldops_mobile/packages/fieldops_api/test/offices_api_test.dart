import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for OfficesApi
void main() {
  final instance = FieldopsApi().getOfficesApi();

  group(OfficesApi, () {
    // Is a point inside the office premises or its buffer?
    //
    //Future<OfficeLocationCheckResultDto> officesControllerCheckLocation(String id, LocationCheckDto locationCheckDto) async
    test('test officesControllerCheckLocation', () async {
      // TODO
    });

    // Create an office (ADMIN)
    //
    //Future<OfficeDto> officesControllerCreate(CreateOfficeDto createOfficeDto) async
    test('test officesControllerCreate', () async {
      // TODO
    });

    // Get one office with its premises
    //
    //Future<OfficeDto> officesControllerGet(String id) async
    test('test officesControllerGet', () async {
      // TODO
    });

    // List corporation offices
    //
    //Future<BuiltList<OfficeDto>> officesControllerList() async
    test('test officesControllerList', () async {
      // TODO
    });

    // Update an office (ADMIN, optimistic locking)
    //
    //Future<OfficeDto> officesControllerUpdate(String id, UpdateOfficeDto updateOfficeDto) async
    test('test officesControllerUpdate', () async {
      // TODO
    });

  });
}
