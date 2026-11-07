# fieldops_api.api.PublicApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**appInfoControllerGet**](PublicApi.md#appinfocontrollerget) | **GET** /api/v1/public/app-config | Mobile start-up settings: minimum version, face flow, ping cadence, server time
[**publicComplaintsControllerSubmit**](PublicApi.md#publiccomplaintscontrollersubmit) | **POST** /api/v1/public/complaints | File a civic complaint (no sign-in); returns the tracking ID
[**publicComplaintsControllerTrack**](PublicApi.md#publiccomplaintscontrollertrack) | **GET** /api/v1/public/complaints/{trackingId} | Track a complaint by its tracking ID (no sign-in)
[**publicWardsControllerList**](PublicApi.md#publicwardscontrollerlist) | **GET** /api/v1/public/wards | Active wards with their boundaries (no sign-in)


# **appInfoControllerGet**
> AppInfoDto appInfoControllerGet()

Mobile start-up settings: minimum version, face flow, ping cadence, server time

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getPublicApi();

try {
    final response = api.appInfoControllerGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling PublicApi->appInfoControllerGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AppInfoDto**](AppInfoDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publicComplaintsControllerSubmit**
> PublicComplaintDto publicComplaintsControllerSubmit(submitComplaintDto)

File a civic complaint (no sign-in); returns the tracking ID

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getPublicApi();
final SubmitComplaintDto submitComplaintDto = ; // SubmitComplaintDto | 

try {
    final response = api.publicComplaintsControllerSubmit(submitComplaintDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PublicApi->publicComplaintsControllerSubmit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submitComplaintDto** | [**SubmitComplaintDto**](SubmitComplaintDto.md)|  | 

### Return type

[**PublicComplaintDto**](PublicComplaintDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publicComplaintsControllerTrack**
> PublicComplaintDto publicComplaintsControllerTrack(trackingId)

Track a complaint by its tracking ID (no sign-in)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getPublicApi();
final String trackingId = trackingId_example; // String | 

try {
    final response = api.publicComplaintsControllerTrack(trackingId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PublicApi->publicComplaintsControllerTrack: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **trackingId** | **String**|  | 

### Return type

[**PublicComplaintDto**](PublicComplaintDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publicWardsControllerList**
> BuiltList<PublicWardDto> publicWardsControllerList()

Active wards with their boundaries (no sign-in)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getPublicApi();

try {
    final response = api.publicWardsControllerList();
    print(response);
} catch on DioException (e) {
    print('Exception when calling PublicApi->publicWardsControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;PublicWardDto&gt;**](PublicWardDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

