# fieldops_api.api.OfficesApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**officesControllerCheckLocation**](OfficesApi.md#officescontrollerchecklocation) | **POST** /api/v1/offices/{id}/location-check | Is a point inside the office premises or its buffer?
[**officesControllerCreate**](OfficesApi.md#officescontrollercreate) | **POST** /api/v1/offices | Create an office (ADMIN)
[**officesControllerGet**](OfficesApi.md#officescontrollerget) | **GET** /api/v1/offices/{id} | Get one office with its premises
[**officesControllerList**](OfficesApi.md#officescontrollerlist) | **GET** /api/v1/offices | List corporation offices
[**officesControllerUpdate**](OfficesApi.md#officescontrollerupdate) | **PATCH** /api/v1/offices/{id} | Update an office (ADMIN, optimistic locking)


# **officesControllerCheckLocation**
> OfficeLocationCheckResultDto officesControllerCheckLocation(id, locationCheckDto)

Is a point inside the office premises or its buffer?

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getOfficesApi();
final String id = id_example; // String | 
final LocationCheckDto locationCheckDto = ; // LocationCheckDto | 

try {
    final response = api.officesControllerCheckLocation(id, locationCheckDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling OfficesApi->officesControllerCheckLocation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **locationCheckDto** | [**LocationCheckDto**](LocationCheckDto.md)|  | 

### Return type

[**OfficeLocationCheckResultDto**](OfficeLocationCheckResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **officesControllerCreate**
> OfficeDto officesControllerCreate(createOfficeDto)

Create an office (ADMIN)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getOfficesApi();
final CreateOfficeDto createOfficeDto = ; // CreateOfficeDto | 

try {
    final response = api.officesControllerCreate(createOfficeDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling OfficesApi->officesControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createOfficeDto** | [**CreateOfficeDto**](CreateOfficeDto.md)|  | 

### Return type

[**OfficeDto**](OfficeDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **officesControllerGet**
> OfficeDto officesControllerGet(id)

Get one office with its premises

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getOfficesApi();
final String id = id_example; // String | 

try {
    final response = api.officesControllerGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling OfficesApi->officesControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**OfficeDto**](OfficeDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **officesControllerList**
> BuiltList<OfficeDto> officesControllerList()

List corporation offices

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getOfficesApi();

try {
    final response = api.officesControllerList();
    print(response);
} catch on DioException (e) {
    print('Exception when calling OfficesApi->officesControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;OfficeDto&gt;**](OfficeDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **officesControllerUpdate**
> OfficeDto officesControllerUpdate(id, updateOfficeDto)

Update an office (ADMIN, optimistic locking)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getOfficesApi();
final String id = id_example; // String | 
final UpdateOfficeDto updateOfficeDto = ; // UpdateOfficeDto | 

try {
    final response = api.officesControllerUpdate(id, updateOfficeDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling OfficesApi->officesControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateOfficeDto** | [**UpdateOfficeDto**](UpdateOfficeDto.md)|  | 

### Return type

[**OfficeDto**](OfficeDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

