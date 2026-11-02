//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'task_dto.g.dart';

/// TaskDto
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [titleMr] 
/// * [description] 
/// * [priority] 
/// * [status] 
/// * [wardId] 
/// * [assignedToId] 
/// * [createdById] 
/// * [complaintId] 
/// * [locationLat] 
/// * [locationLng] 
/// * [locationLabel] 
/// * [dueAt] 
/// * [startedAt] 
/// * [submittedAt] 
/// * [closedAt] 
/// * [completionNote] 
/// * [rejectionReason] 
/// * [rejectionCount] 
/// * [version] 
/// * [createdAt] 
@BuiltValue()
abstract class TaskDto implements Built<TaskDto, TaskDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'titleMr')
  String? get titleMr;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'priority')
  TaskDtoPriorityEnum get priority;
  // enum priorityEnum {  URGENT,  NORMAL,  LOW,  };

  @BuiltValueField(wireName: r'status')
  TaskDtoStatusEnum get status;
  // enum statusEnum {  OPEN,  IN_PROGRESS,  SUBMITTED,  APPROVED,  REJECTED,  ESCALATED,  CLOSED,  };

  @BuiltValueField(wireName: r'wardId')
  String? get wardId;

  @BuiltValueField(wireName: r'assignedToId')
  String? get assignedToId;

  @BuiltValueField(wireName: r'createdById')
  String get createdById;

  @BuiltValueField(wireName: r'complaintId')
  String? get complaintId;

  @BuiltValueField(wireName: r'locationLat')
  num? get locationLat;

  @BuiltValueField(wireName: r'locationLng')
  num? get locationLng;

  @BuiltValueField(wireName: r'locationLabel')
  String? get locationLabel;

  @BuiltValueField(wireName: r'dueAt')
  DateTime? get dueAt;

  @BuiltValueField(wireName: r'startedAt')
  DateTime? get startedAt;

  @BuiltValueField(wireName: r'submittedAt')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'closedAt')
  DateTime? get closedAt;

  @BuiltValueField(wireName: r'completionNote')
  String? get completionNote;

  @BuiltValueField(wireName: r'rejectionReason')
  String? get rejectionReason;

  @BuiltValueField(wireName: r'rejectionCount')
  num get rejectionCount;

  @BuiltValueField(wireName: r'version')
  num get version;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  TaskDto._();

  factory TaskDto([void updates(TaskDtoBuilder b)]) = _$TaskDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaskDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaskDto> get serializer => _$TaskDtoSerializer();
}

class _$TaskDtoSerializer implements PrimitiveSerializer<TaskDto> {
  @override
  final Iterable<Type> types = const [TaskDto, _$TaskDto];

  @override
  final String wireName = r'TaskDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaskDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'titleMr';
    yield object.titleMr == null ? null : serializers.serialize(
      object.titleMr,
      specifiedType: const FullType.nullable(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'priority';
    yield serializers.serialize(
      object.priority,
      specifiedType: const FullType(TaskDtoPriorityEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TaskDtoStatusEnum),
    );
    yield r'wardId';
    yield object.wardId == null ? null : serializers.serialize(
      object.wardId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'assignedToId';
    yield object.assignedToId == null ? null : serializers.serialize(
      object.assignedToId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdById';
    yield serializers.serialize(
      object.createdById,
      specifiedType: const FullType(String),
    );
    yield r'complaintId';
    yield object.complaintId == null ? null : serializers.serialize(
      object.complaintId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'locationLat';
    yield object.locationLat == null ? null : serializers.serialize(
      object.locationLat,
      specifiedType: const FullType.nullable(num),
    );
    yield r'locationLng';
    yield object.locationLng == null ? null : serializers.serialize(
      object.locationLng,
      specifiedType: const FullType.nullable(num),
    );
    yield r'locationLabel';
    yield object.locationLabel == null ? null : serializers.serialize(
      object.locationLabel,
      specifiedType: const FullType.nullable(String),
    );
    yield r'dueAt';
    yield object.dueAt == null ? null : serializers.serialize(
      object.dueAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'startedAt';
    yield object.startedAt == null ? null : serializers.serialize(
      object.startedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'submittedAt';
    yield object.submittedAt == null ? null : serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'closedAt';
    yield object.closedAt == null ? null : serializers.serialize(
      object.closedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'completionNote';
    yield object.completionNote == null ? null : serializers.serialize(
      object.completionNote,
      specifiedType: const FullType.nullable(String),
    );
    yield r'rejectionReason';
    yield object.rejectionReason == null ? null : serializers.serialize(
      object.rejectionReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'rejectionCount';
    yield serializers.serialize(
      object.rejectionCount,
      specifiedType: const FullType(num),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    TaskDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaskDtoBuilder result,
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
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'titleMr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.titleMr = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaskDtoPriorityEnum),
          ) as TaskDtoPriorityEnum;
          result.priority = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaskDtoStatusEnum),
          ) as TaskDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.wardId = valueDes;
          break;
        case r'assignedToId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assignedToId = valueDes;
          break;
        case r'createdById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdById = valueDes;
          break;
        case r'complaintId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.complaintId = valueDes;
          break;
        case r'locationLat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.locationLat = valueDes;
          break;
        case r'locationLng':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.locationLng = valueDes;
          break;
        case r'locationLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.locationLabel = valueDes;
          break;
        case r'dueAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.dueAt = valueDes;
          break;
        case r'startedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.startedAt = valueDes;
          break;
        case r'submittedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        case r'closedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        case r'completionNote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.completionNote = valueDes;
          break;
        case r'rejectionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rejectionReason = valueDes;
          break;
        case r'rejectionCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.rejectionCount = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TaskDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaskDtoBuilder();
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

class TaskDtoPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'URGENT')
  static const TaskDtoPriorityEnum URGENT = _$taskDtoPriorityEnum_URGENT;
  @BuiltValueEnumConst(wireName: r'NORMAL')
  static const TaskDtoPriorityEnum NORMAL = _$taskDtoPriorityEnum_NORMAL;
  @BuiltValueEnumConst(wireName: r'LOW')
  static const TaskDtoPriorityEnum LOW = _$taskDtoPriorityEnum_LOW;

  static Serializer<TaskDtoPriorityEnum> get serializer => _$taskDtoPriorityEnumSerializer;

  const TaskDtoPriorityEnum._(String name): super(name);

  static BuiltSet<TaskDtoPriorityEnum> get values => _$taskDtoPriorityEnumValues;
  static TaskDtoPriorityEnum valueOf(String name) => _$taskDtoPriorityEnumValueOf(name);
}

class TaskDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const TaskDtoStatusEnum OPEN = _$taskDtoStatusEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const TaskDtoStatusEnum IN_PROGRESS = _$taskDtoStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const TaskDtoStatusEnum SUBMITTED = _$taskDtoStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const TaskDtoStatusEnum APPROVED = _$taskDtoStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const TaskDtoStatusEnum REJECTED = _$taskDtoStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'ESCALATED')
  static const TaskDtoStatusEnum ESCALATED = _$taskDtoStatusEnum_ESCALATED;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const TaskDtoStatusEnum CLOSED = _$taskDtoStatusEnum_CLOSED;

  static Serializer<TaskDtoStatusEnum> get serializer => _$taskDtoStatusEnumSerializer;

  const TaskDtoStatusEnum._(String name): super(name);

  static BuiltSet<TaskDtoStatusEnum> get values => _$taskDtoStatusEnumValues;
  static TaskDtoStatusEnum valueOf(String name) => _$taskDtoStatusEnumValueOf(name);
}

