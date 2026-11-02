import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for PingBatchResultDto
void main() {
  final instance = PingBatchResultDtoBuilder();
  // TODO add properties to the builder and call build()

  group(PingBatchResultDto, () {
    // New pings stored
    // num accepted
    test('to test the property `accepted`', () async {
      // TODO
    });

    // Already stored earlier (safe retries)
    // num duplicates
    test('to test the property `duplicates`', () async {
      // TODO
    });

    // Dropped; do not resend these
    // BuiltList<RejectedItemDto> rejected
    test('to test the property `rejected`', () async {
      // TODO
    });

  });
}
