//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'holiday_dto.g.dart';

/// HolidayDto
///
/// Properties:
/// * [id] 
/// * [date] 
/// * [name] 
/// * [nameMr] 
/// * [holidayType] 
/// * [version] 
@BuiltValue()
abstract class HolidayDto implements Built<HolidayDto, HolidayDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'nameMr')
  String? get nameMr;

  @BuiltValueField(wireName: r'holidayType')
  HolidayDtoHolidayTypeEnum get holidayType;
  // enum holidayTypeEnum {  GAZETTE,  OPTIONAL,  };

  @BuiltValueField(wireName: r'version')
  num get version;

  HolidayDto._();

  factory HolidayDto([void updates(HolidayDtoBuilder b)]) = _$HolidayDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HolidayDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HolidayDto> get serializer => _$HolidayDtoSerializer();
}

class _$HolidayDtoSerializer implements PrimitiveSerializer<HolidayDto> {
  @override
  final Iterable<Type> types = const [HolidayDto, _$HolidayDto];

  @override
  final String wireName = r'HolidayDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HolidayDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'nameMr';
    yield object.nameMr == null ? null : serializers.serialize(
      object.nameMr,
      specifiedType: const FullType.nullable(String),
    );
    yield r'holidayType';
    yield serializers.serialize(
      object.holidayType,
      specifiedType: const FullType(HolidayDtoHolidayTypeEnum),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    HolidayDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required HolidayDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'nameMr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nameMr = valueDes;
          break;
        case r'holidayType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(HolidayDtoHolidayTypeEnum),
          ) as HolidayDtoHolidayTypeEnum;
          result.holidayType = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HolidayDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HolidayDtoBuilder();
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

class HolidayDtoHolidayTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GAZETTE')
  static const HolidayDtoHolidayTypeEnum GAZETTE = _$holidayDtoHolidayTypeEnum_GAZETTE;
  @BuiltValueEnumConst(wireName: r'OPTIONAL')
  static const HolidayDtoHolidayTypeEnum OPTIONAL = _$holidayDtoHolidayTypeEnum_OPTIONAL;

  static Serializer<HolidayDtoHolidayTypeEnum> get serializer => _$holidayDtoHolidayTypeEnumSerializer;

  const HolidayDtoHolidayTypeEnum._(String name): super(name);

  static BuiltSet<HolidayDtoHolidayTypeEnum> get values => _$holidayDtoHolidayTypeEnumValues;
  static HolidayDtoHolidayTypeEnum valueOf(String name) => _$holidayDtoHolidayTypeEnumValueOf(name);
}

