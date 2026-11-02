# fieldops_api.api.AlertsApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**alertsControllerGet**](AlertsApi.md#alertscontrollerget) | **GET** /api/v1/alerts/{id} | One alert
[**alertsControllerList**](AlertsApi.md#alertscontrollerlist) | **GET** /api/v1/alerts | Alerts in your scope, newest first (admin all, ward inspector ward, inspector team)
[**alertsControllerResolve**](AlertsApi.md#alertscontrollerresolve) | **POST** /api/v1/alerts/{id}/resolve | Resolve an open alert with an optional note (never one about yourself)


# **alertsControllerGet**
> AlertDto alertsControllerGet(id)

One alert

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAlertsApi();
final String id = id_example; // String | 

try {
    final response = api.alertsControllerGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AlertsApi->alertsControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AlertDto**](AlertDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **alertsControllerList**
> AlertPageDto alertsControllerList(isResolved, alertType, severity, staffId, from, to, page, pageSize)

Alerts in your scope, newest first (admin all, ward inspector ward, inspector team)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAlertsApi();
final bool isResolved = true; // bool | false = the open queue
final String alertType = alertType_example; // String | 
final String severity = severity_example; // String | 
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Alerts about one person in your scope
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.alertsControllerList(isResolved, alertType, severity, staffId, from, to, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AlertsApi->alertsControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **isResolved** | **bool**| false = the open queue | [optional] 
 **alertType** | **String**|  | [optional] 
 **severity** | **String**|  | [optional] 
 **staffId** | **String**| Alerts about one person in your scope | [optional] 
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 50]

### Return type

[**AlertPageDto**](AlertPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **alertsControllerResolve**
> AlertDto alertsControllerResolve(id, resolveAlertDto)

Resolve an open alert with an optional note (never one about yourself)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAlertsApi();
final String id = id_example; // String | 
final ResolveAlertDto resolveAlertDto = ; // ResolveAlertDto | 

try {
    final response = api.alertsControllerResolve(id, resolveAlertDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AlertsApi->alertsControllerResolve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **resolveAlertDto** | [**ResolveAlertDto**](ResolveAlertDto.md)|  | 

### Return type

[**AlertDto**](AlertDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

