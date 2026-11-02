# fieldops_api.model.AssigneeUpdateDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**clientUuid** | **String** | Idempotency key from the phone; a retry changes nothing | 
**action** | **String** |  | 
**note** | **String** | Required to SUBMIT unless a photo is attached | [optional] 
**photoKey** | **String** | Storage key from the upload endpoint (after-photo on SUBMIT) | [optional] 
**lat** | **num** |  | [optional] 
**lng** | **num** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


