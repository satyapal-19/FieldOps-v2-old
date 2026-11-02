# fieldops_api.model.SelfAssignmentDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**clientUuid** | **String** | Idempotency key from the phone; a retry returns the same row | 
**date** | **String** | IST date: today or tomorrow | 
**wardId** | **String** | INSPECTOR self-pick: the ward | [optional] 
**inspectorId** | **String** | WORKER self-join: the inspector whose team to join | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


