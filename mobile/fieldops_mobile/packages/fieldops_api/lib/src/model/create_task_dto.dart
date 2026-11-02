//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_task_dto.g.dart';

/// CreateTaskDto
///
/// Properties:
/// * [title] 
/// * [titleMr] 
/// * [description] 
/// * [priority] 
/// * [assignedToId] - Someone below you in your scope
/// * [dueAt] 
/// * [locationLat] 
/// * [locationLng] 
/// * [locationLabel] 
@BuiltValue()
abstract class CreateTaskDto implements Built<CreateTaskDto, CreateTaskDtoBuilder> {
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'titleMr')
  String? get titleMr;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'priority')
  CreateTaskDtoPriorityEnum? get priority;
  // enum priorityEnum {  URGENT,  NORMAL,  LOW,  };

  /// Someone below you in your scope
  @BuiltValueField(wireName: r'assignedToId')
  String get assignedToId;

  @BuiltValueField(wireName: r'dueAt')
  DateTime? get dueAt;

  @BuiltValueField(wireName: r'locationLat')
  num? get locationLat;

  @BuiltValueField(wireName: r'locationLng')
  num? get locationLng;

  @BuiltValueField(wireName: r'locationLabel')
  String? get locationLabel;

  CreateTaskDto._();

  factory CreateTaskDto([void updates(CreateTaskDtoBuilder b)]) = _$CreateTaskDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateTaskDtoBuilder b) => b
      ..priority = const CreateTaskDtoPriorityEnum._('NORMAL');

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateTaskDto> get serializer => _$CreateTaskDtoSerializer();
}

class _$CreateTaskDtoSerializer implements PrimitiveSerializer<CreateTaskDto> {
  @override
  final Iterable<Type> types = const [CreateTaskDto, _$CreateTaskDto];

  @override
  final String wireName = r'CreateTaskDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateTaskDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    if (object.titleMr != null) {
      yield r'titleMr';
      yield serializers.serialize(
        object.titleMr,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.priority != null) {
      yield r'priority';
      yield serializers.serialize(
        object.priority,
        specifiedType: const FullType(CreateTaskDtoPriorityEnum),
      );
    }
    yield r'assignedToId';
    yield serializers.serialize(
      object.assignedToId,
      specifiedType: const FullType(String),
    );
    if (object.dueAt != null) {
      yield r'dueAt';
      yield serializers.serialize(
        object.dueAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.locationLat != null) {
      yield r'locationLat';
      yield serializers.serialize(
        object.locationLat,
        specifiedType: const FullType(num),
      );
    }
    if (object.locationLng != null) {
      yield r'locationLng';
      yield serializers.serialize(
        object.locationLng,
        specifiedType: const FullType(num),
      );
    }
    if (object.locationLabel != null) {
      yield r'locationLabel';
      yield serializers.serialize(
        object.locationLabel,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateTaskDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateTaskDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(String),
          ) as String;
          result.titleMr = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateTaskDtoPriorityEnum),
          ) as CreateTaskDtoPriorityEnum;
          result.priority = valueDes;
          break;
        case r'assignedToId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assignedToId = valueDes;
          break;
        case r'dueAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dueAt = valueDes;
          break;
        case r'locationLat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.locationLat = valueDes;
          break;
        case r'locationLng':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.locationLng = valueDes;
          break;
        case r'locationLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.locationLabel = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateTaskDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateTaskDtoBuilder();
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

class CreateTaskDtoPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'URGENT')
  static const CreateTaskDtoPriorityEnum URGENT = _$createTaskDtoPriorityEnum_URGENT;
  @BuiltValueEnumConst(wireName: r'NORMAL')
  static const CreateTaskDtoPriorityEnum NORMAL = _$createTaskDtoPriorityEnum_NORMAL;
  @BuiltValueEnumConst(wireName: r'LOW')
  static const CreateTaskDtoPriorityEnum LOW = _$createTaskDtoPriorityEnum_LOW;

  static Serializer<CreateTaskDtoPriorityEnum> get serializer => _$createTaskDtoPriorityEnumSerializer;

  const CreateTaskDtoPriorityEnum._(String name): super(name);

  static BuiltSet<CreateTaskDtoPriorityEnum> get values => _$createTaskDtoPriorityEnumValues;
  static CreateTaskDtoPriorityEnum valueOf(String name) => _$createTaskDtoPriorityEnumValueOf(name);
}

