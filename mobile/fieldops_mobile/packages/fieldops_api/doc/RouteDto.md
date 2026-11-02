# fieldops_api.model.RouteDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**staffId** | **String** |  | 
**date** | **String** |  | 
**shift** | [**RouteShiftDto**](RouteShiftDto.md) |  | 
**summary** | [**RouteSummaryDto**](RouteSummaryDto.md) |  | 
**points** | [**BuiltList&lt;RoutePointDto&gt;**](RoutePointDto.md) | Oldest first; empty once purged | 
**pointsPurged** | **bool** | True when the raw points are past the retention period | 
**tamperEvents** | [**BuiltList&lt;RouteTamperEventDto&gt;**](RouteTamperEventDto.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


