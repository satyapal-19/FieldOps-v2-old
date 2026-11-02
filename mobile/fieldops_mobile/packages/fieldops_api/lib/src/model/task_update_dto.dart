//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'task_update_dto.g.dart';

/// TaskUpdateDto
///
/// Properties:
/// * [id] 
/// * [staffId] 
/// * [fromStatus] 
/// * [toStatus] 
/// * [note] 
/// * [photoKey] 
/// * [createdAt] 
@BuiltValue()
abstract class TaskUpdateDto implements Built<TaskUpdateDto, TaskUpdateDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  @BuiltValueField(wireName: r'fromStatus')
  TaskUpdateDtoFromStatusEnum get fromStatus;
  // enum fromStatusEnum {  OPEN,  IN_PROGRESS,  SUBMITTED,  APPROVED,  REJECTED,  ESCALATED,  CLOSED,  };

  @BuiltValueField(wireName: r'toStatus')
  TaskUpdateDtoToStatusEnum get toStatus;
  // enum toStatusEnum {  OPEN,  IN_PROGRESS,  SUBMITTED,  APPROVED,  REJECTED,  ESCALATED,  CLOSED,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'photoKey')
  String? get photoKey;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  TaskUpdateDto._();

  factory TaskUpdateDto([void updates(TaskUpdateDtoBuilder b)]) = _$TaskUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaskUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaskUpdateDto> get serializer => _$TaskUpdateDtoSerializer();
}

class _$TaskUpdateDtoSerializer implements PrimitiveSerializer<TaskUpdateDto> {
  @override
  final Iterable<Type> types = const [TaskUpdateDto, _$TaskUpdateDto];

  @override
  final String wireName = r'TaskUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaskUpdateDto object, {
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
    yield r'fromStatus';
    yield serializers.serialize(
      object.fromStatus,
      specifiedType: const FullType(TaskUpdateDtoFromStatusEnum),
    );
    yield r'toStatus';
    yield serializers.serialize(
      object.toStatus,
      specifiedType: const FullType(TaskUpdateDtoToStatusEnum),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'photoKey';
    yield object.photoKey == null ? null : serializers.serialize(
      object.photoKey,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TaskUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaskUpdateDtoBuilder result,
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
        case r'fromStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaskUpdateDtoFromStatusEnum),
          ) as TaskUpdateDtoFromStatusEnum;
          result.fromStatus = valueDes;
          break;
        case r'toStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaskUpdateDtoToStatusEnum),
          ) as TaskUpdateDtoToStatusEnum;
          result.toStatus = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'photoKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.photoKey = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TaskUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaskUpdateDtoBuilder();
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

class TaskUpdateDtoFromStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const TaskUpdateDtoFromStatusEnum OPEN = _$taskUpdateDtoFromStatusEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const TaskUpdateDtoFromStatusEnum IN_PROGRESS = _$taskUpdateDtoFromStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const TaskUpdateDtoFromStatusEnum SUBMITTED = _$taskUpdateDtoFromStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const TaskUpdateDtoFromStatusEnum APPROVED = _$taskUpdateDtoFromStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const TaskUpdateDtoFromStatusEnum REJECTED = _$taskUpdateDtoFromStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'ESCALATED')
  static const TaskUpdateDtoFromStatusEnum ESCALATED = _$taskUpdateDtoFromStatusEnum_ESCALATED;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const TaskUpdateDtoFromStatusEnum CLOSED = _$taskUpdateDtoFromStatusEnum_CLOSED;

  static Serializer<TaskUpdateDtoFromStatusEnum> get serializer => _$taskUpdateDtoFromStatusEnumSerializer;

  const TaskUpdateDtoFromStatusEnum._(String name): super(name);

  static BuiltSet<TaskUpdateDtoFromStatusEnum> get values => _$taskUpdateDtoFromStatusEnumValues;
  static TaskUpdateDtoFromStatusEnum valueOf(String name) => _$taskUpdateDtoFromStatusEnumValueOf(name);
}

class TaskUpdateDtoToStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const TaskUpdateDtoToStatusEnum OPEN = _$taskUpdateDtoToStatusEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const TaskUpdateDtoToStatusEnum IN_PROGRESS = _$taskUpdateDtoToStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const TaskUpdateDtoToStatusEnum SUBMITTED = _$taskUpdateDtoToStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const TaskUpdateDtoToStatusEnum APPROVED = _$taskUpdateDtoToStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const TaskUpdateDtoToStatusEnum REJECTED = _$taskUpdateDtoToStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'ESCALATED')
  static const TaskUpdateDtoToStatusEnum ESCALATED = _$taskUpdateDtoToStatusEnum_ESCALATED;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const TaskUpdateDtoToStatusEnum CLOSED = _$taskUpdateDtoToStatusEnum_CLOSED;

  static Serializer<TaskUpdateDtoToStatusEnum> get serializer => _$taskUpdateDtoToStatusEnumSerializer;

  const TaskUpdateDtoToStatusEnum._(String name): super(name);

  static BuiltSet<TaskUpdateDtoToStatusEnum> get values => _$taskUpdateDtoToStatusEnumValues;
  static TaskUpdateDtoToStatusEnum valueOf(String name) => _$taskUpdateDtoToStatusEnumValueOf(name);
}

