# fieldops_api.api.HealthApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**healthControllerHealth**](HealthApi.md#healthcontrollerhealth) | **GET** /api/v1/health | Liveness: the process is up
[**healthControllerReady**](HealthApi.md#healthcontrollerready) | **GET** /api/v1/ready | Readiness: database reachable and all migrations applied


# **healthControllerHealth**
> HealthDto healthControllerHealth()

Liveness: the process is up

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getHealthApi();

try {
    final response = api.healthControllerHealth();
    print(response);
} catch on DioException (e) {
    print('Exception when calling HealthApi->healthControllerHealth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**HealthDto**](HealthDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **healthControllerReady**
> ReadyDto healthControllerReady()

Readiness: database reachable and all migrations applied

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getHealthApi();

try {
    final response = api.healthControllerReady();
    print(response);
} catch on DioException (e) {
    print('Exception when calling HealthApi->healthControllerReady: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ReadyDto**](ReadyDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

