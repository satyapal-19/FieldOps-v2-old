# fieldops_api.model.PingDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**clientUuid** | **String** | Idempotency key from the phone outbox | 
**latitude** | **num** |  | 
**longitude** | **num** |  | 
**accuracyM** | **num** |  | [optional] 
**batteryPct** | **num** |  | [optional] 
**isMocked** | **bool** |  | [optional] 
**fromOffline** | **bool** | Sent from the offline buffer | [optional] 
**recordedAt** | [**DateTime**](DateTime.md) | Phone time of the fix (UTC) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


