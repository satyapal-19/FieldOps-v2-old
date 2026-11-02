# fieldops_api.model.UpdateStaffDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**expectedVersion** | **num** | The version you last read; stale versions get 409 | 
**fullName** | **String** |  | [optional] 
**fullNameMr** | **String** |  | [optional] 
**phone** | **String** |  | [optional] 
**role** | **String** |  | [optional] 
**homeWardId** | **String** | null clears it | [optional] 
**officeId** | **String** |  | [optional] 
**reportsToId** | **String** |  | [optional] 
**department** | **String** |  | [optional] 
**shiftStart** | **String** |  | [optional] 
**shiftEnd** | **String** |  | [optional] 
**isActive** | **bool** | false deactivates and signs the person out everywhere | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


