//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'shift_dto.g.dart';

/// ShiftDto
///
/// Properties:
/// * [id] 
/// * [staffId] 
/// * [date] 
/// * [shiftType] 
/// * [startTime] 
/// * [endTime] 
/// * [version] 
/// * [updatedAt] 
@BuiltValue()
abstract class ShiftDto implements Built<ShiftDto, ShiftDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'shiftType')
  ShiftDtoShiftTypeEnum get shiftType;
  // enum shiftTypeEnum {  MORNING,  EVENING,  NIGHT,  GENERAL_OFFICE,  };

  @BuiltValueField(wireName: r'startTime')
  String get startTime;

  @BuiltValueField(wireName: r'endTime')
  String get endTime;

  @BuiltValueField(wireName: r'version')
  num get version;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  ShiftDto._();

  factory ShiftDto([void updates(ShiftDtoBuilder b)]) = _$ShiftDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ShiftDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ShiftDto> get serializer => _$ShiftDtoSerializer();
}

class _$ShiftDtoSerializer implements PrimitiveSerializer<ShiftDto> {
  @override
  final Iterable<Type> types = const [ShiftDto, _$ShiftDto];

  @override
  final String wireName = r'ShiftDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ShiftDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield serializers.serialize(
      object.shiftType,
      specifiedType: const FullType(ShiftDtoShiftTypeEnum),
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
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(num),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ShiftDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ShiftDtoBuilder result,
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
            specifiedType: const FullType(ShiftDtoShiftTypeEnum),
          ) as ShiftDtoShiftTypeEnum;
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
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.version = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ShiftDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ShiftDtoBuilder();
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

class ShiftDtoShiftTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MORNING')
  static const ShiftDtoShiftTypeEnum MORNING = _$shiftDtoShiftTypeEnum_MORNING;
  @BuiltValueEnumConst(wireName: r'EVENING')
  static const ShiftDtoShiftTypeEnum EVENING = _$shiftDtoShiftTypeEnum_EVENING;
  @BuiltValueEnumConst(wireName: r'NIGHT')
  static const ShiftDtoShiftTypeEnum NIGHT = _$shiftDtoShiftTypeEnum_NIGHT;
  @BuiltValueEnumConst(wireName: r'GENERAL_OFFICE')
  static const ShiftDtoShiftTypeEnum GENERAL_OFFICE = _$shiftDtoShiftTypeEnum_GENERAL_OFFICE;

  static Serializer<ShiftDtoShiftTypeEnum> get serializer => _$shiftDtoShiftTypeEnumSerializer;

  const ShiftDtoShiftTypeEnum._(String name): super(name);

  static BuiltSet<ShiftDtoShiftTypeEnum> get values => _$shiftDtoShiftTypeEnumValues;
  static ShiftDtoShiftTypeEnum valueOf(String name) => _$shiftDtoShiftTypeEnumValueOf(name);
}

