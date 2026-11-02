import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for FaceApi
void main() {
  final instance = FieldopsApi().getFaceApi();

  group(FaceApi, () {
    // Which face capture flow the app should run (local or Aadhaar FaceRD)
    //
    //Future<FaceCaptureOptionsDto> faceControllerCaptureOptions({ String staffId }) async
    test('test faceControllerCaptureOptions', () async {
      // TODO
    });

  });
}
