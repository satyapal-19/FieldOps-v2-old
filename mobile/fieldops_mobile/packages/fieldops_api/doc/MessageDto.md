# fieldops_api.model.MessageDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**conversationId** | **String** |  | 
**senderId** | **String** |  | 
**type** | **String** |  | 
**text** | **String** |  | 
**hasMedia** | **bool** | Voice note or photo attached (GET /chat/messages/{id}/media) | 
**durationSec** | **num** |  | 
**latitude** | **num** |  | 
**longitude** | **num** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


