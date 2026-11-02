//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_leave_dto.g.dart';

/// CreateLeaveDto
///
/// Properties:
/// * [clientUuid] - Idempotency key from the phone; a retry returns the same request
/// * [leaveType] 
/// * [fromDate] - IST date; today or later (SICK: up to 7 days back)
/// * [toDate] - Inclusive; at most 31 days in one request
/// * [reason] 
@BuiltValue()
abstract class CreateLeaveDto implements Built<CreateLeaveDto, CreateLeaveDtoBuilder> {
  /// Idempotency key from the phone; a retry returns the same request
  @BuiltValueField(wireName: r'clientUuid')
  String? get clientUuid;

  @BuiltValueField(wireName: r'leaveType')
  CreateLeaveDtoLeaveTypeEnum get leaveType;
  // enum leaveTypeEnum {  CASUAL,  SICK,  EARNED,  WEEKLY_OFF,  };

  /// IST date; today or later (SICK: up to 7 days back)
  @BuiltValueField(wireName: r'fromDate')
  String get fromDate;

  /// Inclusive; at most 31 days in one request
  @BuiltValueField(wireName: r'toDate')
  String get toDate;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  CreateLeaveDto._();

  factory CreateLeaveDto([void updates(CreateLeaveDtoBuilder b)]) = _$CreateLeaveDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateLeaveDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateLeaveDto> get serializer => _$CreateLeaveDtoSerializer();
}

class _$CreateLeaveDtoSerializer implements PrimitiveSerializer<CreateLeaveDto> {
  @override
  final Iterable<Type> types = const [CreateLeaveDto, _$CreateLeaveDto];

  @override
  final String wireName = r'CreateLeaveDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateLeaveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.clientUuid != null) {
      yield r'clientUuid';
      yield serializers.serialize(
        object.clientUuid,
        specifiedType: const FullType(String),
      );
    }
    yield r'leaveType';
    yield serializers.serialize(
      object.leaveType,
      specifiedType: const FullType(CreateLeaveDtoLeaveTypeEnum),
    );
    yield r'fromDate';
    yield serializers.serialize(
      object.fromDate,
      specifiedType: const FullType(String),
    );
    yield r'toDate';
    yield serializers.serialize(
      object.toDate,
      specifiedType: const FullType(String),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateLeaveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateLeaveDtoBuilder result,
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
        case r'leaveType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateLeaveDtoLeaveTypeEnum),
          ) as CreateLeaveDtoLeaveTypeEnum;
          result.leaveType = valueDes;
          break;
        case r'fromDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fromDate = valueDes;
          break;
        case r'toDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.toDate = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateLeaveDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateLeaveDtoBuilder();
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

class CreateLeaveDtoLeaveTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CASUAL')
  static const CreateLeaveDtoLeaveTypeEnum CASUAL = _$createLeaveDtoLeaveTypeEnum_CASUAL;
  @BuiltValueEnumConst(wireName: r'SICK')
  static const CreateLeaveDtoLeaveTypeEnum SICK = _$createLeaveDtoLeaveTypeEnum_SICK;
  @BuiltValueEnumConst(wireName: r'EARNED')
  static const CreateLeaveDtoLeaveTypeEnum EARNED = _$createLeaveDtoLeaveTypeEnum_EARNED;
  @BuiltValueEnumConst(wireName: r'WEEKLY_OFF')
  static const CreateLeaveDtoLeaveTypeEnum WEEKLY_OFF = _$createLeaveDtoLeaveTypeEnum_WEEKLY_OFF;

  static Serializer<CreateLeaveDtoLeaveTypeEnum> get serializer => _$createLeaveDtoLeaveTypeEnumSerializer;

  const CreateLeaveDtoLeaveTypeEnum._(String name): super(name);

  static BuiltSet<CreateLeaveDtoLeaveTypeEnum> get values => _$createLeaveDtoLeaveTypeEnumValues;
  static CreateLeaveDtoLeaveTypeEnum valueOf(String name) => _$createLeaveDtoLeaveTypeEnumValueOf(name);
}

