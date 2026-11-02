# fieldops_api.api.StaffApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**staffAdminControllerCreate**](StaffApi.md#staffadmincontrollercreate) | **POST** /api/v1/staff | Create a staff member (ADMIN)
[**staffAdminControllerGet**](StaffApi.md#staffadmincontrollerget) | **GET** /api/v1/staff/{id} | Get one staff member (yourself, or someone in your scope)
[**staffAdminControllerList**](StaffApi.md#staffadmincontrollerlist) | **GET** /api/v1/staff | List staff in your scope (paged, by employee code)
[**staffAdminControllerUpdate**](StaffApi.md#staffadmincontrollerupdate) | **PATCH** /api/v1/staff/{id} | Update or deactivate a staff member (ADMIN, optimistic locking via expectedVersion)


# **staffAdminControllerCreate**
> StaffProfileDto staffAdminControllerCreate(createStaffDto)

Create a staff member (ADMIN)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getStaffApi();
final CreateStaffDto createStaffDto = ; // CreateStaffDto | 

try {
    final response = api.staffAdminControllerCreate(createStaffDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling StaffApi->staffAdminControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createStaffDto** | [**CreateStaffDto**](CreateStaffDto.md)|  | 

### Return type

[**StaffProfileDto**](StaffProfileDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **staffAdminControllerGet**
> StaffProfileDto staffAdminControllerGet(id)

Get one staff member (yourself, or someone in your scope)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getStaffApi();
final String id = id_example; // String | 

try {
    final response = api.staffAdminControllerGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling StaffApi->staffAdminControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**StaffProfileDto**](StaffProfileDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **staffAdminControllerList**
> StaffPageDto staffAdminControllerList(role, wardId, officeId, isActive, q, ids, page, pageSize)

List staff in your scope (paged, by employee code)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getStaffApi();
final String role = role_example; // String | 
final String wardId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String officeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final bool isActive = true; // bool | 
final String q = q_example; // String | Part of an employee code or name
final String ids = ids_example; // String | Comma-separated staff ids (up to 100), e.g. the names behind a page of records
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.staffAdminControllerList(role, wardId, officeId, isActive, q, ids, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling StaffApi->staffAdminControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **role** | **String**|  | [optional] 
 **wardId** | **String**|  | [optional] 
 **officeId** | **String**|  | [optional] 
 **isActive** | **bool**|  | [optional] 
 **q** | **String**| Part of an employee code or name | [optional] 
 **ids** | **String**| Comma-separated staff ids (up to 100), e.g. the names behind a page of records | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 20]

### Return type

[**StaffPageDto**](StaffPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **staffAdminControllerUpdate**
> StaffProfileDto staffAdminControllerUpdate(id, updateStaffDto)

Update or deactivate a staff member (ADMIN, optimistic locking via expectedVersion)

Changing role, ward, office or phone, or deactivating, signs the person out everywhere.

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getStaffApi();
final String id = id_example; // String | 
final UpdateStaffDto updateStaffDto = ; // UpdateStaffDto | 

try {
    final response = api.staffAdminControllerUpdate(id, updateStaffDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling StaffApi->staffAdminControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateStaffDto** | [**UpdateStaffDto**](UpdateStaffDto.md)|  | 

### Return type

[**StaffProfileDto**](StaffProfileDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

