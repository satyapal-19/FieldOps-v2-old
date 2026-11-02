//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'approve_assignment_dto.g.dart';

/// ApproveAssignmentDto
///
/// Properties:
/// * [expectedVersion] 
@BuiltValue()
abstract class ApproveAssignmentDto implements Built<ApproveAssignmentDto, ApproveAssignmentDtoBuilder> {
  @BuiltValueField(wireName: r'expectedVersion')
  num get expectedVersion;

  ApproveAssignmentDto._();

  factory ApproveAssignmentDto([void updates(ApproveAssignmentDtoBuilder b)]) = _$ApproveAssignmentDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApproveAssignmentDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApproveAssignmentDto> get serializer => _$ApproveAssignmentDtoSerializer();
}

class _$ApproveAssignmentDtoSerializer implements PrimitiveSerializer<ApproveAssignmentDto> {
  @override
  final Iterable<Type> types = const [ApproveAssignmentDto, _$ApproveAssignmentDto];

  @override
  final String wireName = r'ApproveAssignmentDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApproveAssignmentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expectedVersion';
    yield serializers.serialize(
      object.expectedVersion,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApproveAssignmentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApproveAssignmentDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApproveAssignmentDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApproveAssignmentDtoBuilder();
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

