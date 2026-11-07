# fieldops_api.model.ConversationDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**type** | **String** |  | 
**title** | **String** |  | 
**wardId** | **String** |  | 
**inspectorId** | **String** |  | 
**date** | **String** |  | 
**archived** | **bool** | Read-only (a past squad chat) | 
**canPost** | **bool** | Whether you may post here (broadcasts are one-way) | 
**memberIds** | **BuiltList&lt;String&gt;** | Active members (staff ids) | 
**lastMessageAt** | [**DateTime**](DateTime.md) |  | 
**unread** | **num** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


