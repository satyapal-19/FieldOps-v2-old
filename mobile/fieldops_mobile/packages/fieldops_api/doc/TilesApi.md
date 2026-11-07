# fieldops_api.api.TilesApi

## Load the API package
```dart
import 'package:fieldops_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**tilesControllerManifest**](TilesApi.md#tilescontrollermanifest) | **GET** /api/v1/tiles/manifest | Whether an offline tile pack is installed, and its zooms and bounds
[**tilesControllerTile**](TilesApi.md#tilescontrollertile) | **GET** /api/v1/tiles/{z}/{x}/{y}.png | One map tile from the offline pack (404 when not in the pack)


# **tilesControllerManifest**
> TileManifestDto tilesControllerManifest()

Whether an offline tile pack is installed, and its zooms and bounds

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getTilesApi();

try {
    final response = api.tilesControllerManifest();
    print(response);
} catch on DioException (e) {
    print('Exception when calling TilesApi->tilesControllerManifest: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**TileManifestDto**](TileManifestDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tilesControllerTile**
> Uint8List tilesControllerTile(z, x, y)

One map tile from the offline pack (404 when not in the pack)

### Example
```dart
import 'package:fieldops_api/api.dart';

final api = FieldopsApi().getTilesApi();
final num z = 8.14; // num | 
final num x = 8.14; // num | 
final num y = 8.14; // num | 

try {
    final response = api.tilesControllerTile(z, x, y);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TilesApi->tilesControllerTile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **z** | **num**|  | 
 **x** | **num**|  | 
 **y** | **num**|  | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/png

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

