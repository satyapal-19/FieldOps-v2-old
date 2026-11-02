# fieldops_api.api.TasksApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**tasksControllerAssigneeUpdate**](TasksApi.md#taskscontrollerassigneeupdate) | **POST** /api/v1/tasks/{id}/updates | START or SUBMIT your task from the phone (retry-safe with clientUuid)
[**tasksControllerCreate**](TasksApi.md#taskscontrollercreate) | **POST** /api/v1/tasks | Assign a task down the hierarchy
[**tasksControllerGet**](TasksApi.md#taskscontrollerget) | **GET** /api/v1/tasks/{id} | One task
[**tasksControllerHistory**](TasksApi.md#taskscontrollerhistory) | **GET** /api/v1/tasks/{id}/history | A task&#39;s status changes, oldest first
[**tasksControllerList**](TasksApi.md#taskscontrollerlist) | **GET** /api/v1/tasks | Tasks in your scope (assigned to you, your team, your ward, or all)
[**tasksControllerReassign**](TasksApi.md#taskscontrollerreassign) | **POST** /api/v1/tasks/{id}/reassign | Give an unfinished task to someone else; it restarts as OPEN
[**tasksControllerSupervise**](TasksApi.md#taskscontrollersupervise) | **POST** /api/v1/tasks/{id}/review | APPROVE, REJECT (with reason), ESCALATE or CLOSE a task you supervise


# **tasksControllerAssigneeUpdate**
> TaskDto tasksControllerAssigneeUpdate(id, assigneeUpdateDto)

START or SUBMIT your task from the phone (retry-safe with clientUuid)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getTasksApi();
final String id = id_example; // String | 
final AssigneeUpdateDto assigneeUpdateDto = ; // AssigneeUpdateDto | 

try {
    final response = api.tasksControllerAssigneeUpdate(id, assigneeUpdateDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TasksApi->tasksControllerAssigneeUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **assigneeUpdateDto** | [**AssigneeUpdateDto**](AssigneeUpdateDto.md)|  | 

### Return type

[**TaskDto**](TaskDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tasksControllerCreate**
> TaskDto tasksControllerCreate(createTaskDto)

Assign a task down the hierarchy

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getTasksApi();
final CreateTaskDto createTaskDto = ; // CreateTaskDto | 

try {
    final response = api.tasksControllerCreate(createTaskDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TasksApi->tasksControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createTaskDto** | [**CreateTaskDto**](CreateTaskDto.md)|  | 

### Return type

[**TaskDto**](TaskDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tasksControllerGet**
> TaskDto tasksControllerGet(id)

One task

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getTasksApi();
final String id = id_example; // String | 

try {
    final response = api.tasksControllerGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TasksApi->tasksControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**TaskDto**](TaskDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tasksControllerHistory**
> BuiltList<TaskUpdateDto> tasksControllerHistory(id)

A task's status changes, oldest first

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getTasksApi();
final String id = id_example; // String | 

try {
    final response = api.tasksControllerHistory(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TasksApi->tasksControllerHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**BuiltList&lt;TaskUpdateDto&gt;**](TaskUpdateDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tasksControllerList**
> TaskPageDto tasksControllerList(status, assignedToId, page, pageSize)

Tasks in your scope (assigned to you, your team, your ward, or all)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getTasksApi();
final String status = status_example; // String | 
final String assignedToId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.tasksControllerList(status, assignedToId, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TasksApi->tasksControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **assignedToId** | **String**|  | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 50]

### Return type

[**TaskPageDto**](TaskPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tasksControllerReassign**
> TaskDto tasksControllerReassign(id, reassignTaskDto)

Give an unfinished task to someone else; it restarts as OPEN

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getTasksApi();
final String id = id_example; // String | 
final ReassignTaskDto reassignTaskDto = ; // ReassignTaskDto | 

try {
    final response = api.tasksControllerReassign(id, reassignTaskDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TasksApi->tasksControllerReassign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **reassignTaskDto** | [**ReassignTaskDto**](ReassignTaskDto.md)|  | 

### Return type

[**TaskDto**](TaskDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tasksControllerSupervise**
> TaskDto tasksControllerSupervise(id, supervisorActionDto)

APPROVE, REJECT (with reason), ESCALATE or CLOSE a task you supervise

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getTasksApi();
final String id = id_example; // String | 
final SupervisorActionDto supervisorActionDto = ; // SupervisorActionDto | 

try {
    final response = api.tasksControllerSupervise(id, supervisorActionDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TasksApi->tasksControllerSupervise: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **supervisorActionDto** | [**SupervisorActionDto**](SupervisorActionDto.md)|  | 

### Return type

[**TaskDto**](TaskDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

