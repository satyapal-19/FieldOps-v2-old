# fieldops_api.model.ComplaintDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**trackingId** | **String** |  | 
**category** | **String** |  | 
**description** | **String** |  | 
**status** | **String** |  | 
**wardId** | **String** |  | 
**citizenName** | **String** |  | 
**citizenPhone** | **String** | Masked unless you may call back | 
**lat** | **num** |  | 
**lng** | **num** |  | 
**resolvedAt** | [**DateTime**](DateTime.md) |  | 
**version** | **num** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**tasks** | [**BuiltList&lt;TaskDto&gt;**](TaskDto.md) | Linked tasks (single-complaint view only) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


