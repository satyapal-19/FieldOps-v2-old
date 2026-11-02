//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assignment_dto.g.dart';

/// AssignmentDto
///
/// Properties:
/// * [id] 
/// * [date] 
/// * [staffId] 
/// * [staffRole] 
/// * [wardId] 
/// * [wardInspectorId] 
/// * [inspectorId] 
/// * [assignmentMode] 
/// * [isApproved] 
/// * [approvedById] 
/// * [approvedAt] 
/// * [assignedById] 
/// * [version] 
/// * [createdAt] 
@BuiltValue()
abstract class AssignmentDto implements Built<AssignmentDto, AssignmentDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  @BuiltValueField(wireName: r'staffRole')
  AssignmentDtoStaffRoleEnum get staffRole;
  // enum staffRoleEnum {  INSPECTOR,  WORKER,  };

  @BuiltValueField(wireName: r'wardId')
  String get wardId;

  @BuiltValueField(wireName: r'wardInspectorId')
  String get wardInspectorId;

  @BuiltValueField(wireName: r'inspectorId')
  String get inspectorId;

  @BuiltValueField(wireName: r'assignmentMode')
  AssignmentDtoAssignmentModeEnum get assignmentMode;
  // enum assignmentModeEnum {  STANDING_ROSTER,  ADMIN_ASSIGNED,  WARD_INSPECTOR_ASSIGNED,  INSPECTOR_SELF_PICK,  WORKER_SELF_JOIN,  };

  @BuiltValueField(wireName: r'isApproved')
  bool get isApproved;

  @BuiltValueField(wireName: r'approvedById')
  String? get approvedById;

  @BuiltValueField(wireName: r'approvedAt')
  DateTime? get approvedAt;

  @BuiltValueField(wireName: r'assignedById')
  String? get assignedById;

  @BuiltValueField(wireName: r'version')
  num get version;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AssignmentDto._();

  factory AssignmentDto([void updates(AssignmentDtoBuilder b)]) = _$AssignmentDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssignmentDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssignmentDto> get serializer => _$AssignmentDtoSerializer();
}

class _$AssignmentDtoSerializer implements PrimitiveSerializer<AssignmentDto> {
  @override
  final Iterable<Type> types = const [AssignmentDto, _$AssignmentDto];

  @override
  final String wireName = r'AssignmentDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssignmentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
    yield r'staffId';
    yield serializers.serialize(
      object.staffId,
      specifiedType: const FullType(String),
    );
    yield r'staffRole';
    yield serializers.serialize(
      object.staffRole,
      specifiedType: const FullType(AssignmentDtoStaffRoleEnum),
    );
    yield r'wardId';
    yield serializers.serialize(
      object.wardId,
      specifiedType: const FullType(String),
    );
    yield r'wardInspectorId';
    yield serializers.serialize(
      object.wardInspectorId,
      specifiedType: const FullType(String),
    );
    yield r'inspectorId';
    yield serializers.serialize(
      object.inspectorId,
      specifiedType: const FullType(String),
    );
    yield r'assignmentMode';
    yield serializers.serialize(
      object.assignmentMode,
      specifiedType: const FullType(AssignmentDtoAssignmentModeEnum),
    );
    yield r'isApproved';
    yield serializers.serialize(
      object.isApproved,
      specifiedType: const FullType(bool),
    );
    yield r'approvedById';
    yield object.approvedById == null ? null : serializers.serialize(
      object.approvedById,
      specifiedType: const FullType.nullable(String),
    );
    yield r'approvedAt';
    yield object.approvedAt == null ? null : serializers.serialize(
      object.approvedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'assignedById';
    yield object.assignedById == null ? null : serializers.serialize(
      object.assignedById,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AssignmentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssignmentDtoBuilder result,
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
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        case r'staffId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.staffId = valueDes;
          break;
        case r'staffRole':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssignmentDtoStaffRoleEnum),
          ) as AssignmentDtoStaffRoleEnum;
          result.staffRole = valueDes;
          break;
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.wardId = valueDes;
          break;
        case r'wardInspectorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.wardInspectorId = valueDes;
          break;
        case r'inspectorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.inspectorId = valueDes;
          break;
        case r'assignmentMode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssignmentDtoAssignmentModeEnum),
          ) as AssignmentDtoAssignmentModeEnum;
          result.assignmentMode = valueDes;
          break;
        case r'isApproved':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isApproved = valueDes;
          break;
        case r'approvedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.approvedById = valueDes;
          break;
        case r'approvedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.approvedAt = valueDes;
          break;
        case r'assignedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assignedById = valueDes;
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
  AssignmentDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssignmentDtoBuilder();
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

class AssignmentDtoStaffRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INSPECTOR')
  static const AssignmentDtoStaffRoleEnum INSPECTOR = _$assignmentDtoStaffRoleEnum_INSPECTOR;
  @BuiltValueEnumConst(wireName: r'WORKER')
  static const AssignmentDtoStaffRoleEnum WORKER = _$assignmentDtoStaffRoleEnum_WORKER;

  static Serializer<AssignmentDtoStaffRoleEnum> get serializer => _$assignmentDtoStaffRoleEnumSerializer;

  const AssignmentDtoStaffRoleEnum._(String name): super(name);

  static BuiltSet<AssignmentDtoStaffRoleEnum> get values => _$assignmentDtoStaffRoleEnumValues;
  static AssignmentDtoStaffRoleEnum valueOf(String name) => _$assignmentDtoStaffRoleEnumValueOf(name);
}

class AssignmentDtoAssignmentModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STANDING_ROSTER')
  static const AssignmentDtoAssignmentModeEnum STANDING_ROSTER = _$assignmentDtoAssignmentModeEnum_STANDING_ROSTER;
  @BuiltValueEnumConst(wireName: r'ADMIN_ASSIGNED')
  static const AssignmentDtoAssignmentModeEnum ADMIN_ASSIGNED = _$assignmentDtoAssignmentModeEnum_ADMIN_ASSIGNED;
  @BuiltValueEnumConst(wireName: r'WARD_INSPECTOR_ASSIGNED')
  static const AssignmentDtoAssignmentModeEnum WARD_INSPECTOR_ASSIGNED = _$assignmentDtoAssignmentModeEnum_WARD_INSPECTOR_ASSIGNED;
  @BuiltValueEnumConst(wireName: r'INSPECTOR_SELF_PICK')
  static const AssignmentDtoAssignmentModeEnum INSPECTOR_SELF_PICK = _$assignmentDtoAssignmentModeEnum_INSPECTOR_SELF_PICK;
  @BuiltValueEnumConst(wireName: r'WORKER_SELF_JOIN')
  static const AssignmentDtoAssignmentModeEnum WORKER_SELF_JOIN = _$assignmentDtoAssignmentModeEnum_WORKER_SELF_JOIN;

  static Serializer<AssignmentDtoAssignmentModeEnum> get serializer => _$assignmentDtoAssignmentModeEnumSerializer;

  const AssignmentDtoAssignmentModeEnum._(String name): super(name);

  static BuiltSet<AssignmentDtoAssignmentModeEnum> get values => _$assignmentDtoAssignmentModeEnumValues;
  static AssignmentDtoAssignmentModeEnum valueOf(String name) => _$assignmentDtoAssignmentModeEnumValueOf(name);
}

