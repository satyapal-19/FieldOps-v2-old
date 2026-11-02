//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_tamper_event_dto.g.dart';

/// RouteTamperEventDto
///
/// Properties:
/// * [eventType] 
/// * [source_] 
/// * [startedAt] 
/// * [resolvedAt] 
@BuiltValue()
abstract class RouteTamperEventDto implements Built<RouteTamperEventDto, RouteTamperEventDtoBuilder> {
  @BuiltValueField(wireName: r'eventType')
  RouteTamperEventDtoEventTypeEnum get eventType;
  // enum eventTypeEnum {  GPS_DISABLED,  PERMISSION_REVOKED,  AIRPLANE_MODE,  DATA_DISABLED,  DEVICE_OFFLINE,  MOCK_LOCATION,  SILENT_GAP,  };

  @BuiltValueField(wireName: r'source')
  RouteTamperEventDtoSource_Enum get source_;
  // enum source_Enum {  DEVICE,  SERVER,  };

  @BuiltValueField(wireName: r'startedAt')
  DateTime get startedAt;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime? get resolvedAt;

  RouteTamperEventDto._();

  factory RouteTamperEventDto([void updates(RouteTamperEventDtoBuilder b)]) = _$RouteTamperEventDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteTamperEventDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteTamperEventDto> get serializer => _$RouteTamperEventDtoSerializer();
}

class _$RouteTamperEventDtoSerializer implements PrimitiveSerializer<RouteTamperEventDto> {
  @override
  final Iterable<Type> types = const [RouteTamperEventDto, _$RouteTamperEventDto];

  @override
  final String wireName = r'RouteTamperEventDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteTamperEventDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'eventType';
    yield serializers.serialize(
      object.eventType,
      specifiedType: const FullType(RouteTamperEventDtoEventTypeEnum),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(RouteTamperEventDtoSource_Enum),
    );
    yield r'startedAt';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'resolvedAt';
    yield object.resolvedAt == null ? null : serializers.serialize(
      object.resolvedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteTamperEventDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteTamperEventDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'eventType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteTamperEventDtoEventTypeEnum),
          ) as RouteTamperEventDtoEventTypeEnum;
          result.eventType = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteTamperEventDtoSource_Enum),
          ) as RouteTamperEventDtoSource_Enum;
          result.source_ = valueDes;
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
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteTamperEventDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteTamperEventDtoBuilder();
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

class RouteTamperEventDtoEventTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GPS_DISABLED')
  static const RouteTamperEventDtoEventTypeEnum GPS_DISABLED = _$routeTamperEventDtoEventTypeEnum_GPS_DISABLED;
  @BuiltValueEnumConst(wireName: r'PERMISSION_REVOKED')
  static const RouteTamperEventDtoEventTypeEnum PERMISSION_REVOKED = _$routeTamperEventDtoEventTypeEnum_PERMISSION_REVOKED;
  @BuiltValueEnumConst(wireName: r'AIRPLANE_MODE')
  static const RouteTamperEventDtoEventTypeEnum AIRPLANE_MODE = _$routeTamperEventDtoEventTypeEnum_AIRPLANE_MODE;
  @BuiltValueEnumConst(wireName: r'DATA_DISABLED')
  static const RouteTamperEventDtoEventTypeEnum DATA_DISABLED = _$routeTamperEventDtoEventTypeEnum_DATA_DISABLED;
  @BuiltValueEnumConst(wireName: r'DEVICE_OFFLINE')
  static const RouteTamperEventDtoEventTypeEnum DEVICE_OFFLINE = _$routeTamperEventDtoEventTypeEnum_DEVICE_OFFLINE;
  @BuiltValueEnumConst(wireName: r'MOCK_LOCATION')
  static const RouteTamperEventDtoEventTypeEnum MOCK_LOCATION = _$routeTamperEventDtoEventTypeEnum_MOCK_LOCATION;
  @BuiltValueEnumConst(wireName: r'SILENT_GAP')
  static const RouteTamperEventDtoEventTypeEnum SILENT_GAP = _$routeTamperEventDtoEventTypeEnum_SILENT_GAP;

  static Serializer<RouteTamperEventDtoEventTypeEnum> get serializer => _$routeTamperEventDtoEventTypeEnumSerializer;

  const RouteTamperEventDtoEventTypeEnum._(String name): super(name);

  static BuiltSet<RouteTamperEventDtoEventTypeEnum> get values => _$routeTamperEventDtoEventTypeEnumValues;
  static RouteTamperEventDtoEventTypeEnum valueOf(String name) => _$routeTamperEventDtoEventTypeEnumValueOf(name);
}

class RouteTamperEventDtoSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEVICE')
  static const RouteTamperEventDtoSource_Enum DEVICE = _$routeTamperEventDtoSourceEnum_DEVICE;
  @BuiltValueEnumConst(wireName: r'SERVER')
  static const RouteTamperEventDtoSource_Enum SERVER = _$routeTamperEventDtoSourceEnum_SERVER;

  static Serializer<RouteTamperEventDtoSource_Enum> get serializer => _$routeTamperEventDtoSourceEnumSerializer;

  const RouteTamperEventDtoSource_Enum._(String name): super(name);

  static BuiltSet<RouteTamperEventDtoSource_Enum> get values => _$routeTamperEventDtoSourceEnumValues;
  static RouteTamperEventDtoSource_Enum valueOf(String name) => _$routeTamperEventDtoSourceEnumValueOf(name);
}

