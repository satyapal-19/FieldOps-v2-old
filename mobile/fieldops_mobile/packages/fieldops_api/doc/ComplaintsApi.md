# fieldops_api.api.ComplaintsApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**complaintsControllerAssign**](ComplaintsApi.md#complaintscontrollerassign) | **POST** /api/v1/complaints/{id}/assign | Route a complaint by raising a task (admin; ward inspector of its ward)
[**complaintsControllerChangeStatus**](ComplaintsApi.md#complaintscontrollerchangestatus) | **POST** /api/v1/complaints/{id}/status | RESOLVE (after an approved task), REJECT (from RECEIVED) or CLOSE a complaint
[**complaintsControllerGet**](ComplaintsApi.md#complaintscontrollerget) | **GET** /api/v1/complaints/{id} | One complaint with its linked tasks
[**complaintsControllerList**](ComplaintsApi.md#complaintscontrollerlist) | **GET** /api/v1/complaints | Complaints in your scope (admin and office staff: all; ward supervisors: ward)


# **complaintsControllerAssign**
> ComplaintDto complaintsControllerAssign(id, assignComplaintDto)

Route a complaint by raising a task (admin; ward inspector of its ward)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getComplaintsApi();
final String id = id_example; // String | 
final AssignComplaintDto assignComplaintDto = ; // AssignComplaintDto | 

try {
    final response = api.complaintsControllerAssign(id, assignComplaintDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ComplaintsApi->complaintsControllerAssign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **assignComplaintDto** | [**AssignComplaintDto**](AssignComplaintDto.md)|  | 

### Return type

[**ComplaintDto**](ComplaintDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **complaintsControllerChangeStatus**
> ComplaintDto complaintsControllerChangeStatus(id, complaintStatusDto)

RESOLVE (after an approved task), REJECT (from RECEIVED) or CLOSE a complaint

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getComplaintsApi();
final String id = id_example; // String | 
final ComplaintStatusDto complaintStatusDto = ; // ComplaintStatusDto | 

try {
    final response = api.complaintsControllerChangeStatus(id, complaintStatusDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ComplaintsApi->complaintsControllerChangeStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **complaintStatusDto** | [**ComplaintStatusDto**](ComplaintStatusDto.md)|  | 

### Return type

[**ComplaintDto**](ComplaintDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **complaintsControllerGet**
> ComplaintDto complaintsControllerGet(id)

One complaint with its linked tasks

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getComplaintsApi();
final String id = id_example; // String | 

try {
    final response = api.complaintsControllerGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ComplaintsApi->complaintsControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**ComplaintDto**](ComplaintDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **complaintsControllerList**
> ComplaintPageDto complaintsControllerList(status, wardId, unrouted, page, pageSize)

Complaints in your scope (admin and office staff: all; ward supervisors: ward)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getComplaintsApi();
final String status = status_example; // String | 
final String wardId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final bool unrouted = true; // bool | Only complaints with no ward yet (admin routing queue)
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.complaintsControllerList(status, wardId, unrouted, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ComplaintsApi->complaintsControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **wardId** | **String**|  | [optional] 
 **unrouted** | **bool**| Only complaints with no ward yet (admin routing queue) | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 50]

### Return type

[**ComplaintPageDto**](ComplaintPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

