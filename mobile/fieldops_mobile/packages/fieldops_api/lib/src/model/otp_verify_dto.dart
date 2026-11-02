//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'otp_verify_dto.g.dart';

/// OtpVerifyDto
///
/// Properties:
/// * [deviceId] - App install ID (device binding comes after delivery, D3)
/// * [phone] 
/// * [code] 
@BuiltValue()
abstract class OtpVerifyDto implements Built<OtpVerifyDto, OtpVerifyDtoBuilder> {
  /// App install ID (device binding comes after delivery, D3)
  @BuiltValueField(wireName: r'deviceId')
  String? get deviceId;

  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'code')
  String get code;

  OtpVerifyDto._();

  factory OtpVerifyDto([void updates(OtpVerifyDtoBuilder b)]) = _$OtpVerifyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OtpVerifyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OtpVerifyDto> get serializer => _$OtpVerifyDtoSerializer();
}

class _$OtpVerifyDtoSerializer implements PrimitiveSerializer<OtpVerifyDto> {
  @override
  final Iterable<Type> types = const [OtpVerifyDto, _$OtpVerifyDto];

  @override
  final String wireName = r'OtpVerifyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OtpVerifyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.deviceId != null) {
      yield r'deviceId';
      yield serializers.serialize(
        object.deviceId,
        specifiedType: const FullType(String),
      );
    }
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OtpVerifyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OtpVerifyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'deviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceId = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OtpVerifyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OtpVerifyDtoBuilder();
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

