//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_challenge_dto.g.dart';

/// CreateChallengeDto
///
/// Properties:
/// * [staffId] - Whose face will be checked; omit for yourself (proxy punch: the team member)
@BuiltValue()
abstract class CreateChallengeDto implements Built<CreateChallengeDto, CreateChallengeDtoBuilder> {
  /// Whose face will be checked; omit for yourself (proxy punch: the team member)
  @BuiltValueField(wireName: r'staffId')
  String? get staffId;

  CreateChallengeDto._();

  factory CreateChallengeDto([void updates(CreateChallengeDtoBuilder b)]) = _$CreateChallengeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateChallengeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateChallengeDto> get serializer => _$CreateChallengeDtoSerializer();
}

class _$CreateChallengeDtoSerializer implements PrimitiveSerializer<CreateChallengeDto> {
  @override
  final Iterable<Type> types = const [CreateChallengeDto, _$CreateChallengeDto];

  @override
  final String wireName = r'CreateChallengeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateChallengeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.staffId != null) {
      yield r'staffId';
      yield serializers.serialize(
        object.staffId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateChallengeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateChallengeDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'staffId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.staffId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateChallengeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateChallengeDtoBuilder();
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

