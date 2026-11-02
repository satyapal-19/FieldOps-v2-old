//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'put_shift_dto.g.dart';

/// PutShiftDto
///
/// Properties:
/// * [staffId] 
/// * [date] - IST date, today up to 31 days ahead
/// * [shiftType] 
/// * [startTime] - IST, 24-hour HH:MM
/// * [endTime] - Before startTime only for NIGHT (ends next day)
/// * [expectedVersion] - Required when changing an existing override
@BuiltValue()
abstract class PutShiftDto implements Built<PutShiftDto, PutShiftDtoBuilder> {
  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  /// IST date, today up to 31 days ahead
  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'shiftType')
  PutShiftDtoShiftTypeEnum get shiftType;
  // enum shiftTypeEnum {  MORNING,  EVENING,  NIGHT,  GENERAL_OFFICE,  };

  /// IST, 24-hour HH:MM
  @BuiltValueField(wireName: r'startTime')
  String get startTime;

  /// Before startTime only for NIGHT (ends next day)
  @BuiltValueField(wireName: r'endTime')
  String get endTime;

  /// Required when changing an existing override
  @BuiltValueField(wireName: r'expectedVersion')
  num? get expectedVersion;

  PutShiftDto._();

  factory PutShiftDto([void updates(PutShiftDtoBuilder b)]) = _$PutShiftDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PutShiftDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PutShiftDto> get serializer => _$PutShiftDtoSerializer();
}

class _$PutShiftDtoSerializer implements PrimitiveSerializer<PutShiftDto> {
  @override
  final Iterable<Type> types = const [PutShiftDto, _$PutShiftDto];

  @override
  final String wireName = r'PutShiftDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PutShiftDto object, {
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
    yield serializers.serialize(
      object.shiftType,
      specifiedType: const FullType(PutShiftDtoShiftTypeEnum),
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
    if (object.expectedVersion != null) {
      yield r'expectedVersion';
      yield serializers.serialize(
        object.expectedVersion,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PutShiftDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PutShiftDtoBuilder result,
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
            specifiedType: const FullType(PutShiftDtoShiftTypeEnum),
          ) as PutShiftDtoShiftTypeEnum;
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
        case r'expectedVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.expectedVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PutShiftDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PutShiftDtoBuilder();
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

class PutShiftDtoShiftTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MORNING')
  static const PutShiftDtoShiftTypeEnum MORNING = _$putShiftDtoShiftTypeEnum_MORNING;
  @BuiltValueEnumConst(wireName: r'EVENING')
  static const PutShiftDtoShiftTypeEnum EVENING = _$putShiftDtoShiftTypeEnum_EVENING;
  @BuiltValueEnumConst(wireName: r'NIGHT')
  static const PutShiftDtoShiftTypeEnum NIGHT = _$putShiftDtoShiftTypeEnum_NIGHT;
  @BuiltValueEnumConst(wireName: r'GENERAL_OFFICE')
  static const PutShiftDtoShiftTypeEnum GENERAL_OFFICE = _$putShiftDtoShiftTypeEnum_GENERAL_OFFICE;

  static Serializer<PutShiftDtoShiftTypeEnum> get serializer => _$putShiftDtoShiftTypeEnumSerializer;

  const PutShiftDtoShiftTypeEnum._(String name): super(name);

  static BuiltSet<PutShiftDtoShiftTypeEnum> get values => _$putShiftDtoShiftTypeEnumValues;
  static PutShiftDtoShiftTypeEnum valueOf(String name) => _$putShiftDtoShiftTypeEnumValueOf(name);
}

