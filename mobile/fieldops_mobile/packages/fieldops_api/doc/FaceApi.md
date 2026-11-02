# fieldops_api.api.FaceApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**faceControllerCaptureOptions**](FaceApi.md#facecontrollercaptureoptions) | **GET** /api/v1/face/capture-options | Which face capture flow the app should run (local or Aadhaar FaceRD)


# **faceControllerCaptureOptions**
> FaceCaptureOptionsDto faceControllerCaptureOptions(staffId)

Which face capture flow the app should run (local or Aadhaar FaceRD)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getFaceApi();
final String staffId = staffId_example; // String | Who is being verified; defaults to the caller. Others only for inspectors and above (proxy marking).

try {
    final response = api.faceControllerCaptureOptions(staffId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling FaceApi->faceControllerCaptureOptions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffId** | **String**| Who is being verified; defaults to the caller. Others only for inspectors and above (proxy marking). | [optional] 

### Return type

[**FaceCaptureOptionsDto**](FaceCaptureOptionsDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

