import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';

// tests for TileManifestDto
void main() {
  final instance = TileManifestDtoBuilder();
  // TODO add properties to the builder and call build()

  group(TileManifestDto, () {
    // False when no offline pack is installed (use the public OSM server)
    // bool available
    test('to test the property `available`', () async {
      // TODO
    });

    // num minZoom
    test('to test the property `minZoom`', () async {
      // TODO
    });

    // num maxZoom
    test('to test the property `maxZoom`', () async {
      // TODO
    });

    // [west, south, east, north] of the pack
    // BuiltList<num> bounds
    test('to test the property `bounds`', () async {
      // TODO
    });

    // String attribution
    test('to test the property `attribution`', () async {
      // TODO
    });

    // When the pack was built
    // String builtAt
    test('to test the property `builtAt`', () async {
      // TODO
    });

  });
}
