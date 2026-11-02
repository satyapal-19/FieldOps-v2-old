# fieldops_api.model.AttendanceLogDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**staffId** | **String** |  | 
**date** | **String** | IST date of the shift | 
**status** | **String** |  | 
**wardId** | **String** |  | 
**officeId** | **String** |  | 
**assignmentId** | **String** |  | 
**isLate** | **bool** |  | 
**lateMinutes** | **num** |  | 
**workedMinutes** | **num** |  | 
**checkin** | [**PunchDetailsDto**](PunchDetailsDto.md) |  | 
**checkinDistanceM** | **num** | Metres outside the geofence | 
**checkinFaceScore** | **num** |  | 
**checkout** | [**PunchDetailsDto**](PunchDetailsDto.md) |  | 
**checkoutType** | **String** |  | 
**isSuspicious** | **bool** | Mock location or other warning signs | 
**version** | **num** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


