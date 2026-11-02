//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'generate_assignments_result_dto.g.dart';

/// GenerateAssignmentsResultDto
///
/// Properties:
/// * [date] 
/// * [created] - Rows created from standing squads
@BuiltValue()
abstract class GenerateAssignmentsResultDto implements Built<GenerateAssignmentsResultDto, GenerateAssignmentsResultDtoBuilder> {
  @BuiltValueField(wireName: r'date')
  String get date;

  /// Rows created from standing squads
  @BuiltValueField(wireName: r'created')
  num get created;

  GenerateAssignmentsResultDto._();

  factory GenerateAssignmentsResultDto([void updates(GenerateAssignmentsResultDtoBuilder b)]) = _$GenerateAssignmentsResultDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GenerateAssignmentsResultDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GenerateAssignmentsResultDto> get serializer => _$GenerateAssignmentsResultDtoSerializer();
}

class _$GenerateAssignmentsResultDtoSerializer implements PrimitiveSerializer<GenerateAssignmentsResultDto> {
  @override
  final Iterable<Type> types = const [GenerateAssignmentsResultDto, _$GenerateAssignmentsResultDto];

  @override
  final String wireName = r'GenerateAssignmentsResultDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GenerateAssignmentsResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
    yield r'created';
    yield serializers.serialize(
      object.created,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GenerateAssignmentsResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GenerateAssignmentsResultDtoBuilder result,
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
        case r'created':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.created = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GenerateAssignmentsResultDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GenerateAssignmentsResultDtoBuilder();
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

