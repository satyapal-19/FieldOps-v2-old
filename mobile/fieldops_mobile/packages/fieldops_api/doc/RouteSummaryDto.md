# fieldops_api.model.RouteSummaryDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**source_** | **String** | LIVE = computed now from the raw points; NIGHTLY = the stored roll-up | 
**pingCount** | **num** |  | 
**distanceM** | **num** | Trusted distance (no mocked or > 50 m fixes), metres | 
**firstPingAt** | [**DateTime**](DateTime.md) |  | 
**lastPingAt** | [**DateTime**](DateTime.md) |  | 
**inWardPings** | **num** |  | 
**outWardPings** | **num** |  | 
**stationaryPings** | **num** |  | 
**mockedPings** | **num** |  | 
**offlinePings** | **num** |  | 
**maxGapMinutes** | **num** |  | 
**tamperEvents** | **num** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


