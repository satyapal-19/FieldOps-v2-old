//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'app_info_dto.g.dart';

/// AppInfoDto
///
/// Properties:
/// * [minVersionCode] - Android versionCode below which the app must update before use
/// * [latestVersionCode] - Newest versionCode; above the minimum the update is optional
/// * [updateUrl] 
/// * [faceProvider] - Which face capture flow to prepare
/// * [pingIntervalSeconds] - Seconds between location pings while on duty
/// * [silentGapMinutes] - No ping for this long during a shift raises a silent-gap alert
/// * [serverTime] - Server time (UTC): the app shows a wrong phone clock
@BuiltValue()
abstract class AppInfoDto implements Built<AppInfoDto, AppInfoDtoBuilder> {
  /// Android versionCode below which the app must update before use
  @BuiltValueField(wireName: r'minVersionCode')
  num get minVersionCode;

  /// Newest versionCode; above the minimum the update is optional
  @BuiltValueField(wireName: r'latestVersionCode')
  num get latestVersionCode;

  @BuiltValueField(wireName: r'updateUrl')
  String? get updateUrl;

  /// Which face capture flow to prepare
  @BuiltValueField(wireName: r'faceProvider')
  AppInfoDtoFaceProviderEnum get faceProvider;
  // enum faceProviderEnum {  local,  aadhaar,  };

  /// Seconds between location pings while on duty
  @BuiltValueField(wireName: r'pingIntervalSeconds')
  num get pingIntervalSeconds;

  /// No ping for this long during a shift raises a silent-gap alert
  @BuiltValueField(wireName: r'silentGapMinutes')
  num get silentGapMinutes;

  /// Server time (UTC): the app shows a wrong phone clock
  @BuiltValueField(wireName: r'serverTime')
  DateTime get serverTime;

  AppInfoDto._();

  factory AppInfoDto([void updates(AppInfoDtoBuilder b)]) = _$AppInfoDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AppInfoDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AppInfoDto> get serializer => _$AppInfoDtoSerializer();
}

class _$AppInfoDtoSerializer implements PrimitiveSerializer<AppInfoDto> {
  @override
  final Iterable<Type> types = const [AppInfoDto, _$AppInfoDto];

  @override
  final String wireName = r'AppInfoDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AppInfoDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'minVersionCode';
    yield serializers.serialize(
      object.minVersionCode,
      specifiedType: const FullType(num),
    );
    yield r'latestVersionCode';
    yield serializers.serialize(
      object.latestVersionCode,
      specifiedType: const FullType(num),
    );
    if (object.updateUrl != null) {
      yield r'updateUrl';
      yield serializers.serialize(
        object.updateUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'faceProvider';
    yield serializers.serialize(
      object.faceProvider,
      specifiedType: const FullType(AppInfoDtoFaceProviderEnum),
    );
    yield r'pingIntervalSeconds';
    yield serializers.serialize(
      object.pingIntervalSeconds,
      specifiedType: const FullType(num),
    );
    yield r'silentGapMinutes';
    yield serializers.serialize(
      object.silentGapMinutes,
      specifiedType: const FullType(num),
    );
    yield r'serverTime';
    yield serializers.serialize(
      object.serverTime,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AppInfoDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AppInfoDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'minVersionCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.minVersionCode = valueDes;
          break;
        case r'latestVersionCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latestVersionCode = valueDes;
          break;
        case r'updateUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.updateUrl = valueDes;
          break;
        case r'faceProvider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AppInfoDtoFaceProviderEnum),
          ) as AppInfoDtoFaceProviderEnum;
          result.faceProvider = valueDes;
          break;
        case r'pingIntervalSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.pingIntervalSeconds = valueDes;
          break;
        case r'silentGapMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.silentGapMinutes = valueDes;
          break;
        case r'serverTime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.serverTime = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AppInfoDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AppInfoDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class AppInfoDtoFaceProviderEnum extends EnumClass {

  /// Which face capture flow to prepare
  @BuiltValueEnumConst(wireName: r'local')
  static const AppInfoDtoFaceProviderEnum local = _$appInfoDtoFaceProviderEnum_local;
  /// Which face capture flow to prepare
  @BuiltValueEnumConst(wireName: r'aadhaar')
  static const AppInfoDtoFaceProviderEnum aadhaar = _$appInfoDtoFaceProviderEnum_aadhaar;

  static Serializer<AppInfoDtoFaceProviderEnum> get serializer => _$appInfoDtoFaceProviderEnumSerializer;

  const AppInfoDtoFaceProviderEnum._(String name): super(name);

  static BuiltSet<AppInfoDtoFaceProviderEnum> get values => _$appInfoDtoFaceProviderEnumValues;
  static AppInfoDtoFaceProviderEnum valueOf(String name) => _$appInfoDtoFaceProviderEnumValueOf(name);
}

