# fieldops_api.model.RespondSpotCheckDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**clientUuid** | **String** | Retry-safe: the same one answers once | 
**challengeId** | **String** | From POST /attendance/challenges | 
**latitude** | **num** |  | 
**longitude** | **num** |  | 
**accuracyM** | **num** | GPS accuracy, metres | 
**faceImageBase64** | **String** | JPEG face crop (FACE_PROVIDER=local) | [optional] 
**aadhaarPidXml** | **String** | Aadhaar FaceRD PID block (FACE_PROVIDER=aadhaar) | [optional] 
**aadhaarTxn** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


