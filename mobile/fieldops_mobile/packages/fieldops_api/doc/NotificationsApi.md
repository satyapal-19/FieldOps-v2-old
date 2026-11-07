# fieldops_api.api.NotificationsApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**notificationsControllerInbox**](NotificationsApi.md#notificationscontrollerinbox) | **GET** /api/v1/notifications | My inbox, newest first, with the unread count (the app polls this)
[**notificationsControllerMarkRead**](NotificationsApi.md#notificationscontrollermarkread) | **POST** /api/v1/notifications/read | Mark some or all of my messages read
[**notificationsControllerRegister**](NotificationsApi.md#notificationscontrollerregister) | **PUT** /api/v1/devices/push-token | Register this phone&#39;s FCM token for my pushes (after sign-in)
[**notificationsControllerRemove**](NotificationsApi.md#notificationscontrollerremove) | **DELETE** /api/v1/devices/push-token | Stop pushes to this phone (before sign-out)


# **notificationsControllerInbox**
> InboxDto notificationsControllerInbox(unreadOnly, before, limit)

My inbox, newest first, with the unread count (the app polls this)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getNotificationsApi();
final bool unreadOnly = true; // bool | 
final DateTime before = 2013-10-20T19:20:30+01:00; // DateTime | Older than this (paging back)
final int limit = 56; // int | 

try {
    final response = api.notificationsControllerInbox(unreadOnly, before, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotificationsApi->notificationsControllerInbox: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **unreadOnly** | **bool**|  | [optional] [default to false]
 **before** | **DateTime**| Older than this (paging back) | [optional] 
 **limit** | **int**|  | [optional] [default to 30]

### Return type

[**InboxDto**](InboxDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **notificationsControllerMarkRead**
> MarkedDto notificationsControllerMarkRead(markReadDto)

Mark some or all of my messages read

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getNotificationsApi();
final MarkReadDto markReadDto = ; // MarkReadDto | 

try {
    final response = api.notificationsControllerMarkRead(markReadDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling NotificationsApi->notificationsControllerMarkRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **markReadDto** | [**MarkReadDto**](MarkReadDto.md)|  | 

### Return type

[**MarkedDto**](MarkedDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **notificationsControllerRegister**
> notificationsControllerRegister(pushTokenDto)

Register this phone's FCM token for my pushes (after sign-in)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getNotificationsApi();
final PushTokenDto pushTokenDto = ; // PushTokenDto | 

try {
    api.notificationsControllerRegister(pushTokenDto);
} catch on DioException (e) {
    print('Exception when calling NotificationsApi->notificationsControllerRegister: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pushTokenDto** | [**PushTokenDto**](PushTokenDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **notificationsControllerRemove**
> notificationsControllerRemove(removePushTokenDto)

Stop pushes to this phone (before sign-out)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getNotificationsApi();
final RemovePushTokenDto removePushTokenDto = ; // RemovePushTokenDto | 

try {
    api.notificationsControllerRemove(removePushTokenDto);
} catch on DioException (e) {
    print('Exception when calling NotificationsApi->notificationsControllerRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **removePushTokenDto** | [**RemovePushTokenDto**](RemovePushTokenDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

