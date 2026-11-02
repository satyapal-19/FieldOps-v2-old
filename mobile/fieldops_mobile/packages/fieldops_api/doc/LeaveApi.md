# fieldops_api.api.LeaveApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**leaveControllerCancelLeave**](LeaveApi.md#leavecontrollercancelleave) | **POST** /api/v1/leave/{id}/cancel | Withdraw your leave request (pending, or approved and not started)
[**leaveControllerCancelRegularization**](LeaveApi.md#leavecontrollercancelregularization) | **POST** /api/v1/regularizations/{id}/cancel | Withdraw your pending regularization request
[**leaveControllerGetLeave**](LeaveApi.md#leavecontrollergetleave) | **GET** /api/v1/leave/{id} | One leave request
[**leaveControllerGetRegularization**](LeaveApi.md#leavecontrollergetregularization) | **GET** /api/v1/regularizations/{id} | One regularization request
[**leaveControllerListLeave**](LeaveApi.md#leavecontrollerlistleave) | **GET** /api/v1/leave | Leave requests: your own, plus those you review
[**leaveControllerListRegularizations**](LeaveApi.md#leavecontrollerlistregularizations) | **GET** /api/v1/regularizations | Attendance regularization requests: your own, plus those you review
[**leaveControllerRequestLeave**](LeaveApi.md#leavecontrollerrequestleave) | **POST** /api/v1/leave | Ask for leave (for yourself; retry-safe with clientUuid)
[**leaveControllerRequestRegularization**](LeaveApi.md#leavecontrollerrequestregularization) | **POST** /api/v1/regularizations | Ask to correct one of the last 7 days (for yourself; retry-safe with clientUuid)
[**leaveControllerReviewLeave**](LeaveApi.md#leavecontrollerreviewleave) | **POST** /api/v1/leave/{id}/review | Approve or reject a pending leave request (line manager; never your own)
[**leaveControllerReviewRegularization**](LeaveApi.md#leavecontrollerreviewregularization) | **POST** /api/v1/regularizations/{id}/review | Approve or reject a pending regularization (line manager; never your own)


# **leaveControllerCancelLeave**
> LeaveRequestDto leaveControllerCancelLeave(id, cancelRequestDto)

Withdraw your leave request (pending, or approved and not started)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getLeaveApi();
final String id = id_example; // String | 
final CancelRequestDto cancelRequestDto = ; // CancelRequestDto | 

try {
    final response = api.leaveControllerCancelLeave(id, cancelRequestDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LeaveApi->leaveControllerCancelLeave: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **cancelRequestDto** | [**CancelRequestDto**](CancelRequestDto.md)|  | 

### Return type

[**LeaveRequestDto**](LeaveRequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveControllerCancelRegularization**
> RegularizationRequestDto leaveControllerCancelRegularization(id, cancelRequestDto)

Withdraw your pending regularization request

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getLeaveApi();
final String id = id_example; // String | 
final CancelRequestDto cancelRequestDto = ; // CancelRequestDto | 

try {
    final response = api.leaveControllerCancelRegularization(id, cancelRequestDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LeaveApi->leaveControllerCancelRegularization: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **cancelRequestDto** | [**CancelRequestDto**](CancelRequestDto.md)|  | 

### Return type

[**RegularizationRequestDto**](RegularizationRequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveControllerGetLeave**
> LeaveRequestDto leaveControllerGetLeave(id)

One leave request

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getLeaveApi();
final String id = id_example; // String | 

try {
    final response = api.leaveControllerGetLeave(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LeaveApi->leaveControllerGetLeave: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**LeaveRequestDto**](LeaveRequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveControllerGetRegularization**
> RegularizationRequestDto leaveControllerGetRegularization(id)

One regularization request

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getLeaveApi();
final String id = id_example; // String | 

try {
    final response = api.leaveControllerGetRegularization(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LeaveApi->leaveControllerGetRegularization: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RegularizationRequestDto**](RegularizationRequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveControllerListLeave**
> LeavePageDto leaveControllerListLeave(status, staffId, from, to, page, pageSize)

Leave requests: your own, plus those you review

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getLeaveApi();
final String status = status_example; // String | 
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | One requester (must be in your scope)
final String from = 2026-11-01; // String | 
final String to = 2026-11-30; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.leaveControllerListLeave(status, staffId, from, to, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LeaveApi->leaveControllerListLeave: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **staffId** | **String**| One requester (must be in your scope) | [optional] 
 **from** | **String**|  | [optional] 
 **to** | **String**|  | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 50]

### Return type

[**LeavePageDto**](LeavePageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveControllerListRegularizations**
> RegularizationPageDto leaveControllerListRegularizations(status, staffId, from, to, page, pageSize)

Attendance regularization requests: your own, plus those you review

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getLeaveApi();
final String status = status_example; // String | 
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | One requester (must be in your scope)
final String from = 2026-11-01; // String | 
final String to = 2026-11-30; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.leaveControllerListRegularizations(status, staffId, from, to, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LeaveApi->leaveControllerListRegularizations: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **staffId** | **String**| One requester (must be in your scope) | [optional] 
 **from** | **String**|  | [optional] 
 **to** | **String**|  | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 50]

### Return type

[**RegularizationPageDto**](RegularizationPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveControllerRequestLeave**
> LeaveRequestDto leaveControllerRequestLeave(createLeaveDto)

Ask for leave (for yourself; retry-safe with clientUuid)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getLeaveApi();
final CreateLeaveDto createLeaveDto = ; // CreateLeaveDto | 

try {
    final response = api.leaveControllerRequestLeave(createLeaveDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LeaveApi->leaveControllerRequestLeave: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createLeaveDto** | [**CreateLeaveDto**](CreateLeaveDto.md)|  | 

### Return type

[**LeaveRequestDto**](LeaveRequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveControllerRequestRegularization**
> RegularizationRequestDto leaveControllerRequestRegularization(createRegularizationDto)

Ask to correct one of the last 7 days (for yourself; retry-safe with clientUuid)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getLeaveApi();
final CreateRegularizationDto createRegularizationDto = ; // CreateRegularizationDto | 

try {
    final response = api.leaveControllerRequestRegularization(createRegularizationDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LeaveApi->leaveControllerRequestRegularization: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createRegularizationDto** | [**CreateRegularizationDto**](CreateRegularizationDto.md)|  | 

### Return type

[**RegularizationRequestDto**](RegularizationRequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveControllerReviewLeave**
> LeaveRequestDto leaveControllerReviewLeave(id, reviewRequestDto)

Approve or reject a pending leave request (line manager; never your own)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getLeaveApi();
final String id = id_example; // String | 
final ReviewRequestDto reviewRequestDto = ; // ReviewRequestDto | 

try {
    final response = api.leaveControllerReviewLeave(id, reviewRequestDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LeaveApi->leaveControllerReviewLeave: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **reviewRequestDto** | [**ReviewRequestDto**](ReviewRequestDto.md)|  | 

### Return type

[**LeaveRequestDto**](LeaveRequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveControllerReviewRegularization**
> RegularizationRequestDto leaveControllerReviewRegularization(id, reviewRequestDto)

Approve or reject a pending regularization (line manager; never your own)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getLeaveApi();
final String id = id_example; // String | 
final ReviewRequestDto reviewRequestDto = ; // ReviewRequestDto | 

try {
    final response = api.leaveControllerReviewRegularization(id, reviewRequestDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling LeaveApi->leaveControllerReviewRegularization: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **reviewRequestDto** | [**ReviewRequestDto**](ReviewRequestDto.md)|  | 

### Return type

[**RegularizationRequestDto**](RegularizationRequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

