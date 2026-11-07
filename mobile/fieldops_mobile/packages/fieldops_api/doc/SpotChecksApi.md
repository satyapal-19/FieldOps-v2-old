# fieldops_api.api.SpotChecksApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**spotChecksControllerList**](SpotChecksApi.md#spotcheckscontrollerlist) | **GET** /api/v1/spot-checks | Spot checks in your scope (admin all, ward inspector ward, inspector team)
[**spotChecksControllerMine**](SpotChecksApi.md#spotcheckscontrollermine) | **GET** /api/v1/spot-checks/mine | My spot checks waiting for an answer (poll while on duty)
[**spotChecksControllerOrder**](SpotChecksApi.md#spotcheckscontrollerorder) | **POST** /api/v1/spot-checks | Order a spot check now for someone on duty in your scope
[**spotChecksControllerRespond**](SpotChecksApi.md#spotcheckscontrollerrespond) | **POST** /api/v1/spot-checks/{id}/respond | Answer: a fresh challenge, the face and where you are (same proof as a punch)
[**spotChecksControllerSnooze**](SpotChecksApi.md#spotcheckscontrollersnooze) | **POST** /api/v1/spot-checks/{id}/snooze | Ask for 10 more minutes, once


# **spotChecksControllerList**
> SpotCheckPageDto spotChecksControllerList(date, status, page, pageSize)

Spot checks in your scope (admin all, ward inspector ward, inspector team)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getSpotChecksApi();
final String date = 2026-11-02; // String | 
final String status = status_example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.spotChecksControllerList(date, status, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SpotChecksApi->spotChecksControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 50]

### Return type

[**SpotCheckPageDto**](SpotCheckPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **spotChecksControllerMine**
> BuiltList<SpotCheckDto> spotChecksControllerMine()

My spot checks waiting for an answer (poll while on duty)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getSpotChecksApi();

try {
    final response = api.spotChecksControllerMine();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SpotChecksApi->spotChecksControllerMine: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;SpotCheckDto&gt;**](SpotCheckDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **spotChecksControllerOrder**
> SpotCheckDto spotChecksControllerOrder(orderSpotCheckDto)

Order a spot check now for someone on duty in your scope

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getSpotChecksApi();
final OrderSpotCheckDto orderSpotCheckDto = ; // OrderSpotCheckDto | 

try {
    final response = api.spotChecksControllerOrder(orderSpotCheckDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SpotChecksApi->spotChecksControllerOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderSpotCheckDto** | [**OrderSpotCheckDto**](OrderSpotCheckDto.md)|  | 

### Return type

[**SpotCheckDto**](SpotCheckDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **spotChecksControllerRespond**
> SpotCheckDto spotChecksControllerRespond(id, respondSpotCheckDto)

Answer: a fresh challenge, the face and where you are (same proof as a punch)

A face mismatch can be retried until the deadline; outside the ward is recorded and escalated.

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getSpotChecksApi();
final String id = id_example; // String | 
final RespondSpotCheckDto respondSpotCheckDto = ; // RespondSpotCheckDto | 

try {
    final response = api.spotChecksControllerRespond(id, respondSpotCheckDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SpotChecksApi->spotChecksControllerRespond: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **respondSpotCheckDto** | [**RespondSpotCheckDto**](RespondSpotCheckDto.md)|  | 

### Return type

[**SpotCheckDto**](SpotCheckDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **spotChecksControllerSnooze**
> SpotCheckDto spotChecksControllerSnooze(id)

Ask for 10 more minutes, once

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getSpotChecksApi();
final String id = id_example; // String | 

try {
    final response = api.spotChecksControllerSnooze(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SpotChecksApi->spotChecksControllerSnooze: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**SpotCheckDto**](SpotCheckDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

