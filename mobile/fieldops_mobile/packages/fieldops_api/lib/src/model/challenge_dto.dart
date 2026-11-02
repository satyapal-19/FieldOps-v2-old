//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'challenge_dto.g.dart';

/// ChallengeDto
///
/// Properties:
/// * [challengeId] 
/// * [staffId] 
/// * [actions] - Prompts for the ML Kit flow
/// * [expiresAt] 
@BuiltValue()
abstract class ChallengeDto implements Built<ChallengeDto, ChallengeDtoBuilder> {
  @BuiltValueField(wireName: r'challengeId')
  String get challengeId;

  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  /// Prompts for the ML Kit flow
  @BuiltValueField(wireName: r'actions')
  BuiltList<ChallengeDtoActionsEnum> get actions;
  // enum actionsEnum {  BLINK,  SMILE,  TURN_LEFT,  TURN_RIGHT,  };

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  ChallengeDto._();

  factory ChallengeDto([void updates(ChallengeDtoBuilder b)]) = _$ChallengeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChallengeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChallengeDto> get serializer => _$ChallengeDtoSerializer();
}

class _$ChallengeDtoSerializer implements PrimitiveSerializer<ChallengeDto> {
  @override
  final Iterable<Type> types = const [ChallengeDto, _$ChallengeDto];

  @override
  final String wireName = r'ChallengeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChallengeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'challengeId';
    yield serializers.serialize(
      object.challengeId,
      specifiedType: const FullType(String),
    );
    yield r'staffId';
    yield serializers.serialize(
      object.staffId,
      specifiedType: const FullType(String),
    );
    yield r'actions';
    yield serializers.serialize(
      object.actions,
      specifiedType: const FullType(BuiltList, [FullType(ChallengeDtoActionsEnum)]),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChallengeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChallengeDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'challengeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.challengeId = valueDes;
          break;
        case r'staffId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.staffId = valueDes;
          break;
        case r'actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChallengeDtoActionsEnum)]),
          ) as BuiltList<ChallengeDtoActionsEnum>;
          result.actions.replace(valueDes);
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChallengeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChallengeDtoBuilder();
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

class ChallengeDtoActionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BLINK')
  static const ChallengeDtoActionsEnum BLINK = _$challengeDtoActionsEnum_BLINK;
  @BuiltValueEnumConst(wireName: r'SMILE')
  static const ChallengeDtoActionsEnum SMILE = _$challengeDtoActionsEnum_SMILE;
  @BuiltValueEnumConst(wireName: r'TURN_LEFT')
  static const ChallengeDtoActionsEnum TURN_LEFT = _$challengeDtoActionsEnum_TURN_LEFT;
  @BuiltValueEnumConst(wireName: r'TURN_RIGHT')
  static const ChallengeDtoActionsEnum TURN_RIGHT = _$challengeDtoActionsEnum_TURN_RIGHT;

  static Serializer<ChallengeDtoActionsEnum> get serializer => _$challengeDtoActionsEnumSerializer;

  const ChallengeDtoActionsEnum._(String name): super(name);

  static BuiltSet<ChallengeDtoActionsEnum> get values => _$challengeDtoActionsEnumValues;
  static ChallengeDtoActionsEnum valueOf(String name) => _$challengeDtoActionsEnumValueOf(name);
}

