# fieldops_api.model.AppInfoDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**minVersionCode** | **num** | Android versionCode below which the app must update before use | 
**latestVersionCode** | **num** | Newest versionCode; above the minimum the update is optional | 
**updateUrl** | **String** |  | [optional] 
**faceProvider** | **String** | Which face capture flow to prepare | 
**pingIntervalSeconds** | **num** | Seconds between location pings while on duty | 
**silentGapMinutes** | **num** | No ping for this long during a shift raises a silent-gap alert | 
**serverTime** | [**DateTime**](DateTime.md) | Server time (UTC): the app shows a wrong phone clock | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


