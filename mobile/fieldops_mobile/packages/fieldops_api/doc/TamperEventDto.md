# fieldops_api.model.TamperEventDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**clientUuid** | **String** | Idempotency key; resend with resolvedAt once over | 
**eventType** | **String** |  | 
**startedAt** | [**DateTime**](DateTime.md) |  | 
**resolvedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**lastLatitude** | **num** |  | [optional] 
**lastLongitude** | **num** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


