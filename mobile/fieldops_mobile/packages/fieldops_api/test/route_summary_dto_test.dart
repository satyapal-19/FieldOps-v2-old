import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for RouteSummaryDto
void main() {
  final instance = RouteSummaryDtoBuilder();
  // TODO add properties to the builder and call build()

  group(RouteSummaryDto, () {
    // LIVE = computed now from the raw points; NIGHTLY = the stored roll-up
    // String source_
    test('to test the property `source_`', () async {
      // TODO
    });

    // num pingCount
    test('to test the property `pingCount`', () async {
      // TODO
    });

    // Trusted distance (no mocked or > 50 m fixes), metres
    // num distanceM
    test('to test the property `distanceM`', () async {
      // TODO
    });

    // DateTime firstPingAt
    test('to test the property `firstPingAt`', () async {
      // TODO
    });

    // DateTime lastPingAt
    test('to test the property `lastPingAt`', () async {
      // TODO
    });

    // num inWardPings
    test('to test the property `inWardPings`', () async {
      // TODO
    });

    // num outWardPings
    test('to test the property `outWardPings`', () async {
      // TODO
    });

    // num stationaryPings
    test('to test the property `stationaryPings`', () async {
      // TODO
    });

    // num mockedPings
    test('to test the property `mockedPings`', () async {
      // TODO
    });

    // num offlinePings
    test('to test the property `offlinePings`', () async {
      // TODO
    });

    // num maxGapMinutes
    test('to test the property `maxGapMinutes`', () async {
      // TODO
    });

    // num tamperEvents
    test('to test the property `tamperEvents`', () async {
      // TODO
    });

  });
}
