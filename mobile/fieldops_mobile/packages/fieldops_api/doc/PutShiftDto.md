# fieldops_api.model.PutShiftDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**staffId** | **String** |  | 
**date** | **String** | IST date, today up to 31 days ahead | 
**shiftType** | **String** |  | 
**startTime** | **String** | IST, 24-hour HH:MM | 
**endTime** | **String** | Before startTime only for NIGHT (ends next day) | 
**expectedVersion** | **num** | Required when changing an existing override | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


