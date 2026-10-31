import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:fieldops_mobile/core/services/face_match_service.dart';

void main() {
  group('FaceMatchService Tests', () {
    final faceMatchService = FaceMatchService();

    test('checkLiveness returns failure when file does not exist', () async {
      final nonExistent = File('non_existent_selfie.jpg');
      final result = await faceMatchService.checkLiveness(nonExistent);

      expect(result.passed, isFalse);
      expect(result.score, 0.0);
      expect(result.reason, contains('does not exist'));
    });

    test('compareFaces detects URL as remote profile photo and falls back to liveness', () async {
      final fakePhoto = File('non_existent_selfie.jpg');
      final result = await faceMatchService.compareFaces(
        enrolledPhotoPath: 'https://jcbpkkqrfqogkxrcxhfm.supabase.co/storage/v1/object/public/profile.jpg',
        capturedPhotoPath: fakePhoto.path,
      );

      // Since capturedPhotoPath doesn't exist on disk, liveness returns false cleanly without crash
      expect(result.passed, isFalse);
      expect(result.score, 0.0);
    });

    test('FaceMatchResult properties hold accurate metrics', () {
      const matchPass = FaceMatchResult(
        score: 0.85,
        passed: true,
        reason: 'Face verified (85%)',
      );
      expect(matchPass.passed, isTrue);
      expect(matchPass.score, 0.85);
      expect(matchPass.reason, 'Face verified (85%)');

      const matchFail = FaceMatchResult(
        score: 0.35,
        passed: false,
        reason: 'Face mismatch (35%)',
      );
      expect(matchFail.passed, isFalse);
      expect(matchFail.score, 0.35);
    });
  });
}
