# fieldops_api.model.CreatePunchDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**clientUuid** | **String** | Idempotency key from the phone outbox; a retry returns the same result | 
**type** | **String** |  | 
**staffId** | **String** | Omit for yourself; set for a proxy punch | [optional] 
**challengeId** | **String** | From POST /attendance/challenges | 
**latitude** | **num** |  | 
**longitude** | **num** |  | 
**accuracyM** | **num** | GPS accuracy in metres (field ≤ 25, office ≤ 100) | 
**presenceCode** | **String** | Proxy punch: the worker's rolling code scanned from their phone (co-presence) | [optional] 
**isMocked** | **bool** | The phone reported a mock location (recorded, flagged) | [optional] 
**faceImageBase64** | **String** | Local face provider: base64 JPEG face crop (≤ 96000 chars); never stored | [optional] 
**aadhaarPidXml** | **String** | Aadhaar face provider: PidData XML from FaceRD | [optional] 
**aadhaarTxn** | **String** | Aadhaar face provider: the txn from capture-options | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


