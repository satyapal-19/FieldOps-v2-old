# fieldops_api.model.CreateAssignmentDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**date** | **String** | IST date, today up to 31 days ahead | 
**staffId** | **String** | The INSPECTOR or WORKER being placed | 
**wardId** | **String** | Required when placing an INSPECTOR | [optional] 
**inspectorId** | **String** | Required when placing a WORKER: an inspector already placed that day | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


