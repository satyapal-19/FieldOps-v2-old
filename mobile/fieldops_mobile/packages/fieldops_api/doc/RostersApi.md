# fieldops_api.api.RostersApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**rostersControllerApprove**](RostersApi.md#rosterscontrollerapprove) | **POST** /api/v1/assignments/{id}/approve | Approve a self-service assignment (never your own)
[**rostersControllerAssign**](RostersApi.md#rosterscontrollerassign) | **POST** /api/v1/assignments | Place an inspector in a ward or a worker in a team for a day (approved at once)
[**rostersControllerCreateRoster**](RostersApi.md#rosterscontrollercreateroster) | **POST** /api/v1/rosters/standing | Put a worker in an inspector&#39;s standing squad (ward from the inspector)
[**rostersControllerGenerate**](RostersApi.md#rosterscontrollergenerate) | **POST** /api/v1/assignments/generate | Create a day&#39;s assignments from the standing squads (safe to repeat)
[**rostersControllerListAssignments**](RostersApi.md#rosterscontrollerlistassignments) | **GET** /api/v1/assignments | A day&#39;s assignments (ADMIN all, ward inspector own ward, inspector own team, worker self)
[**rostersControllerListRosters**](RostersApi.md#rosterscontrollerlistrosters) | **GET** /api/v1/rosters/standing | List standing squads (ADMIN all, ward inspector own ward, inspector own squad)
[**rostersControllerSelfAssign**](RostersApi.md#rosterscontrollerselfassign) | **POST** /api/v1/assignments/self | Self-pick a ward (inspector) or self-join a team (worker); starts unapproved
[**rostersControllerUpdateRoster**](RostersApi.md#rosterscontrollerupdateroster) | **PATCH** /api/v1/rosters/standing/{id} | Move a worker to another inspector, or (de)activate the row


# **rostersControllerApprove**
> AssignmentDto rostersControllerApprove(id, approveAssignmentDto)

Approve a self-service assignment (never your own)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getRostersApi();
final String id = id_example; // String | 
final ApproveAssignmentDto approveAssignmentDto = ; // ApproveAssignmentDto | 

try {
    final response = api.rostersControllerApprove(id, approveAssignmentDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RostersApi->rostersControllerApprove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **approveAssignmentDto** | [**ApproveAssignmentDto**](ApproveAssignmentDto.md)|  | 

### Return type

[**AssignmentDto**](AssignmentDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rostersControllerAssign**
> AssignmentDto rostersControllerAssign(createAssignmentDto)

Place an inspector in a ward or a worker in a team for a day (approved at once)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getRostersApi();
final CreateAssignmentDto createAssignmentDto = ; // CreateAssignmentDto | 

try {
    final response = api.rostersControllerAssign(createAssignmentDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RostersApi->rostersControllerAssign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createAssignmentDto** | [**CreateAssignmentDto**](CreateAssignmentDto.md)|  | 

### Return type

[**AssignmentDto**](AssignmentDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rostersControllerCreateRoster**
> StandingRosterDto rostersControllerCreateRoster(createStandingRosterDto)

Put a worker in an inspector's standing squad (ward from the inspector)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getRostersApi();
final CreateStandingRosterDto createStandingRosterDto = ; // CreateStandingRosterDto | 

try {
    final response = api.rostersControllerCreateRoster(createStandingRosterDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RostersApi->rostersControllerCreateRoster: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createStandingRosterDto** | [**CreateStandingRosterDto**](CreateStandingRosterDto.md)|  | 

### Return type

[**StandingRosterDto**](StandingRosterDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rostersControllerGenerate**
> GenerateAssignmentsResultDto rostersControllerGenerate(generateAssignmentsDto)

Create a day's assignments from the standing squads (safe to repeat)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getRostersApi();
final GenerateAssignmentsDto generateAssignmentsDto = ; // GenerateAssignmentsDto | 

try {
    final response = api.rostersControllerGenerate(generateAssignmentsDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RostersApi->rostersControllerGenerate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **generateAssignmentsDto** | [**GenerateAssignmentsDto**](GenerateAssignmentsDto.md)|  | 

### Return type

[**GenerateAssignmentsResultDto**](GenerateAssignmentsResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rostersControllerListAssignments**
> AssignmentPageDto rostersControllerListAssignments(date, page, pageSize, wardId, inspectorId, isApproved)

A day's assignments (ADMIN all, ward inspector own ward, inspector own team, worker self)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getRostersApi();
final String date = 2026-11-02; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 
final String wardId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String inspectorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final bool isApproved = true; // bool | 

try {
    final response = api.rostersControllerListAssignments(date, page, pageSize, wardId, inspectorId, isApproved);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RostersApi->rostersControllerListAssignments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **String**|  | 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 50]
 **wardId** | **String**|  | [optional] 
 **inspectorId** | **String**|  | [optional] 
 **isApproved** | **bool**|  | [optional] 

### Return type

[**AssignmentPageDto**](AssignmentPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rostersControllerListRosters**
> StandingRosterPageDto rostersControllerListRosters(page, pageSize, wardId, inspectorId, isActive)

List standing squads (ADMIN all, ward inspector own ward, inspector own squad)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getRostersApi();
final int page = 56; // int | 
final int pageSize = 56; // int | 
final String wardId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String inspectorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final bool isActive = true; // bool | 

try {
    final response = api.rostersControllerListRosters(page, pageSize, wardId, inspectorId, isActive);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RostersApi->rostersControllerListRosters: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 50]
 **wardId** | **String**|  | [optional] 
 **inspectorId** | **String**|  | [optional] 
 **isActive** | **bool**|  | [optional] 

### Return type

[**StandingRosterPageDto**](StandingRosterPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rostersControllerSelfAssign**
> AssignmentDto rostersControllerSelfAssign(selfAssignmentDto)

Self-pick a ward (inspector) or self-join a team (worker); starts unapproved

Retry-safe: the same clientUuid returns the row it created.

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getRostersApi();
final SelfAssignmentDto selfAssignmentDto = ; // SelfAssignmentDto | 

try {
    final response = api.rostersControllerSelfAssign(selfAssignmentDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RostersApi->rostersControllerSelfAssign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **selfAssignmentDto** | [**SelfAssignmentDto**](SelfAssignmentDto.md)|  | 

### Return type

[**AssignmentDto**](AssignmentDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rostersControllerUpdateRoster**
> StandingRosterDto rostersControllerUpdateRoster(id, updateStandingRosterDto)

Move a worker to another inspector, or (de)activate the row

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getRostersApi();
final String id = id_example; // String | 
final UpdateStandingRosterDto updateStandingRosterDto = ; // UpdateStandingRosterDto | 

try {
    final response = api.rostersControllerUpdateRoster(id, updateStandingRosterDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RostersApi->rostersControllerUpdateRoster: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateStandingRosterDto** | [**UpdateStandingRosterDto**](UpdateStandingRosterDto.md)|  | 

### Return type

[**StandingRosterDto**](StandingRosterDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

