# fieldops_api.api.ReportsApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reportsControllerLive**](ReportsApi.md#reportscontrollerlive) | **GET** /api/v1/live/positions | Who is checked in on a field shift right now, with their latest position
[**reportsControllerMusterRoll**](ReportsApi.md#reportscontrollermusterroll) | **GET** /api/v1/reports/muster-roll | A ward&#39;s monthly muster roll: CSV (Marathi names) or printable PDF
[**reportsControllerPublicWard**](ReportsApi.md#reportscontrollerpublicward) | **GET** /api/v1/public/wards/{id}/attendance | Citizens: staff placed and present in a ward over the last week (counts only)
[**reportsControllerStaffDays**](ReportsApi.md#reportscontrollerstaffdays) | **GET** /api/v1/reports/staff-days | Per-person late marks, absences, leave and corrections over a range
[**reportsControllerWardDays**](ReportsApi.md#reportscontrollerwarddays) | **GET** /api/v1/reports/ward-days | Daily attendance per ward from the nightly summaries (up to 92 days)


# **reportsControllerLive**
> LiveDto reportsControllerLive(wardId)

Who is checked in on a field shift right now, with their latest position

Admin all wards (or one), ward inspector their ward, inspector their team and placements. Poll every 30 s; state ACTIVE / STALE / SILENT / NO_SIGNAL from the last ping.

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getReportsApi();
final String wardId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | One ward (admins); ward inspectors see their own

try {
    final response = api.reportsControllerLive(wardId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ReportsApi->reportsControllerLive: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **wardId** | **String**| One ward (admins); ward inspectors see their own | [optional] 

### Return type

[**LiveDto**](LiveDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportsControllerMusterRoll**
> Uint8List reportsControllerMusterRoll(month, wardId, format)

A ward's monthly muster roll: CSV (Marathi names) or printable PDF

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getReportsApi();
final String month = 2026-11; // String | Calendar month (IST)
final String wardId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Required for admins; ward inspectors get their own
final String format = format_example; // String | 

try {
    final response = api.reportsControllerMusterRoll(month, wardId, format);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ReportsApi->reportsControllerMusterRoll: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **month** | **String**| Calendar month (IST) | 
 **wardId** | **String**| Required for admins; ward inspectors get their own | [optional] 
 **format** | **String**|  | [optional] [default to 'csv']

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv, application/pdf, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportsControllerPublicWard**
> PublicWardAttendanceDto reportsControllerPublicWard(id)

Citizens: staff placed and present in a ward over the last week (counts only)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getReportsApi();
final String id = id_example; // String | 

try {
    final response = api.reportsControllerPublicWard(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ReportsApi->reportsControllerPublicWard: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PublicWardAttendanceDto**](PublicWardAttendanceDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportsControllerStaffDays**
> StaffReportDto reportsControllerStaffDays(from, to, wardId, page, pageSize)

Per-person late marks, absences, leave and corrections over a range

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getReportsApi();
final String from = 2026-10-01; // String | IST date, inclusive
final String to = 2026-10-31; // String | IST date, inclusive (at most 92 days)
final String wardId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | One ward (admins); ward inspectors see their own
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.reportsControllerStaffDays(from, to, wardId, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ReportsApi->reportsControllerStaffDays: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **String**| IST date, inclusive | 
 **to** | **String**| IST date, inclusive (at most 92 days) | 
 **wardId** | **String**| One ward (admins); ward inspectors see their own | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **pageSize** | **int**|  | [optional] [default to 100]

### Return type

[**StaffReportDto**](StaffReportDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportsControllerWardDays**
> WardDaysDto reportsControllerWardDays(from, to, wardId)

Daily attendance per ward from the nightly summaries (up to 92 days)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getReportsApi();
final String from = 2026-10-01; // String | IST date, inclusive
final String to = 2026-10-31; // String | IST date, inclusive (at most 92 days)
final String wardId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | One ward (admins); ward inspectors see their own

try {
    final response = api.reportsControllerWardDays(from, to, wardId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ReportsApi->reportsControllerWardDays: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **String**| IST date, inclusive | 
 **to** | **String**| IST date, inclusive (at most 92 days) | 
 **wardId** | **String**| One ward (admins); ward inspectors see their own | [optional] 

### Return type

[**WardDaysDto**](WardDaysDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

