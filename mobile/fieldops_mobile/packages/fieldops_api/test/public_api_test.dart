import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for PublicApi
void main() {
  final instance = FieldopsApi().getPublicApi();

  group(PublicApi, () {
    // File a civic complaint (no sign-in); returns the tracking ID
    //
    //Future<PublicComplaintDto> publicComplaintsControllerSubmit(SubmitComplaintDto submitComplaintDto) async
    test('test publicComplaintsControllerSubmit', () async {
      // TODO
    });

    // Track a complaint by its tracking ID (no sign-in)
    //
    //Future<PublicComplaintDto> publicComplaintsControllerTrack(String trackingId) async
    test('test publicComplaintsControllerTrack', () async {
      // TODO
    });

  });
}
