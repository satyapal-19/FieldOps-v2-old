//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_assignment_dto.g.dart';

/// CreateAssignmentDto
///
/// Properties:
/// * [date] - IST date, today up to 31 days ahead
/// * [staffId] - The INSPECTOR or WORKER being placed
/// * [wardId] - Required when placing an INSPECTOR
/// * [inspectorId] - Required when placing a WORKER: an inspector already placed that day
@BuiltValue()
abstract class CreateAssignmentDto implements Built<CreateAssignmentDto, CreateAssignmentDtoBuilder> {
  /// IST date, today up to 31 days ahead
  @BuiltValueField(wireName: r'date')
  String get date;

  /// The INSPECTOR or WORKER being placed
  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  /// Required when placing an INSPECTOR
  @BuiltValueField(wireName: r'wardId')
  String? get wardId;

  /// Required when placing a WORKER: an inspector already placed that day
  @BuiltValueField(wireName: r'inspectorId')
  String? get inspectorId;

  CreateAssignmentDto._();

  factory CreateAssignmentDto([void updates(CreateAssignmentDtoBuilder b)]) = _$CreateAssignmentDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateAssignmentDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateAssignmentDto> get serializer => _$CreateAssignmentDtoSerializer();
}

class _$CreateAssignmentDtoSerializer implements PrimitiveSerializer<CreateAssignmentDto> {
  @override
  final Iterable<Type> types = const [CreateAssignmentDto, _$CreateAssignmentDto];

  @override
  final String wireName = r'CreateAssignmentDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateAssignmentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.wardId != null) {
      yield r'wardId';
      yield serializers.serialize(
        object.wardId,
        specifiedType: const FullType(String),
      );
    }
    if (object.inspectorId != null) {
      yield r'inspectorId';
      yield serializers.serialize(
        object.inspectorId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateAssignmentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateAssignmentDtoBuilder result,
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
        case r'staffId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.staffId = valueDes;
          break;
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.wardId = valueDes;
          break;
        case r'inspectorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.inspectorId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateAssignmentDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateAssignmentDtoBuilder();
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

