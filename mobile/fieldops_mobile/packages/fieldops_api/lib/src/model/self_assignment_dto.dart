//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'self_assignment_dto.g.dart';

/// SelfAssignmentDto
///
/// Properties:
/// * [clientUuid] - Idempotency key from the phone; a retry returns the same row
/// * [date] - IST date: today or tomorrow
/// * [wardId] - INSPECTOR self-pick: the ward
/// * [inspectorId] - WORKER self-join: the inspector whose team to join
@BuiltValue()
abstract class SelfAssignmentDto implements Built<SelfAssignmentDto, SelfAssignmentDtoBuilder> {
  /// Idempotency key from the phone; a retry returns the same row
  @BuiltValueField(wireName: r'clientUuid')
  String get clientUuid;

  /// IST date: today or tomorrow
  @BuiltValueField(wireName: r'date')
  String get date;

  /// INSPECTOR self-pick: the ward
  @BuiltValueField(wireName: r'wardId')
  String? get wardId;

  /// WORKER self-join: the inspector whose team to join
  @BuiltValueField(wireName: r'inspectorId')
  String? get inspectorId;

  SelfAssignmentDto._();

  factory SelfAssignmentDto([void updates(SelfAssignmentDtoBuilder b)]) = _$SelfAssignmentDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SelfAssignmentDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SelfAssignmentDto> get serializer => _$SelfAssignmentDtoSerializer();
}

class _$SelfAssignmentDtoSerializer implements PrimitiveSerializer<SelfAssignmentDto> {
  @override
  final Iterable<Type> types = const [SelfAssignmentDto, _$SelfAssignmentDto];

  @override
  final String wireName = r'SelfAssignmentDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SelfAssignmentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clientUuid';
    yield serializers.serialize(
      object.clientUuid,
      specifiedType: const FullType(String),
    );
    yield r'date';
    yield serializers.serialize(
      object.date,
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
    SelfAssignmentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SelfAssignmentDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clientUuid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientUuid = valueDes;
          break;
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
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
  SelfAssignmentDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SelfAssignmentDtoBuilder();
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

