# fieldops_api.api.ChatApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**chatControllerDirect**](ChatApi.md#chatcontrollerdirect) | **POST** /api/v1/chat/direct | Open (or reuse) a direct conversation along the hierarchy
[**chatControllerList**](ChatApi.md#chatcontrollerlist) | **GET** /api/v1/chat/conversations | My conversations (joins today&#39;s squad / ward channels), newest first
[**chatControllerMedia**](ChatApi.md#chatcontrollermedia) | **GET** /api/v1/chat/messages/{id}/media | A message&#39;s voice note or photo, for the conversation&#39;s members
[**chatControllerMessages**](ChatApi.md#chatcontrollermessages) | **GET** /api/v1/chat/conversations/{id}/messages | Messages, newest first (page back with before)
[**chatControllerRead**](ChatApi.md#chatcontrollerread) | **POST** /api/v1/chat/conversations/{id}/read | Mark the conversation read up to now
[**chatControllerSend**](ChatApi.md#chatcontrollersend) | **POST** /api/v1/chat/conversations/{id}/messages | Send a text, voice note, photo or location (retry-safe with clientUuid)


# **chatControllerDirect**
> ConversationDto chatControllerDirect(directDto)

Open (or reuse) a direct conversation along the hierarchy

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getChatApi();
final DirectDto directDto = ; // DirectDto | 

try {
    final response = api.chatControllerDirect(directDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChatApi->chatControllerDirect: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **directDto** | [**DirectDto**](DirectDto.md)|  | 

### Return type

[**ConversationDto**](ConversationDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **chatControllerList**
> BuiltList<ConversationDto> chatControllerList()

My conversations (joins today's squad / ward channels), newest first

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getChatApi();

try {
    final response = api.chatControllerList();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChatApi->chatControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ConversationDto&gt;**](ConversationDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **chatControllerMedia**
> Uint8List chatControllerMedia(id)

A message's voice note or photo, for the conversation's members

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getChatApi();
final String id = id_example; // String | 

try {
    final response = api.chatControllerMedia(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChatApi->chatControllerMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: audio/mp4, audio/ogg, audio/amr, image/jpeg, image/png, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **chatControllerMessages**
> BuiltList<MessageDto> chatControllerMessages(id, before, limit)

Messages, newest first (page back with before)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getChatApi();
final String id = id_example; // String | 
final DateTime before = 2013-10-20T19:20:30+01:00; // DateTime | Older than this (paging back)
final int limit = 56; // int | 

try {
    final response = api.chatControllerMessages(id, before, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChatApi->chatControllerMessages: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **before** | **DateTime**| Older than this (paging back) | [optional] 
 **limit** | **int**|  | [optional] [default to 50]

### Return type

[**BuiltList&lt;MessageDto&gt;**](MessageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **chatControllerRead**
> chatControllerRead(id)

Mark the conversation read up to now

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getChatApi();
final String id = id_example; // String | 

try {
    api.chatControllerRead(id);
} catch on DioException (e) {
    print('Exception when calling ChatApi->chatControllerRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **chatControllerSend**
> MessageDto chatControllerSend(id, sendMessageDto)

Send a text, voice note, photo or location (retry-safe with clientUuid)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getChatApi();
final String id = id_example; // String | 
final SendMessageDto sendMessageDto = ; // SendMessageDto | 

try {
    final response = api.chatControllerSend(id, sendMessageDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ChatApi->chatControllerSend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **sendMessageDto** | [**SendMessageDto**](SendMessageDto.md)|  | 

### Return type

[**MessageDto**](MessageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

