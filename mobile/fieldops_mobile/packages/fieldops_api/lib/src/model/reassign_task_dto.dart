//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reassign_task_dto.g.dart';

/// ReassignTaskDto
///
/// Properties:
/// * [expectedVersion] 
/// * [assignedToId] 
@BuiltValue()
abstract class ReassignTaskDto implements Built<ReassignTaskDto, ReassignTaskDtoBuilder> {
  @BuiltValueField(wireName: r'expectedVersion')
  num get expectedVersion;

  @BuiltValueField(wireName: r'assignedToId')
  String get assignedToId;

  ReassignTaskDto._();

  factory ReassignTaskDto([void updates(ReassignTaskDtoBuilder b)]) = _$ReassignTaskDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReassignTaskDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReassignTaskDto> get serializer => _$ReassignTaskDtoSerializer();
}

class _$ReassignTaskDtoSerializer implements PrimitiveSerializer<ReassignTaskDto> {
  @override
  final Iterable<Type> types = const [ReassignTaskDto, _$ReassignTaskDto];

  @override
  final String wireName = r'ReassignTaskDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReassignTaskDto object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    ReassignTaskDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReassignTaskDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReassignTaskDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReassignTaskDtoBuilder();
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

