# fieldops_api.api.WardsApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**wardsControllerCheckLocation**](WardsApi.md#wardscontrollerchecklocation) | **POST** /api/v1/wards/{id}/location-check | Is a point inside the ward or within the 25 m edge allowance?
[**wardsControllerCreate**](WardsApi.md#wardscontrollercreate) | **POST** /api/v1/wards | Create a ward (ADMIN)
[**wardsControllerGet**](WardsApi.md#wardscontrollerget) | **GET** /api/v1/wards/{id} | Get one ward with its boundary
[**wardsControllerList**](WardsApi.md#wardscontrollerlist) | **GET** /api/v1/wards | List wards (paged, by code)
[**wardsControllerUpdate**](WardsApi.md#wardscontrollerupdate) | **PATCH** /api/v1/wards/{id} | Update a ward (ADMIN, optimistic locking via expectedVersion)


# **wardsControllerCheckLocation**
> LocationCheckResultDto wardsControllerCheckLocation(id, locationCheckDto)

Is a point inside the ward or within the 25 m edge allowance?

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getWardsApi();
final String id = id_example; // String | 
final LocationCheckDto locationCheckDto = ; // LocationCheckDto | 

try {
    final response = api.wardsControllerCheckLocation(id, locationCheckDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WardsApi->wardsControllerCheckLocation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **locationCheckDto** | [**LocationCheckDto**](LocationCheckDto.md)|  | 

### Return type

[**LocationCheckResultDto**](LocationCheckResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **wardsControllerCreate**
> WardDto wardsControllerCreate(createWardDto)

Create a ward (ADMIN)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getWardsApi();
final CreateWardDto createWardDto = ; // CreateWardDto | 

try {
    final response = api.wardsControllerCreate(createWardDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WardsApi->wardsControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createWardDto** | [**CreateWardDto**](CreateWardDto.md)|  | 

### Return type

[**WardDto**](WardDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **wardsControllerGet**
> WardDto wardsControllerGet(id)

Get one ward with its boundary

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getWardsApi();
final String id = id_example; // String | 

try {
    final response = api.wardsControllerGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WardsApi->wardsControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**WardDto**](WardDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **wardsControllerList**
> WardPageDto wardsControllerList(page, pageSize)

List wards (paged, by code)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getWardsApi();
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.wardsControllerList(page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WardsApi->wardsControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**WardPageDto**](WardPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **wardsControllerUpdate**
> WardDto wardsControllerUpdate(id, updateWardDto)

Update a ward (ADMIN, optimistic locking via expectedVersion)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getWardsApi();
final String id = id_example; // String | 
final UpdateWardDto updateWardDto = ; // UpdateWardDto | 

try {
    final response = api.wardsControllerUpdate(id, updateWardDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling WardsApi->wardsControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateWardDto** | [**UpdateWardDto**](UpdateWardDto.md)|  | 

### Return type

[**WardDto**](WardDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

