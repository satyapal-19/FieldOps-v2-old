//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'generate_assignments_dto.g.dart';

/// GenerateAssignmentsDto
///
/// Properties:
/// * [date] - IST date, today up to 31 days ahead
@BuiltValue()
abstract class GenerateAssignmentsDto implements Built<GenerateAssignmentsDto, GenerateAssignmentsDtoBuilder> {
  /// IST date, today up to 31 days ahead
  @BuiltValueField(wireName: r'date')
  String get date;

  GenerateAssignmentsDto._();

  factory GenerateAssignmentsDto([void updates(GenerateAssignmentsDtoBuilder b)]) = _$GenerateAssignmentsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GenerateAssignmentsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GenerateAssignmentsDto> get serializer => _$GenerateAssignmentsDtoSerializer();
}

class _$GenerateAssignmentsDtoSerializer implements PrimitiveSerializer<GenerateAssignmentsDto> {
  @override
  final Iterable<Type> types = const [GenerateAssignmentsDto, _$GenerateAssignmentsDto];

  @override
  final String wireName = r'GenerateAssignmentsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GenerateAssignmentsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GenerateAssignmentsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GenerateAssignmentsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GenerateAssignmentsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GenerateAssignmentsDtoBuilder();
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

