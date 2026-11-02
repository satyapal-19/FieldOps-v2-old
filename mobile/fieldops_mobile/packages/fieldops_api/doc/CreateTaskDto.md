# fieldops_api.model.CreateTaskDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**title** | **String** |  | 
**titleMr** | **String** |  | [optional] 
**description** | **String** |  | [optional] 
**priority** | **String** |  | [optional] [default to 'NORMAL']
**assignedToId** | **String** | Someone below you in your scope | 
**dueAt** | [**DateTime**](DateTime.md) |  | [optional] 
**locationLat** | **num** |  | [optional] 
**locationLng** | **num** |  | [optional] 
**locationLabel** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


