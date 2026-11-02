# fieldops_api.model.CreateLeaveDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**clientUuid** | **String** | Idempotency key from the phone; a retry returns the same request | [optional] 
**leaveType** | **String** |  | 
**fromDate** | **String** | IST date; today or later (SICK: up to 7 days back) | 
**toDate** | **String** | Inclusive; at most 31 days in one request | 
**reason** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


