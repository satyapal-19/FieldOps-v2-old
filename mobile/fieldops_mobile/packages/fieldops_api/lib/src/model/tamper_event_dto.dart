//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tamper_event_dto.g.dart';

/// TamperEventDto
///
/// Properties:
/// * [clientUuid] - Idempotency key; resend with resolvedAt once over
/// * [eventType] 
/// * [startedAt] 
/// * [resolvedAt] 
/// * [lastLatitude] 
/// * [lastLongitude] 
@BuiltValue()
abstract class TamperEventDto implements Built<TamperEventDto, TamperEventDtoBuilder> {
  /// Idempotency key; resend with resolvedAt once over
  @BuiltValueField(wireName: r'clientUuid')
  String get clientUuid;

  @BuiltValueField(wireName: r'eventType')
  TamperEventDtoEventTypeEnum get eventType;
  // enum eventTypeEnum {  GPS_DISABLED,  PERMISSION_REVOKED,  AIRPLANE_MODE,  DATA_DISABLED,  DEVICE_OFFLINE,  MOCK_LOCATION,  };

  @BuiltValueField(wireName: r'startedAt')
  DateTime get startedAt;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime? get resolvedAt;

  @BuiltValueField(wireName: r'lastLatitude')
  num? get lastLatitude;

  @BuiltValueField(wireName: r'lastLongitude')
  num? get lastLongitude;

  TamperEventDto._();

  factory TamperEventDto([void updates(TamperEventDtoBuilder b)]) = _$TamperEventDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TamperEventDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TamperEventDto> get serializer => _$TamperEventDtoSerializer();
}

class _$TamperEventDtoSerializer implements PrimitiveSerializer<TamperEventDto> {
  @override
  final Iterable<Type> types = const [TamperEventDto, _$TamperEventDto];

  @override
  final String wireName = r'TamperEventDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TamperEventDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clientUuid';
    yield serializers.serialize(
      object.clientUuid,
      specifiedType: const FullType(String),
    );
    yield r'eventType';
    yield serializers.serialize(
      object.eventType,
      specifiedType: const FullType(TamperEventDtoEventTypeEnum),
    );
    yield r'startedAt';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.resolvedAt != null) {
      yield r'resolvedAt';
      yield serializers.serialize(
        object.resolvedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.lastLatitude != null) {
      yield r'lastLatitude';
      yield serializers.serialize(
        object.lastLatitude,
        specifiedType: const FullType(num),
      );
    }
    if (object.lastLongitude != null) {
      yield r'lastLongitude';
      yield serializers.serialize(
        object.lastLongitude,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TamperEventDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TamperEventDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clientUuid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientUuid = valueDes;
          break;
        case r'eventType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TamperEventDtoEventTypeEnum),
          ) as TamperEventDtoEventTypeEnum;
          result.eventType = valueDes;
          break;
        case r'startedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        case r'resolvedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.resolvedAt = valueDes;
          break;
        case r'lastLatitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lastLatitude = valueDes;
          break;
        case r'lastLongitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lastLongitude = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TamperEventDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TamperEventDtoBuilder();
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

class TamperEventDtoEventTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GPS_DISABLED')
  static const TamperEventDtoEventTypeEnum GPS_DISABLED = _$tamperEventDtoEventTypeEnum_GPS_DISABLED;
  @BuiltValueEnumConst(wireName: r'PERMISSION_REVOKED')
  static const TamperEventDtoEventTypeEnum PERMISSION_REVOKED = _$tamperEventDtoEventTypeEnum_PERMISSION_REVOKED;
  @BuiltValueEnumConst(wireName: r'AIRPLANE_MODE')
  static const TamperEventDtoEventTypeEnum AIRPLANE_MODE = _$tamperEventDtoEventTypeEnum_AIRPLANE_MODE;
  @BuiltValueEnumConst(wireName: r'DATA_DISABLED')
  static const TamperEventDtoEventTypeEnum DATA_DISABLED = _$tamperEventDtoEventTypeEnum_DATA_DISABLED;
  @BuiltValueEnumConst(wireName: r'DEVICE_OFFLINE')
  static const TamperEventDtoEventTypeEnum DEVICE_OFFLINE = _$tamperEventDtoEventTypeEnum_DEVICE_OFFLINE;
  @BuiltValueEnumConst(wireName: r'MOCK_LOCATION')
  static const TamperEventDtoEventTypeEnum MOCK_LOCATION = _$tamperEventDtoEventTypeEnum_MOCK_LOCATION;

  static Serializer<TamperEventDtoEventTypeEnum> get serializer => _$tamperEventDtoEventTypeEnumSerializer;

  const TamperEventDtoEventTypeEnum._(String name): super(name);

  static BuiltSet<TamperEventDtoEventTypeEnum> get values => _$tamperEventDtoEventTypeEnumValues;
  static TamperEventDtoEventTypeEnum valueOf(String name) => _$tamperEventDtoEventTypeEnumValueOf(name);
}

