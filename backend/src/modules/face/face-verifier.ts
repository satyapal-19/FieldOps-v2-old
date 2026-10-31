/**
 * One interface for "is this the right live person?", with interchangeable providers:
 *  - 'local'   : our pipeline (YuNet + MiniFASNet + AuraFace) on SMKC's server
 *  - 'aadhaar' : UIDAI Aadhaar face authentication (FaceRD on the phone, Auth API via an ASA)
 * The attendance engine depends only on this interface; FACE_PROVIDER picks the provider.
 */

export type FaceProviderName = 'local' | 'aadhaar';

/** A liveness-checked face crop from the app (local provider). */
export interface FaceImageInput {
  kind: 'image';
  staffId: string;
  image: Buffer;
  challengeId: string;
}

/** The encrypted PidData XML returned by the Aadhaar FaceRD app (aadhaar provider). */
export interface AadhaarPidInput {
  kind: 'aadhaar-pid';
  staffId: string;
  pidDataXml: string;
  txn: string;
}

export type FaceVerificationInput = FaceImageInput | AadhaarPidInput;

export interface FaceVerificationResult {
  provider: FaceProviderName;
  matched: boolean;
  /** Similarity score (local provider only). */
  score?: number;
  threshold?: number;
  /** Why it did not match, as a stable code (e.g. SPOOF_SUSPECTED, UIDAI_300). */
  reasonCode?: string;
  /** Provider reference to keep in the audit trail (e.g. UIDAI response code). */
  reference?: string;
  /** Raw signed provider response to store in the audit trail (UIDAI requires keeping it). */
  auditPayload?: string;
}

/** What the app must do to capture a face for this provider. */
export type FaceCaptureOptions =
  | { provider: 'local'; instructions: 'ML_KIT_LIVENESS_THEN_UPLOAD_CROP' }
  | { provider: 'aadhaar'; instructions: 'LAUNCH_FACERD'; txn: string; pidOptionsXml: string; intentAction: string };

export abstract class FaceVerifier {
  abstract readonly provider: FaceProviderName;

  /** Tells the app how to capture (sent before the camera opens). */
  abstract captureOptions(staffId: string): Promise<FaceCaptureOptions>;

  /** Verifies a capture. Business rules (late marks, geofence) stay in the attendance engine. */
  abstract verify(input: FaceVerificationInput): Promise<FaceVerificationResult>;
}
