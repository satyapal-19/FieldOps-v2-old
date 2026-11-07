# fieldops_api.model.SendMessageDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**clientUuid** | **String** | Made on the phone: a retry sends once | 
**type** | **String** |  | 
**text** | **String** | TEXT | [optional] 
**uploadId** | **String** | VOICE / IMAGE: your upload (POST /uploads) | [optional] 
**durationSec** | **num** | VOICE: length in seconds | [optional] 
**latitude** | **num** |  | [optional] 
**longitude** | **num** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


