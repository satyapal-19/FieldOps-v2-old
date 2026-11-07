# fieldops_api.api.AttendanceApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**attendanceControllerChallenge**](AttendanceApi.md#attendancecontrollerchallenge) | **POST** /api/v1/attendance/challenges | One-time liveness challenge for the next punch (yourself, or a team member)
[**attendanceControllerGet**](AttendanceApi.md#attendancecontrollerget) | **GET** /api/v1/attendance/{id} | One attendance record
[**attendanceControllerList**](AttendanceApi.md#attendancecontrollerlist) | **GET** /api/v1/attendance | Attendance in your scope (self, team, ward, or all)
[**attendanceControllerPings**](AttendanceApi.md#attendancecontrollerpings) | **POST** /api/v1/attendance/pings | Your location breadcrumbs (live or from the offline buffer), up to 200 per call
[**attendanceControllerPresenceKey**](AttendanceApi.md#attendancecontrollerpresencekey) | **GET** /api/v1/attendance/presence-key | My key for the rolling co-presence code (TOTP) my phone shows when I am marked by proxy
[**attendanceControllerPunch**](AttendanceApi.md#attendancecontrollerpunch) | **POST** /api/v1/attendance/punches | Check in or out (self or proxy): server time, geofence, hierarchy and face checks
[**attendanceControllerTamper**](AttendanceApi.md#attendancecontrollertamper) | **POST** /api/v1/attendance/tamper-events | Tamper signals from your phone watchdog (GPS off, mock location, ...)
[**routeControllerRoute**](AttendanceApi.md#routecontrollerroute) | **GET** /api/v1/staff/{id}/route | A person&#39;s route on an IST date: points, distance, gaps and tamper events


# **attendanceControllerChallenge**
> ChallengeDto attendanceControllerChallenge(createChallengeDto)

One-time liveness challenge for the next punch (yourself, or a team member)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAttendanceApi();
final CreateChallengeDto createChallengeDto = ; // CreateChallengeDto | 

try {
    final response = api.attendanceControllerChallenge(createChallengeDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AttendanceApi->attendanceControllerChallenge: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createChallengeDto** | [**CreateChallengeDto**](CreateChallengeDto.md)|  | 

### Return type

[**ChallengeDto**](ChallengeDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **attendanceControllerGet**
> AttendanceLogDto attendanceControllerGet(id)

One attendance record

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAttendanceApi();
final String id = id_example; // String | 

try {
    final response = api.attendanceControllerGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AttendanceApi->attendanceControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AttendanceLogDto**](AttendanceLogDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **attendanceControllerList**
> AttendancePageDto attendanceControllerList(from, to, staffId, status, page, pageSize)

Attendance in your scope (self, team, ward, or all)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAttendanceApi();
final String from = 2026-11-01; // String | IST date, inclusive
final String to = 2026-11-02; // String | IST date, inclusive
final String staffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | One person in your scope
final String status = status_example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.attendanceControllerList(from, to, staffId, status, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AttendanceApi->attendanceControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **String**| IST date, inclusive | [optional] 
 **to** | **String**| IST date, inclusive | [optional] 
 **staffId** | **String**| One person in your scope | [optional] 
 **status** | **String**|  | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 50]

### Return type

[**AttendancePageDto**](AttendancePageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **attendanceControllerPings**
> PingBatchResultDto attendanceControllerPings(pingBatchDto)

Your location breadcrumbs (live or from the offline buffer), up to 200 per call

Idempotent by clientUuid. Fixes older than 48 h or more than 2 minutes ahead of server time are rejected. Two outside pings in a row during a ward shift raise OUT_OF_ZONE.

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAttendanceApi();
final PingBatchDto pingBatchDto = ; // PingBatchDto | 

try {
    final response = api.attendanceControllerPings(pingBatchDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AttendanceApi->attendanceControllerPings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pingBatchDto** | [**PingBatchDto**](PingBatchDto.md)|  | 

### Return type

[**PingBatchResultDto**](PingBatchResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **attendanceControllerPresenceKey**
> PresenceKeyDto attendanceControllerPresenceKey()

My key for the rolling co-presence code (TOTP) my phone shows when I am marked by proxy

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAttendanceApi();

try {
    final response = api.attendanceControllerPresenceKey();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AttendanceApi->attendanceControllerPresenceKey: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PresenceKeyDto**](PresenceKeyDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **attendanceControllerPunch**
> PunchResultDto attendanceControllerPunch(createPunchDto)

Check in or out (self or proxy): server time, geofence, hierarchy and face checks

Idempotent by clientUuid: a retry returns the accepted punch with replayed = true. Errors: NO_ASSIGNMENT, ASSIGNMENT_NOT_APPROVED, OUTSIDE_GEOFENCE, LOCATION_TOO_INACCURATE, OUTSIDE_SHIFT_WINDOW, ON_LEAVE, NOT_CHECKED_IN, CHALLENGE_INVALID, CHALLENGE_EXPIRED, FACE_MISMATCH, FACE_NOT_ENROLLED (422); ALREADY_CHECKED_IN, ALREADY_CHECKED_OUT (409); FACE_PROVIDER_UNAVAILABLE (503).

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAttendanceApi();
final CreatePunchDto createPunchDto = ; // CreatePunchDto | 

try {
    final response = api.attendanceControllerPunch(createPunchDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AttendanceApi->attendanceControllerPunch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createPunchDto** | [**CreatePunchDto**](CreatePunchDto.md)|  | 

### Return type

[**PunchResultDto**](PunchResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **attendanceControllerTamper**
> TamperBatchResultDto attendanceControllerTamper(tamperBatchDto)

Tamper signals from your phone watchdog (GPS off, mock location, ...)

Idempotent by clientUuid; resend an event with resolvedAt when it ends.

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAttendanceApi();
final TamperBatchDto tamperBatchDto = ; // TamperBatchDto | 

try {
    final response = api.attendanceControllerTamper(tamperBatchDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AttendanceApi->attendanceControllerTamper: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tamperBatchDto** | [**TamperBatchDto**](TamperBatchDto.md)|  | 

### Return type

[**TamperBatchResultDto**](TamperBatchResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **routeControllerRoute**
> RouteDto routeControllerRoute(id, date)

A person's route on an IST date: points, distance, gaps and tamper events

Raw points while they are kept (PING_RETENTION_DAYS), then only the nightly summary. Supervisors see their scope; everyone else only their own route for today's shift.

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAttendanceApi();
final String id = id_example; // String | 
final String date = 2026-11-02; // String | IST attendance date

try {
    final response = api.routeControllerRoute(id, date);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AttendanceApi->routeControllerRoute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **date** | **String**| IST attendance date | 

### Return type

[**RouteDto**](RouteDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

