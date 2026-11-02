# fieldops_api.model.CreateStaffDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**employeeCode** | **String** | 2-20 letters, digits or hyphens; stored upper-case | 
**fullName** | **String** |  | 
**fullNameMr** | **String** |  | [optional] 
**phone** | **String** | Indian mobile; +91 / 0 prefixes accepted | 
**role** | **String** |  | 
**homeWardId** | **String** | Required for WARD_INSPECTOR, INSPECTOR, WORKER | [optional] 
**officeId** | **String** | Required for OFFICE_STAFF | [optional] 
**reportsToId** | **String** | Line manager: exactly the next rank up | [optional] 
**department** | **String** |  | [optional] 
**shiftStart** | **String** | IST, 24-hour HH:MM | [optional] [default to '06:00']
**shiftEnd** | **String** |  | [optional] [default to '14:00']
**initialPassword** | **String** | Only for ADMIN, WARD_INSPECTOR and OFFICE_STAFF (web sign-in). 10-72 characters. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


