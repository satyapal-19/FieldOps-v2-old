//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'remove_push_token_dto.g.dart';

/// RemovePushTokenDto
///
/// Properties:
/// * [token] 
@BuiltValue()
abstract class RemovePushTokenDto implements Built<RemovePushTokenDto, RemovePushTokenDtoBuilder> {
  @BuiltValueField(wireName: r'token')
  String get token;

  RemovePushTokenDto._();

  factory RemovePushTokenDto([void updates(RemovePushTokenDtoBuilder b)]) = _$RemovePushTokenDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RemovePushTokenDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RemovePushTokenDto> get serializer => _$RemovePushTokenDtoSerializer();
}

class _$RemovePushTokenDtoSerializer implements PrimitiveSerializer<RemovePushTokenDto> {
  @override
  final Iterable<Type> types = const [RemovePushTokenDto, _$RemovePushTokenDto];

  @override
  final String wireName = r'RemovePushTokenDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RemovePushTokenDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RemovePushTokenDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RemovePushTokenDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RemovePushTokenDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RemovePushTokenDtoBuilder();
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

