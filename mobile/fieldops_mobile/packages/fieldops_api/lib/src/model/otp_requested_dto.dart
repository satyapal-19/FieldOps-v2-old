//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'otp_requested_dto.g.dart';

/// OtpRequestedDto
///
/// Properties:
/// * [sent] - Always true, whether or not the number is registered
/// * [expiresInSeconds] 
@BuiltValue()
abstract class OtpRequestedDto implements Built<OtpRequestedDto, OtpRequestedDtoBuilder> {
  /// Always true, whether or not the number is registered
  @BuiltValueField(wireName: r'sent')
  bool get sent;

  @BuiltValueField(wireName: r'expiresInSeconds')
  num get expiresInSeconds;

  OtpRequestedDto._();

  factory OtpRequestedDto([void updates(OtpRequestedDtoBuilder b)]) = _$OtpRequestedDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OtpRequestedDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OtpRequestedDto> get serializer => _$OtpRequestedDtoSerializer();
}

class _$OtpRequestedDtoSerializer implements PrimitiveSerializer<OtpRequestedDto> {
  @override
  final Iterable<Type> types = const [OtpRequestedDto, _$OtpRequestedDto];

  @override
  final String wireName = r'OtpRequestedDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OtpRequestedDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sent';
    yield serializers.serialize(
      object.sent,
      specifiedType: const FullType(bool),
    );
    yield r'expiresInSeconds';
    yield serializers.serialize(
      object.expiresInSeconds,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OtpRequestedDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OtpRequestedDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.sent = valueDes;
          break;
        case r'expiresInSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.expiresInSeconds = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OtpRequestedDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OtpRequestedDtoBuilder();
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

