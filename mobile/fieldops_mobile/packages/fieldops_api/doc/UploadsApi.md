# fieldops_api.api.UploadsApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**uploadsControllerGet**](UploadsApi.md#uploadscontrollerget) | **GET** /api/v1/uploads/{id} | A photo, for its uploader and the people who review their work
[**uploadsControllerUpload**](UploadsApi.md#uploadscontrollerupload) | **POST** /api/v1/uploads | Upload a photo (task evidence); returns the key to send as photoKey


# **uploadsControllerGet**
> Uint8List uploadsControllerGet(id)

A photo, for its uploader and the people who review their work

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getUploadsApi();
final String id = id_example; // String | 

try {
    final response = api.uploadsControllerGet(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UploadsApi->uploadsControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/jpeg, image/png, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadsControllerUpload**
> UploadDto uploadsControllerUpload(file, clientUuid, kind)

Upload a photo (task evidence); returns the key to send as photoKey

Retry-safe with clientUuid. Stored on the FieldOps server only.

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getUploadsApi();
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | TASK_PHOTO: JPEG or PNG; VOICE_NOTE: M4A / AAC, Ogg or AMR
final String clientUuid = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String kind = kind_example; // String | 

try {
    final response = api.uploadsControllerUpload(file, clientUuid, kind);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UploadsApi->uploadsControllerUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **file** | **MultipartFile**| TASK_PHOTO: JPEG or PNG; VOICE_NOTE: M4A / AAC, Ogg or AMR | 
 **clientUuid** | **String**|  | 
 **kind** | **String**|  | 

### Return type

[**UploadDto**](UploadDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

