import 'dart:math';
import 'dart:io';
import 'dart:ui' show Rect;
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// On-device face liveness & similarity service using ML Kit Face Detection.
/// Compares enrolled profile photo vs. captured selfie using facial landmarks.
class FaceMatchService {
  static final FaceMatchService _instance = FaceMatchService._internal();
  factory FaceMatchService() => _instance;
  FaceMatchService._internal();

  FaceDetector? _detector;

  FaceDetector get _faceDetector {
    _detector ??= FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableLandmarks: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
    return _detector!;
  }

  /// Check a selfie file for liveness signals (eyes open, head pose).
  /// Returns a score 0.0–1.0 — score >= 0.40 is considered live.
  Future<FaceMatchResult> checkLiveness(File selfieFile) async {
    try {
      if (!selfieFile.existsSync()) {
        return const FaceMatchResult(
          score: 0.0,
          passed: false,
          reason: 'Selfie file does not exist',
        );
      }

      final input = InputImage.fromFilePath(selfieFile.path);
      final faces = await _faceDetector.processImage(input);

      if (faces.isEmpty) {
        return const FaceMatchResult(
          score: 0.0,
          passed: false,
          reason: 'No face detected in selfie. Please ensure good lighting.',
        );
      }

      final face = faces.first;

      // Liveness signals
      double score = 0.0;

      // 1. Left eye open probability
      final leftEyeOpen = face.leftEyeOpenProbability ?? 0.5;
      score += leftEyeOpen * 0.3;

      // 2. Right eye open probability
      final rightEyeOpen = face.rightEyeOpenProbability ?? 0.5;
      score += rightEyeOpen * 0.3;

      // 3. Smiling probability (natural expression = live)
      final smiling = face.smilingProbability ?? 0.3;
      score += smiling.clamp(0.0, 0.3) * 0.2;

      // 4. Head pose — frontal face scores higher
      final yaw = (face.headEulerAngleY ?? 0.0).abs();
      final pitch = (face.headEulerAngleX ?? 0.0).abs();
      final poseScore = (1.0 - (yaw + pitch) / 60.0).clamp(0.0, 1.0);
      score += poseScore * 0.2;

      score = score.clamp(0.0, 1.0);
      final passed = score >= 0.40; // lenient threshold for real-world use

      return FaceMatchResult(
        score: score,
        passed: passed,
        reason: passed
            ? 'Face liveness confirmed (score: ${(score * 100).toInt()}%)'
            : 'Liveness check failed (score: ${(score * 100).toInt()}%). '
              'Ensure good lighting and face the camera directly.',
      );
    } catch (e) {
      debugPrint('FaceMatchService liveness error: $e');
      // Fail open — allow check-in if ML Kit fails (e.g., device incompatibility)
      return FaceMatchResult(
        score: 0.5,
        passed: true,
        reason: 'Liveness check skipped (device compatibility): $e',
      );
    }
  }

  /// Compare two LOCAL file paths (enrolled photo vs captured selfie).
  /// NOTE: enrolledPhotoPath must be a local file path, NOT a URL.
  /// If enrolledPhotoPath is a URL, we skip comparison and return passed=true.
  Future<FaceMatchResult> compareFaces({
    required String enrolledPhotoPath,
    required String capturedPhotoPath,
  }) async {
    // If enrolled photo is a URL (not on-device), skip comparison
    if (enrolledPhotoPath.startsWith('http://') ||
        enrolledPhotoPath.startsWith('https://')) {
      debugPrint('FaceMatchService: enrolled photo is a URL — skipping comparison, using liveness only');
      return checkLiveness(File(capturedPhotoPath));
    }

    try {
      final enrolledFile = File(enrolledPhotoPath);
      final capturedFile = File(capturedPhotoPath);

      if (!enrolledFile.existsSync()) {
        return checkLiveness(capturedFile);
      }
      if (!capturedFile.existsSync()) {
        return const FaceMatchResult(
          score: 0.0,
          passed: false,
          reason: 'Captured selfie file not found',
        );
      }

      final enrolledInput = InputImage.fromFilePath(enrolledPhotoPath);
      final capturedInput = InputImage.fromFilePath(capturedPhotoPath);

      final enrolledFaces = await _faceDetector.processImage(enrolledInput);
      final capturedFaces = await _faceDetector.processImage(capturedInput);

      if (enrolledFaces.isEmpty) {
        // No face in enrolled photo — just do liveness check
        return checkLiveness(capturedFile);
      }
      if (capturedFaces.isEmpty) {
        return const FaceMatchResult(
          score: 0.0,
          passed: false,
          reason: 'No face detected in selfie. Ensure good lighting.',
        );
      }

      final score = _computeSimilarity(
        enrolledFaces.first,
        capturedFaces.first,
      );

      return FaceMatchResult(
        score: score,
        passed: score >= 0.65,
        reason: score >= 0.65
            ? 'Face verified (${(score * 100).toInt()}%)'
            : 'Face mismatch (${(score * 100).toInt()}%). Please retry.',
      );
    } catch (e) {
      debugPrint('FaceMatchService compare error: $e');
      return FaceMatchResult(
        score: 0.5,
        passed: true,
        reason: 'Face comparison skipped: $e',
      );
    }
  }

  double _computeSimilarity(Face enrolled, Face captured) {
    final enrolledPoints = _extractKeyPoints(enrolled);
    final capturedPoints = _extractKeyPoints(captured);

    if (enrolledPoints.isEmpty || capturedPoints.isEmpty) return 0.0;
    if (enrolledPoints.length != capturedPoints.length) return 0.0;

    final enrolledNorm = _normalizePoints(enrolledPoints, enrolled.boundingBox);
    final capturedNorm = _normalizePoints(capturedPoints, captured.boundingBox);

    double totalDist = 0.0;
    for (int i = 0; i < enrolledNorm.length; i++) {
      final dx = enrolledNorm[i][0] - capturedNorm[i][0];
      final dy = enrolledNorm[i][1] - capturedNorm[i][1];
      totalDist += sqrt(dx * dx + dy * dy);
    }
    final avgDist = totalDist / enrolledNorm.length;
    return (1.0 - (avgDist / 0.35)).clamp(0.0, 1.0);
  }

  List<List<double>> _extractKeyPoints(Face face) {
    final points = <List<double>>[];
    final contourTypes = [
      FaceContourType.face,
      FaceContourType.leftEye,
      FaceContourType.rightEye,
      FaceContourType.noseBottom,
      FaceContourType.upperLipTop,
      FaceContourType.lowerLipBottom,
    ];
    for (final type in contourTypes) {
      final contour = face.contours[type];
      if (contour != null && contour.points.isNotEmpty) {
        double sumX = 0, sumY = 0;
        for (final p in contour.points) {
          sumX += p.x;
          sumY += p.y;
        }
        points.add([sumX / contour.points.length, sumY / contour.points.length]);
      }
    }
    return points;
  }

  List<List<double>> _normalizePoints(
    List<List<double>> points,
    Rect boundingBox,
  ) {
    if (boundingBox.width == 0 || boundingBox.height == 0) return points;
    return points
        .map((p) => [
              (p[0] - boundingBox.left) / boundingBox.width,
              (p[1] - boundingBox.top) / boundingBox.height,
            ])
        .toList();
  }

  void dispose() {
    _detector?.close();
    _detector = null;
  }
}

class FaceMatchResult {
  final double score;
  final bool passed;
  final String reason;
  const FaceMatchResult({
    required this.score,
    required this.passed,
    required this.reason,
  });
}
