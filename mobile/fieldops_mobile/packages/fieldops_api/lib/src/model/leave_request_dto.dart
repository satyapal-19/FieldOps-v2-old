//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'leave_request_dto.g.dart';

/// LeaveRequestDto
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
/// * [leaveType] 
/// * [fromDate] 
/// * [toDate] 
/// * [daysCount] - Calendar days, both ends counted
/// * [reason] 
@BuiltValue()
abstract class LeaveRequestDto implements Built<LeaveRequestDto, LeaveRequestDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  @BuiltValueField(wireName: r'status')
  LeaveRequestDtoStatusEnum get status;
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

  @BuiltValueField(wireName: r'leaveType')
  LeaveRequestDtoLeaveTypeEnum get leaveType;
  // enum leaveTypeEnum {  CASUAL,  SICK,  EARNED,  WEEKLY_OFF,  };

  @BuiltValueField(wireName: r'fromDate')
  String get fromDate;

  @BuiltValueField(wireName: r'toDate')
  String get toDate;

  /// Calendar days, both ends counted
  @BuiltValueField(wireName: r'daysCount')
  num get daysCount;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  LeaveRequestDto._();

  factory LeaveRequestDto([void updates(LeaveRequestDtoBuilder b)]) = _$LeaveRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LeaveRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LeaveRequestDto> get serializer => _$LeaveRequestDtoSerializer();
}

class _$LeaveRequestDtoSerializer implements PrimitiveSerializer<LeaveRequestDto> {
  @override
  final Iterable<Type> types = const [LeaveRequestDto, _$LeaveRequestDto];

  @override
  final String wireName = r'LeaveRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LeaveRequestDto object, {
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
      specifiedType: const FullType(LeaveRequestDtoStatusEnum),
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
    yield r'leaveType';
    yield serializers.serialize(
      object.leaveType,
      specifiedType: const FullType(LeaveRequestDtoLeaveTypeEnum),
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
    yield r'daysCount';
    yield serializers.serialize(
      object.daysCount,
      specifiedType: const FullType(num),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LeaveRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LeaveRequestDtoBuilder result,
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
            specifiedType: const FullType(LeaveRequestDtoStatusEnum),
          ) as LeaveRequestDtoStatusEnum;
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
        case r'leaveType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LeaveRequestDtoLeaveTypeEnum),
          ) as LeaveRequestDtoLeaveTypeEnum;
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
        case r'daysCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.daysCount = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  LeaveRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LeaveRequestDtoBuilder();
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

class LeaveRequestDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const LeaveRequestDtoStatusEnum PENDING = _$leaveRequestDtoStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const LeaveRequestDtoStatusEnum APPROVED = _$leaveRequestDtoStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const LeaveRequestDtoStatusEnum REJECTED = _$leaveRequestDtoStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const LeaveRequestDtoStatusEnum CANCELLED = _$leaveRequestDtoStatusEnum_CANCELLED;

  static Serializer<LeaveRequestDtoStatusEnum> get serializer => _$leaveRequestDtoStatusEnumSerializer;

  const LeaveRequestDtoStatusEnum._(String name): super(name);

  static BuiltSet<LeaveRequestDtoStatusEnum> get values => _$leaveRequestDtoStatusEnumValues;
  static LeaveRequestDtoStatusEnum valueOf(String name) => _$leaveRequestDtoStatusEnumValueOf(name);
}

class LeaveRequestDtoLeaveTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CASUAL')
  static const LeaveRequestDtoLeaveTypeEnum CASUAL = _$leaveRequestDtoLeaveTypeEnum_CASUAL;
  @BuiltValueEnumConst(wireName: r'SICK')
  static const LeaveRequestDtoLeaveTypeEnum SICK = _$leaveRequestDtoLeaveTypeEnum_SICK;
  @BuiltValueEnumConst(wireName: r'EARNED')
  static const LeaveRequestDtoLeaveTypeEnum EARNED = _$leaveRequestDtoLeaveTypeEnum_EARNED;
  @BuiltValueEnumConst(wireName: r'WEEKLY_OFF')
  static const LeaveRequestDtoLeaveTypeEnum WEEKLY_OFF = _$leaveRequestDtoLeaveTypeEnum_WEEKLY_OFF;

  static Serializer<LeaveRequestDtoLeaveTypeEnum> get serializer => _$leaveRequestDtoLeaveTypeEnumSerializer;

  const LeaveRequestDtoLeaveTypeEnum._(String name): super(name);

  static BuiltSet<LeaveRequestDtoLeaveTypeEnum> get values => _$leaveRequestDtoLeaveTypeEnumValues;
  static LeaveRequestDtoLeaveTypeEnum valueOf(String name) => _$leaveRequestDtoLeaveTypeEnumValueOf(name);
}

