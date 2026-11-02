//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'revoked_count_dto.g.dart';

/// RevokedCountDto
///
/// Properties:
/// * [revoked] 
@BuiltValue()
abstract class RevokedCountDto implements Built<RevokedCountDto, RevokedCountDtoBuilder> {
  @BuiltValueField(wireName: r'revoked')
  num get revoked;

  RevokedCountDto._();

  factory RevokedCountDto([void updates(RevokedCountDtoBuilder b)]) = _$RevokedCountDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RevokedCountDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RevokedCountDto> get serializer => _$RevokedCountDtoSerializer();
}

class _$RevokedCountDtoSerializer implements PrimitiveSerializer<RevokedCountDto> {
  @override
  final Iterable<Type> types = const [RevokedCountDto, _$RevokedCountDto];

  @override
  final String wireName = r'RevokedCountDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RevokedCountDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'revoked';
    yield serializers.serialize(
      object.revoked,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RevokedCountDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RevokedCountDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'revoked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.revoked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RevokedCountDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RevokedCountDtoBuilder();
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

