# fieldops_api.api.AuthApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authControllerChangePassword**](AuthApi.md#authcontrollerchangepassword) | **POST** /api/v1/auth/change-password | Change own web password; signs out other devices
[**authControllerLogin**](AuthApi.md#authcontrollerlogin) | **POST** /api/v1/auth/login | Web dashboard sign-in (ADMIN, WARD_INSPECTOR, OFFICE_STAFF)
[**authControllerLogout**](AuthApi.md#authcontrollerlogout) | **POST** /api/v1/auth/logout | Sign out this device (or every device)
[**authControllerMe**](AuthApi.md#authcontrollerme) | **GET** /api/v1/auth/me | The signed-in staff member
[**authControllerRefresh**](AuthApi.md#authcontrollerrefresh) | **POST** /api/v1/auth/refresh | Swap a refresh token for a new pair (rotation; reuse revokes the session)
[**authControllerRequestOtp**](AuthApi.md#authcontrollerrequestotp) | **POST** /api/v1/auth/otp/request | Send a 6-digit sign-in code by SMS (same answer for unknown numbers)
[**authControllerRevokeSessions**](AuthApi.md#authcontrollerrevokesessions) | **POST** /api/v1/auth/staff/{staffId}/revoke-sessions | Sign a staff member out of every device (ADMIN)
[**authControllerTestLogin**](AuthApi.md#authcontrollertestlogin) | **POST** /api/v1/auth/test-login | Development / test only: sign in without OTP. 404 in production.
[**authControllerVerifyOtp**](AuthApi.md#authcontrollerverifyotp) | **POST** /api/v1/auth/otp/verify | Exchange the SMS code for tokens


# **authControllerChangePassword**
> authControllerChangePassword(changePasswordDto)

Change own web password; signs out other devices

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAuthApi();
final ChangePasswordDto changePasswordDto = ; // ChangePasswordDto | 

try {
    api.authControllerChangePassword(changePasswordDto);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authControllerChangePassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **changePasswordDto** | [**ChangePasswordDto**](ChangePasswordDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerLogin**
> SessionTokensDto authControllerLogin(passwordLoginDto)

Web dashboard sign-in (ADMIN, WARD_INSPECTOR, OFFICE_STAFF)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAuthApi();
final PasswordLoginDto passwordLoginDto = ; // PasswordLoginDto | 

try {
    final response = api.authControllerLogin(passwordLoginDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authControllerLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **passwordLoginDto** | [**PasswordLoginDto**](PasswordLoginDto.md)|  | 

### Return type

[**SessionTokensDto**](SessionTokensDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerLogout**
> authControllerLogout(logoutDto)

Sign out this device (or every device)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAuthApi();
final LogoutDto logoutDto = ; // LogoutDto | 

try {
    api.authControllerLogout(logoutDto);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authControllerLogout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **logoutDto** | [**LogoutDto**](LogoutDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerMe**
> StaffProfileDto authControllerMe()

The signed-in staff member

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAuthApi();

try {
    final response = api.authControllerMe();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authControllerMe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**StaffProfileDto**](StaffProfileDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRefresh**
> SessionTokensDto authControllerRefresh(refreshDto)

Swap a refresh token for a new pair (rotation; reuse revokes the session)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAuthApi();
final RefreshDto refreshDto = ; // RefreshDto | 

try {
    final response = api.authControllerRefresh(refreshDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authControllerRefresh: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshDto** | [**RefreshDto**](RefreshDto.md)|  | 

### Return type

[**SessionTokensDto**](SessionTokensDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRequestOtp**
> OtpRequestedDto authControllerRequestOtp(otpRequestDto)

Send a 6-digit sign-in code by SMS (same answer for unknown numbers)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAuthApi();
final OtpRequestDto otpRequestDto = ; // OtpRequestDto | 

try {
    final response = api.authControllerRequestOtp(otpRequestDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authControllerRequestOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **otpRequestDto** | [**OtpRequestDto**](OtpRequestDto.md)|  | 

### Return type

[**OtpRequestedDto**](OtpRequestedDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRevokeSessions**
> RevokedCountDto authControllerRevokeSessions(staffId)

Sign a staff member out of every device (ADMIN)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAuthApi();
final String staffId = staffId_example; // String | 

try {
    final response = api.authControllerRevokeSessions(staffId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authControllerRevokeSessions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffId** | **String**|  | 

### Return type

[**RevokedCountDto**](RevokedCountDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerTestLogin**
> SessionTokensDto authControllerTestLogin(testLoginDto)

Development / test only: sign in without OTP. 404 in production.

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAuthApi();
final TestLoginDto testLoginDto = ; // TestLoginDto | 

try {
    final response = api.authControllerTestLogin(testLoginDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authControllerTestLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **testLoginDto** | [**TestLoginDto**](TestLoginDto.md)|  | 

### Return type

[**SessionTokensDto**](SessionTokensDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerVerifyOtp**
> SessionTokensDto authControllerVerifyOtp(otpVerifyDto)

Exchange the SMS code for tokens

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getAuthApi();
final OtpVerifyDto otpVerifyDto = ; // OtpVerifyDto | 

try {
    final response = api.authControllerVerifyOtp(otpVerifyDto);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authControllerVerifyOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **otpVerifyDto** | [**OtpVerifyDto**](OtpVerifyDto.md)|  | 

### Return type

[**SessionTokensDto**](SessionTokensDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

