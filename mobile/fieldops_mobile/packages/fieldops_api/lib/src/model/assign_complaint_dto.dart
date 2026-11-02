//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assign_complaint_dto.g.dart';

/// AssignComplaintDto
///
/// Properties:
/// * [expectedVersion] 
/// * [assignedToId] - Who does the work (assignment rules of tasks apply)
/// * [priority] 
/// * [dueAt] 
@BuiltValue()
abstract class AssignComplaintDto implements Built<AssignComplaintDto, AssignComplaintDtoBuilder> {
  @BuiltValueField(wireName: r'expectedVersion')
  num get expectedVersion;

  /// Who does the work (assignment rules of tasks apply)
  @BuiltValueField(wireName: r'assignedToId')
  String get assignedToId;

  @BuiltValueField(wireName: r'priority')
  AssignComplaintDtoPriorityEnum? get priority;
  // enum priorityEnum {  URGENT,  NORMAL,  LOW,  };

  @BuiltValueField(wireName: r'dueAt')
  DateTime? get dueAt;

  AssignComplaintDto._();

  factory AssignComplaintDto([void updates(AssignComplaintDtoBuilder b)]) = _$AssignComplaintDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssignComplaintDtoBuilder b) => b
      ..priority = const AssignComplaintDtoPriorityEnum._('NORMAL');

  @BuiltValueSerializer(custom: true)
  static Serializer<AssignComplaintDto> get serializer => _$AssignComplaintDtoSerializer();
}

class _$AssignComplaintDtoSerializer implements PrimitiveSerializer<AssignComplaintDto> {
  @override
  final Iterable<Type> types = const [AssignComplaintDto, _$AssignComplaintDto];

  @override
  final String wireName = r'AssignComplaintDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssignComplaintDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expectedVersion';
    yield serializers.serialize(
      object.expectedVersion,
      specifiedType: const FullType(num),
    );
    yield r'assignedToId';
    yield serializers.serialize(
      object.assignedToId,
      specifiedType: const FullType(String),
    );
    if (object.priority != null) {
      yield r'priority';
      yield serializers.serialize(
        object.priority,
        specifiedType: const FullType(AssignComplaintDtoPriorityEnum),
      );
    }
    if (object.dueAt != null) {
      yield r'dueAt';
      yield serializers.serialize(
        object.dueAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AssignComplaintDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssignComplaintDtoBuilder result,
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
        case r'assignedToId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assignedToId = valueDes;
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssignComplaintDtoPriorityEnum),
          ) as AssignComplaintDtoPriorityEnum;
          result.priority = valueDes;
          break;
        case r'dueAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dueAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssignComplaintDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssignComplaintDtoBuilder();
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

class AssignComplaintDtoPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'URGENT')
  static const AssignComplaintDtoPriorityEnum URGENT = _$assignComplaintDtoPriorityEnum_URGENT;
  @BuiltValueEnumConst(wireName: r'NORMAL')
  static const AssignComplaintDtoPriorityEnum NORMAL = _$assignComplaintDtoPriorityEnum_NORMAL;
  @BuiltValueEnumConst(wireName: r'LOW')
  static const AssignComplaintDtoPriorityEnum LOW = _$assignComplaintDtoPriorityEnum_LOW;

  static Serializer<AssignComplaintDtoPriorityEnum> get serializer => _$assignComplaintDtoPriorityEnumSerializer;

  const AssignComplaintDtoPriorityEnum._(String name): super(name);

  static BuiltSet<AssignComplaintDtoPriorityEnum> get values => _$assignComplaintDtoPriorityEnumValues;
  static AssignComplaintDtoPriorityEnum valueOf(String name) => _$assignComplaintDtoPriorityEnumValueOf(name);
}

