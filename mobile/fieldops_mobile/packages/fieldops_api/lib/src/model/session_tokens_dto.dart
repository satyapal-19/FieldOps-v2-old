//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fieldops_api/src/model/staff_profile_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'session_tokens_dto.g.dart';

/// SessionTokensDto
///
/// Properties:
/// * [accessToken] 
/// * [tokenType] 
/// * [expiresInSeconds] 
/// * [refreshToken] - Single use: each refresh returns a new one
/// * [refreshExpiresAt] 
/// * [staff] 
@BuiltValue()
abstract class SessionTokensDto implements Built<SessionTokensDto, SessionTokensDtoBuilder> {
  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'tokenType')
  String get tokenType;

  @BuiltValueField(wireName: r'expiresInSeconds')
  num get expiresInSeconds;

  /// Single use: each refresh returns a new one
  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  @BuiltValueField(wireName: r'refreshExpiresAt')
  DateTime get refreshExpiresAt;

  @BuiltValueField(wireName: r'staff')
  StaffProfileDto get staff;

  SessionTokensDto._();

  factory SessionTokensDto([void updates(SessionTokensDtoBuilder b)]) = _$SessionTokensDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SessionTokensDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SessionTokensDto> get serializer => _$SessionTokensDtoSerializer();
}

class _$SessionTokensDtoSerializer implements PrimitiveSerializer<SessionTokensDto> {
  @override
  final Iterable<Type> types = const [SessionTokensDto, _$SessionTokensDto];

  @override
  final String wireName = r'SessionTokensDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SessionTokensDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accessToken';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
    yield r'tokenType';
    yield serializers.serialize(
      object.tokenType,
      specifiedType: const FullType(String),
    );
    yield r'expiresInSeconds';
    yield serializers.serialize(
      object.expiresInSeconds,
      specifiedType: const FullType(num),
    );
    yield r'refreshToken';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
    yield r'refreshExpiresAt';
    yield serializers.serialize(
      object.refreshExpiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'staff';
    yield serializers.serialize(
      object.staff,
      specifiedType: const FullType(StaffProfileDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SessionTokensDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SessionTokensDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'tokenType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tokenType = valueDes;
          break;
        case r'expiresInSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.expiresInSeconds = valueDes;
          break;
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
          break;
        case r'refreshExpiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.refreshExpiresAt = valueDes;
          break;
        case r'staff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StaffProfileDto),
          ) as StaffProfileDto;
          result.staff.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SessionTokensDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SessionTokensDtoBuilder();
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

