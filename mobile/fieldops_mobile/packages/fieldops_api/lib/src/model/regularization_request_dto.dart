//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'regularization_request_dto.g.dart';

/// RegularizationRequestDto
///
/// Properties:
/// * [id] 
/// * [staffId] 
/// * [status] 
/// * [reviewedById] 
/// * [reviewedAt] 
/// * [reviewNote] 
/// * [version] 
/// * [createdAt] 
/// * [attendanceDate] 
/// * [reasonType] 
/// * [explanation] 
@BuiltValue()
abstract class RegularizationRequestDto implements Built<RegularizationRequestDto, RegularizationRequestDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  @BuiltValueField(wireName: r'status')
  RegularizationRequestDtoStatusEnum get status;
  // enum statusEnum {  PENDING,  APPROVED,  REJECTED,  CANCELLED,  };

  @BuiltValueField(wireName: r'reviewedById')
  String? get reviewedById;

  @BuiltValueField(wireName: r'reviewedAt')
  DateTime? get reviewedAt;

  @BuiltValueField(wireName: r'reviewNote')
  String? get reviewNote;

  @BuiltValueField(wireName: r'version')
  num get version;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'attendanceDate')
  String get attendanceDate;

  @BuiltValueField(wireName: r'reasonType')
  RegularizationRequestDtoReasonTypeEnum get reasonType;
  // enum reasonTypeEnum {  BATTERY_DEAD,  APP_CRASH,  FIELD_RESCUE_DUTY,  OUT_OF_NETWORK,  OTHER,  };

  @BuiltValueField(wireName: r'explanation')
  String get explanation;

  RegularizationRequestDto._();

  factory RegularizationRequestDto([void updates(RegularizationRequestDtoBuilder b)]) = _$RegularizationRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegularizationRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegularizationRequestDto> get serializer => _$RegularizationRequestDtoSerializer();
}

class _$RegularizationRequestDtoSerializer implements PrimitiveSerializer<RegularizationRequestDto> {
  @override
  final Iterable<Type> types = const [RegularizationRequestDto, _$RegularizationRequestDto];

  @override
  final String wireName = r'RegularizationRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegularizationRequestDto object, {
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(RegularizationRequestDtoStatusEnum),
    );
    yield r'reviewedById';
    yield object.reviewedById == null ? null : serializers.serialize(
      object.reviewedById,
      specifiedType: const FullType.nullable(String),
    );
    yield r'reviewedAt';
    yield object.reviewedAt == null ? null : serializers.serialize(
      object.reviewedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'reviewNote';
    yield object.reviewNote == null ? null : serializers.serialize(
      object.reviewNote,
      specifiedType: const FullType.nullable(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(num),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'attendanceDate';
    yield serializers.serialize(
      object.attendanceDate,
      specifiedType: const FullType(String),
    );
    yield r'reasonType';
    yield serializers.serialize(
      object.reasonType,
      specifiedType: const FullType(RegularizationRequestDtoReasonTypeEnum),
    );
    yield r'explanation';
    yield serializers.serialize(
      object.explanation,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RegularizationRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegularizationRequestDtoBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegularizationRequestDtoStatusEnum),
          ) as RegularizationRequestDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'reviewedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reviewedById = valueDes;
          break;
        case r'reviewedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.reviewedAt = valueDes;
          break;
        case r'reviewNote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reviewNote = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.version = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'attendanceDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.attendanceDate = valueDes;
          break;
        case r'reasonType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegularizationRequestDtoReasonTypeEnum),
          ) as RegularizationRequestDtoReasonTypeEnum;
          result.reasonType = valueDes;
          break;
        case r'explanation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.explanation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegularizationRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegularizationRequestDtoBuilder();
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

class RegularizationRequestDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const RegularizationRequestDtoStatusEnum PENDING = _$regularizationRequestDtoStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const RegularizationRequestDtoStatusEnum APPROVED = _$regularizationRequestDtoStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const RegularizationRequestDtoStatusEnum REJECTED = _$regularizationRequestDtoStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const RegularizationRequestDtoStatusEnum CANCELLED = _$regularizationRequestDtoStatusEnum_CANCELLED;

  static Serializer<RegularizationRequestDtoStatusEnum> get serializer => _$regularizationRequestDtoStatusEnumSerializer;

  const RegularizationRequestDtoStatusEnum._(String name): super(name);

  static BuiltSet<RegularizationRequestDtoStatusEnum> get values => _$regularizationRequestDtoStatusEnumValues;
  static RegularizationRequestDtoStatusEnum valueOf(String name) => _$regularizationRequestDtoStatusEnumValueOf(name);
}

class RegularizationRequestDtoReasonTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BATTERY_DEAD')
  static const RegularizationRequestDtoReasonTypeEnum BATTERY_DEAD = _$regularizationRequestDtoReasonTypeEnum_BATTERY_DEAD;
  @BuiltValueEnumConst(wireName: r'APP_CRASH')
  static const RegularizationRequestDtoReasonTypeEnum APP_CRASH = _$regularizationRequestDtoReasonTypeEnum_APP_CRASH;
  @BuiltValueEnumConst(wireName: r'FIELD_RESCUE_DUTY')
  static const RegularizationRequestDtoReasonTypeEnum FIELD_RESCUE_DUTY = _$regularizationRequestDtoReasonTypeEnum_FIELD_RESCUE_DUTY;
  @BuiltValueEnumConst(wireName: r'OUT_OF_NETWORK')
  static const RegularizationRequestDtoReasonTypeEnum OUT_OF_NETWORK = _$regularizationRequestDtoReasonTypeEnum_OUT_OF_NETWORK;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const RegularizationRequestDtoReasonTypeEnum OTHER = _$regularizationRequestDtoReasonTypeEnum_OTHER;

  static Serializer<RegularizationRequestDtoReasonTypeEnum> get serializer => _$regularizationRequestDtoReasonTypeEnumSerializer;

  const RegularizationRequestDtoReasonTypeEnum._(String name): super(name);

  static BuiltSet<RegularizationRequestDtoReasonTypeEnum> get values => _$regularizationRequestDtoReasonTypeEnumValues;
  static RegularizationRequestDtoReasonTypeEnum valueOf(String name) => _$regularizationRequestDtoReasonTypeEnumValueOf(name);
}

