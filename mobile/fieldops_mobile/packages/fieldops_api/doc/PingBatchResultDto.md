# fieldops_api.model.PingBatchResultDto

## Load the model package
```dart
import 'package:fieldops_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**accepted** | **num** | New pings stored | 
**duplicates** | **num** | Already stored earlier (safe retries) | 
**rejected** | [**BuiltList&lt;RejectedItemDto&gt;**](RejectedItemDto.md) | Dropped; do not resend these | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


