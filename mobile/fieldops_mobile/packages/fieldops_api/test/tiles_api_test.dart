import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for TilesApi
void main() {
  final instance = FieldopsApi().getTilesApi();

  group(TilesApi, () {
    // Whether an offline tile pack is installed, and its zooms and bounds
    //
    //Future<TileManifestDto> tilesControllerManifest() async
    test('test tilesControllerManifest', () async {
      // TODO
    });

    // One map tile from the offline pack (404 when not in the pack)
    //
    //Future<Uint8List> tilesControllerTile(num z, num x, num y) async
    test('test tilesControllerTile', () async {
      // TODO
    });

  });
}
