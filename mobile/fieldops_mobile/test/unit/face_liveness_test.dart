import 'dart:typed_data';

import 'package:fieldops_mobile/core/services/face_liveness.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

FaceSample face({double eyes = 0.9, double smile = 0.1, double yaw = 0}) =>
    FaceSample(faceCount: 1, leftEyeOpen: eyes, rightEyeOpen: eyes, smiling: smile, yaw: yaw);

void main() {
  group('LivenessTracker', () {
    test('a blink needs open eyes first, then closed', () {
      final t = LivenessTracker([LivenessAction.blink]);
      t.add(face(eyes: 0.1));
      expect(t.isDone, isFalse, reason: 'closed eyes from the start are not a blink');
      t.add(face(eyes: 0.9));
      t.add(face(eyes: 0.1));
      expect(t.isDone, isTrue);
    });

    test('actions are done in the order the server asked', () {
      final t = LivenessTracker([LivenessAction.smile, LivenessAction.turnLeft]);
      t.add(face(yaw: 30));
      expect(t.completed, 0);
      t.add(face(smile: 0.95));
      expect(t.current, LivenessAction.turnLeft);
      t.add(face(yaw: 25));
      expect(t.isDone, isTrue);
    });

    test('turn right is a negative yaw', () {
      final t = LivenessTracker([LivenessAction.turnRight]);
      t.add(face(yaw: 25));
      expect(t.isDone, isFalse);
      t.add(face(yaw: -25));
      expect(t.isDone, isTrue);
    });

    test('a second face or no face starts over', () {
      final t = LivenessTracker([LivenessAction.smile, LivenessAction.turnLeft]);
      t.add(face(smile: 0.95));
      expect(t.completed, 1);
      t.add(const FaceSample(faceCount: 2));
      expect(t.completed, 0);
    });

    test('the photo is taken only once the face is frontal again', () {
      final t = LivenessTracker([LivenessAction.turnLeft]);
      t.add(face(yaw: 30));
      expect(t.readyForCapture(face(yaw: 30)), isFalse);
      expect(t.readyForCapture(face(yaw: 5)), isTrue);
    });

    test('unknown wire actions are ignored', () {
      expect(livenessActionFromWire('BLINK'), LivenessAction.blink);
      expect(livenessActionFromWire('NOD'), isNull);
    });
  });

  group('FaceCrop', () {
    Uint8List photo(int w, int h) {
      final image = img.Image(width: w, height: h);
      // Noise makes the JPEG realistically large.
      for (var y = 0; y < h; y++) {
        for (var x = 0; x < w; x++) {
          image.setPixelRgb(x, y, (x * 7 + y * 13) % 256, (x * y) % 256, (x ^ y) % 256);
        }
      }
      return Uint8List.fromList(img.encodeJpg(image, quality: 95));
    }

    test('crops with a margin, scales to 320 px and stays under 70 kB', () {
      final jpeg = FaceCrop.fromJpeg(photo(1200, 1600), const FaceBox(300, 400, 600, 700))!;
      expect(jpeg.length, lessThanOrEqualTo(FaceCrop.maxBytes));
      final out = img.decodeJpg(jpeg)!;
      expect(out.height, 320);
      expect(out.width, lessThan(320));
    });

    test('a box at the edge is clamped to the photo', () {
      final jpeg = FaceCrop.fromJpeg(photo(400, 400), const FaceBox(300, 300, 200, 200));
      expect(jpeg, isNotNull);
    });

    test('a box outside the photo gives nothing', () {
      expect(FaceCrop.fromJpeg(photo(100, 100), const FaceBox(500, 500, 50, 50)), isNull);
    });
  });
}
