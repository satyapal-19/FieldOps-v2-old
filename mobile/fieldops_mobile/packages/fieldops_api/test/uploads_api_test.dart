import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for UploadsApi
void main() {
  final instance = FieldopsApi().getUploadsApi();

  group(UploadsApi, () {
    // A photo, for its uploader and the people who review their work
    //
    //Future<Uint8List> uploadsControllerGet(String id) async
    test('test uploadsControllerGet', () async {
      // TODO
    });

    // Upload a photo (task evidence); returns the key to send as photoKey
    //
    // Retry-safe with clientUuid. Stored on the FieldOps server only.
    //
    //Future<UploadDto> uploadsControllerUpload(MultipartFile file, String clientUuid, String kind) async
    test('test uploadsControllerUpload', () async {
      // TODO
    });

  });
}
