# fieldops_api.api.HolidaysApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**holidaysControllerCreate**](HolidaysApi.md#holidayscontrollercreate) | **POST** /api/v1/holidays | Add a holiday (ADMIN, today or later)
[**holidaysControllerList**](HolidaysApi.md#holidayscontrollerlist) | **GET** /api/v1/holidays | Holidays in a calendar year, by date
[**holidaysControllerRemove**](HolidaysApi.md#holidayscontrollerremove) | **DELETE** /api/v1/holidays/{id} | Remove a coming holiday (ADMIN)
[**holidaysControllerUpdate**](HolidaysApi.md#holidayscontrollerupdate) | **PATCH** /api/v1/holidays/{id} | Change a coming holiday (ADMIN, optimistic locking via expectedVersion)


# **holidaysControllerCreate**
> HolidayDto holidaysControllerCreate(createHolidayDto)

Add a holiday (ADMIN, today or later)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getHolidaysApi();
final CreateHolidayDto createHolidayDto = ; // CreateHolidayDto | 

try {
    final response = api.holidaysControllerCreate(createHolidayDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HolidaysApi->holidaysControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createHolidayDto** | [**CreateHolidayDto**](CreateHolidayDto.md)|  | 

### Return type

[**HolidayDto**](HolidayDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **holidaysControllerList**
> BuiltList<HolidayDto> holidaysControllerList(year)

Holidays in a calendar year, by date

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getHolidaysApi();
final num year = 2026; // num | 

try {
    final response = api.holidaysControllerList(year);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HolidaysApi->holidaysControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **year** | **num**|  | 

### Return type

[**BuiltList&lt;HolidayDto&gt;**](HolidayDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **holidaysControllerRemove**
> holidaysControllerRemove(id)

Remove a coming holiday (ADMIN)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getHolidaysApi();
final String id = id_example; // String | 

try {
    api.holidaysControllerRemove(id);
} catch on DioException (e) {
    print('Exception when calling HolidaysApi->holidaysControllerRemove: $e\n');
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

# **holidaysControllerUpdate**
> HolidayDto holidaysControllerUpdate(id, updateHolidayDto)

Change a coming holiday (ADMIN, optimistic locking via expectedVersion)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getHolidaysApi();
final String id = id_example; // String | 
final UpdateHolidayDto updateHolidayDto = ; // UpdateHolidayDto | 

try {
    final response = api.holidaysControllerUpdate(id, updateHolidayDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling HolidaysApi->holidaysControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateHolidayDto** | [**UpdateHolidayDto**](UpdateHolidayDto.md)|  | 

### Return type

[**HolidayDto**](HolidayDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

