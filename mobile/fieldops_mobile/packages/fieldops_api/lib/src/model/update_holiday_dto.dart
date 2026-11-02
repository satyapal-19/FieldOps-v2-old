//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_holiday_dto.g.dart';

/// UpdateHolidayDto
///
/// Properties:
/// * [expectedVersion] - The version you last read; stale versions get 409
/// * [date] 
/// * [name] 
/// * [nameMr] 
/// * [holidayType] 
@BuiltValue()
abstract class UpdateHolidayDto implements Built<UpdateHolidayDto, UpdateHolidayDtoBuilder> {
  /// The version you last read; stale versions get 409
  @BuiltValueField(wireName: r'expectedVersion')
  num get expectedVersion;

  @BuiltValueField(wireName: r'date')
  String? get date;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'nameMr')
  String? get nameMr;

  @BuiltValueField(wireName: r'holidayType')
  UpdateHolidayDtoHolidayTypeEnum? get holidayType;
  // enum holidayTypeEnum {  GAZETTE,  OPTIONAL,  };

  UpdateHolidayDto._();

  factory UpdateHolidayDto([void updates(UpdateHolidayDtoBuilder b)]) = _$UpdateHolidayDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateHolidayDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateHolidayDto> get serializer => _$UpdateHolidayDtoSerializer();
}

class _$UpdateHolidayDtoSerializer implements PrimitiveSerializer<UpdateHolidayDto> {
  @override
  final Iterable<Type> types = const [UpdateHolidayDto, _$UpdateHolidayDto];

  @override
  final String wireName = r'UpdateHolidayDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateHolidayDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expectedVersion';
    yield serializers.serialize(
      object.expectedVersion,
      specifiedType: const FullType(num),
    );
    if (object.date != null) {
      yield r'date';
      yield serializers.serialize(
        object.date,
        specifiedType: const FullType(String),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.nameMr != null) {
      yield r'nameMr';
      yield serializers.serialize(
        object.nameMr,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.holidayType != null) {
      yield r'holidayType';
      yield serializers.serialize(
        object.holidayType,
        specifiedType: const FullType(UpdateHolidayDtoHolidayTypeEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateHolidayDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateHolidayDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expectedVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.expectedVersion = valueDes;
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
            specifiedType: const FullType(UpdateHolidayDtoHolidayTypeEnum),
          ) as UpdateHolidayDtoHolidayTypeEnum;
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
  UpdateHolidayDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateHolidayDtoBuilder();
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

class UpdateHolidayDtoHolidayTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GAZETTE')
  static const UpdateHolidayDtoHolidayTypeEnum GAZETTE = _$updateHolidayDtoHolidayTypeEnum_GAZETTE;
  @BuiltValueEnumConst(wireName: r'OPTIONAL')
  static const UpdateHolidayDtoHolidayTypeEnum OPTIONAL = _$updateHolidayDtoHolidayTypeEnum_OPTIONAL;

  static Serializer<UpdateHolidayDtoHolidayTypeEnum> get serializer => _$updateHolidayDtoHolidayTypeEnumSerializer;

  const UpdateHolidayDtoHolidayTypeEnum._(String name): super(name);

  static BuiltSet<UpdateHolidayDtoHolidayTypeEnum> get values => _$updateHolidayDtoHolidayTypeEnumValues;
  static UpdateHolidayDtoHolidayTypeEnum valueOf(String name) => _$updateHolidayDtoHolidayTypeEnumValueOf(name);
}

