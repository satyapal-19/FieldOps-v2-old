//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_holiday_dto.g.dart';

/// CreateHolidayDto
///
/// Properties:
/// * [date] - IST date, today or later
/// * [name] 
/// * [nameMr] 
/// * [holidayType] 
@BuiltValue()
abstract class CreateHolidayDto implements Built<CreateHolidayDto, CreateHolidayDtoBuilder> {
  /// IST date, today or later
  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'nameMr')
  String? get nameMr;

  @BuiltValueField(wireName: r'holidayType')
  CreateHolidayDtoHolidayTypeEnum? get holidayType;
  // enum holidayTypeEnum {  GAZETTE,  OPTIONAL,  };

  CreateHolidayDto._();

  factory CreateHolidayDto([void updates(CreateHolidayDtoBuilder b)]) = _$CreateHolidayDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateHolidayDtoBuilder b) => b
      ..holidayType = const CreateHolidayDtoHolidayTypeEnum._('GAZETTE');

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateHolidayDto> get serializer => _$CreateHolidayDtoSerializer();
}

class _$CreateHolidayDtoSerializer implements PrimitiveSerializer<CreateHolidayDto> {
  @override
  final Iterable<Type> types = const [CreateHolidayDto, _$CreateHolidayDto];

  @override
  final String wireName = r'CreateHolidayDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateHolidayDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.nameMr != null) {
      yield r'nameMr';
      yield serializers.serialize(
        object.nameMr,
        specifiedType: const FullType(String),
      );
    }
    if (object.holidayType != null) {
      yield r'holidayType';
      yield serializers.serialize(
        object.holidayType,
        specifiedType: const FullType(CreateHolidayDtoHolidayTypeEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateHolidayDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateHolidayDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(String),
          ) as String;
          result.nameMr = valueDes;
          break;
        case r'holidayType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateHolidayDtoHolidayTypeEnum),
          ) as CreateHolidayDtoHolidayTypeEnum;
          result.holidayType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateHolidayDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateHolidayDtoBuilder();
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

class CreateHolidayDtoHolidayTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GAZETTE')
  static const CreateHolidayDtoHolidayTypeEnum GAZETTE = _$createHolidayDtoHolidayTypeEnum_GAZETTE;
  @BuiltValueEnumConst(wireName: r'OPTIONAL')
  static const CreateHolidayDtoHolidayTypeEnum OPTIONAL = _$createHolidayDtoHolidayTypeEnum_OPTIONAL;

  static Serializer<CreateHolidayDtoHolidayTypeEnum> get serializer => _$createHolidayDtoHolidayTypeEnumSerializer;

  const CreateHolidayDtoHolidayTypeEnum._(String name): super(name);

  static BuiltSet<CreateHolidayDtoHolidayTypeEnum> get values => _$createHolidayDtoHolidayTypeEnumValues;
  static CreateHolidayDtoHolidayTypeEnum valueOf(String name) => _$createHolidayDtoHolidayTypeEnumValueOf(name);
}

