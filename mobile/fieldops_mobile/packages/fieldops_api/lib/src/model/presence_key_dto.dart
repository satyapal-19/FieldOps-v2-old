//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'presence_key_dto.g.dart';

/// PresenceKeyDto
///
/// Properties:
/// * [key] - Base64 key: compute TOTP codes offline (HMAC-SHA1, 6 digits)
/// * [periodSeconds] 
/// * [digits] 
@BuiltValue()
abstract class PresenceKeyDto implements Built<PresenceKeyDto, PresenceKeyDtoBuilder> {
  /// Base64 key: compute TOTP codes offline (HMAC-SHA1, 6 digits)
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'periodSeconds')
  num get periodSeconds;

  @BuiltValueField(wireName: r'digits')
  num get digits;

  PresenceKeyDto._();

  factory PresenceKeyDto([void updates(PresenceKeyDtoBuilder b)]) = _$PresenceKeyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PresenceKeyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PresenceKeyDto> get serializer => _$PresenceKeyDtoSerializer();
}

class _$PresenceKeyDtoSerializer implements PrimitiveSerializer<PresenceKeyDto> {
  @override
  final Iterable<Type> types = const [PresenceKeyDto, _$PresenceKeyDto];

  @override
  final String wireName = r'PresenceKeyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PresenceKeyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'periodSeconds';
    yield serializers.serialize(
      object.periodSeconds,
      specifiedType: const FullType(num),
    );
    yield r'digits';
    yield serializers.serialize(
      object.digits,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PresenceKeyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PresenceKeyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'periodSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.periodSeconds = valueDes;
          break;
        case r'digits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.digits = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PresenceKeyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PresenceKeyDtoBuilder();
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

