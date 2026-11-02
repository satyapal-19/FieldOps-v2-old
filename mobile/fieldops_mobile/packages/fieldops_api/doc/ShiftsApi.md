# fieldops_api.api.ShiftsApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**shiftsControllerEffective**](ShiftsApi.md#shiftscontrollereffective) | **GET** /api/v1/shifts/effective | The shift that applies on a day: the override, else the staff defaults
[**shiftsControllerList**](ShiftsApi.md#shiftscontrollerlist) | **GET** /api/v1/shifts | A person&#39;s shift overrides in a date range (yourself, or staff in your scope)
[**shiftsControllerPut**](ShiftsApi.md#shiftscontrollerput) | **PUT** /api/v1/shifts | Set a person&#39;s shift for a day (ADMIN; ward inspector for their ward&#39;s staff)
[**shiftsControllerRemove**](ShiftsApi.md#shiftscontrollerremove) | **DELETE** /api/v1/shifts/{id} | Remove an override for today or a coming day (defaults apply again)


# **shiftsControllerEffective**
> EffectiveShiftDto shiftsControllerEffective(staffId, date)

The shift that applies on a day: the override, else the staff defaults

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getShiftsApi();
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String date = 2026-11-02; // String | 

try {
    final response = api.shiftsControllerEffective(staffId, date);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ShiftsApi->shiftsControllerEffective: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffId** | **String**|  | 
 **date** | **String**|  | 

### Return type

[**EffectiveShiftDto**](EffectiveShiftDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shiftsControllerList**
> BuiltList<ShiftDto> shiftsControllerList(staffId, from, to)

A person's shift overrides in a date range (yourself, or staff in your scope)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getShiftsApi();
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String from = 2026-11-01; // String | 
final String to = 2026-11-30; // String | At most 62 days after from

try {
    final response = api.shiftsControllerList(staffId, from, to);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ShiftsApi->shiftsControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffId** | **String**|  | 
 **from** | **String**|  | 
 **to** | **String**| At most 62 days after from | 

### Return type

[**BuiltList&lt;ShiftDto&gt;**](ShiftDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shiftsControllerPut**
> ShiftDto shiftsControllerPut(putShiftDto)

Set a person's shift for a day (ADMIN; ward inspector for their ward's staff)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getShiftsApi();
final PutShiftDto putShiftDto = ; // PutShiftDto | 

try {
    final response = api.shiftsControllerPut(putShiftDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ShiftsApi->shiftsControllerPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **putShiftDto** | [**PutShiftDto**](PutShiftDto.md)|  | 

### Return type

[**ShiftDto**](ShiftDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shiftsControllerRemove**
> shiftsControllerRemove(id)

Remove an override for today or a coming day (defaults apply again)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getShiftsApi();
final String id = id_example; // String | 

try {
    api.shiftsControllerRemove(id);
} catch on DioException (e) {
    print('Exception when calling ShiftsApi->shiftsControllerRemove: $e\n');
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

