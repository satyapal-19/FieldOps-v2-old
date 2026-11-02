//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'effective_shift_dto.g.dart';

/// EffectiveShiftDto
///
/// Properties:
/// * [staffId] 
/// * [date] 
/// * [shiftType] 
/// * [startTime] 
/// * [endTime] 
/// * [startsAt] - UTC
/// * [endsAt] - UTC; next day for overnight shifts
/// * [source_] 
@BuiltValue()
abstract class EffectiveShiftDto implements Built<EffectiveShiftDto, EffectiveShiftDtoBuilder> {
  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'shiftType')
  EffectiveShiftDtoShiftTypeEnum? get shiftType;
  // enum shiftTypeEnum {  MORNING,  EVENING,  NIGHT,  GENERAL_OFFICE,  };

  @BuiltValueField(wireName: r'startTime')
  String get startTime;

  @BuiltValueField(wireName: r'endTime')
  String get endTime;

  /// UTC
  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  /// UTC; next day for overnight shifts
  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  @BuiltValueField(wireName: r'source')
  EffectiveShiftDtoSource_Enum get source_;
  // enum source_Enum {  OVERRIDE,  DEFAULT,  };

  EffectiveShiftDto._();

  factory EffectiveShiftDto([void updates(EffectiveShiftDtoBuilder b)]) = _$EffectiveShiftDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EffectiveShiftDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EffectiveShiftDto> get serializer => _$EffectiveShiftDtoSerializer();
}

class _$EffectiveShiftDtoSerializer implements PrimitiveSerializer<EffectiveShiftDto> {
  @override
  final Iterable<Type> types = const [EffectiveShiftDto, _$EffectiveShiftDto];

  @override
  final String wireName = r'EffectiveShiftDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EffectiveShiftDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'staffId';
    yield serializers.serialize(
      object.staffId,
      specifiedType: const FullType(String),
    );
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
    yield r'shiftType';
    yield object.shiftType == null ? null : serializers.serialize(
      object.shiftType,
      specifiedType: const FullType.nullable(EffectiveShiftDtoShiftTypeEnum),
    );
    yield r'startTime';
    yield serializers.serialize(
      object.startTime,
      specifiedType: const FullType(String),
    );
    yield r'endTime';
    yield serializers.serialize(
      object.endTime,
      specifiedType: const FullType(String),
    );
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(EffectiveShiftDtoSource_Enum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EffectiveShiftDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EffectiveShiftDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'staffId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.staffId = valueDes;
          break;
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        case r'shiftType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(EffectiveShiftDtoShiftTypeEnum),
          ) as EffectiveShiftDtoShiftTypeEnum?;
          if (valueDes == null) continue;
          result.shiftType = valueDes;
          break;
        case r'startTime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.startTime = valueDes;
          break;
        case r'endTime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.endTime = valueDes;
          break;
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        case r'endsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endsAt = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EffectiveShiftDtoSource_Enum),
          ) as EffectiveShiftDtoSource_Enum;
          result.source_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EffectiveShiftDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EffectiveShiftDtoBuilder();
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

class EffectiveShiftDtoShiftTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MORNING')
  static const EffectiveShiftDtoShiftTypeEnum MORNING = _$effectiveShiftDtoShiftTypeEnum_MORNING;
  @BuiltValueEnumConst(wireName: r'EVENING')
  static const EffectiveShiftDtoShiftTypeEnum EVENING = _$effectiveShiftDtoShiftTypeEnum_EVENING;
  @BuiltValueEnumConst(wireName: r'NIGHT')
  static const EffectiveShiftDtoShiftTypeEnum NIGHT = _$effectiveShiftDtoShiftTypeEnum_NIGHT;
  @BuiltValueEnumConst(wireName: r'GENERAL_OFFICE')
  static const EffectiveShiftDtoShiftTypeEnum GENERAL_OFFICE = _$effectiveShiftDtoShiftTypeEnum_GENERAL_OFFICE;

  static Serializer<EffectiveShiftDtoShiftTypeEnum> get serializer => _$effectiveShiftDtoShiftTypeEnumSerializer;

  const EffectiveShiftDtoShiftTypeEnum._(String name): super(name);

  static BuiltSet<EffectiveShiftDtoShiftTypeEnum> get values => _$effectiveShiftDtoShiftTypeEnumValues;
  static EffectiveShiftDtoShiftTypeEnum valueOf(String name) => _$effectiveShiftDtoShiftTypeEnumValueOf(name);
}

class EffectiveShiftDtoSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OVERRIDE')
  static const EffectiveShiftDtoSource_Enum OVERRIDE = _$effectiveShiftDtoSourceEnum_OVERRIDE;
  @BuiltValueEnumConst(wireName: r'DEFAULT')
  static const EffectiveShiftDtoSource_Enum DEFAULT = _$effectiveShiftDtoSourceEnum_DEFAULT;

  static Serializer<EffectiveShiftDtoSource_Enum> get serializer => _$effectiveShiftDtoSourceEnumSerializer;

  const EffectiveShiftDtoSource_Enum._(String name): super(name);

  static BuiltSet<EffectiveShiftDtoSource_Enum> get values => _$effectiveShiftDtoSourceEnumValues;
  static EffectiveShiftDtoSource_Enum valueOf(String name) => _$effectiveShiftDtoSourceEnumValueOf(name);
}

