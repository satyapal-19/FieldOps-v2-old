//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'password_login_dto.g.dart';

/// PasswordLoginDto
///
/// Properties:
/// * [deviceId] - App install ID (device binding comes after delivery, D3)
/// * [identifier] - Employee code or mobile number
/// * [password] 
@BuiltValue()
abstract class PasswordLoginDto implements Built<PasswordLoginDto, PasswordLoginDtoBuilder> {
  /// App install ID (device binding comes after delivery, D3)
  @BuiltValueField(wireName: r'deviceId')
  String? get deviceId;

  /// Employee code or mobile number
  @BuiltValueField(wireName: r'identifier')
  String get identifier;

  @BuiltValueField(wireName: r'password')
  String get password;

  PasswordLoginDto._();

  factory PasswordLoginDto([void updates(PasswordLoginDtoBuilder b)]) = _$PasswordLoginDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasswordLoginDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasswordLoginDto> get serializer => _$PasswordLoginDtoSerializer();
}

class _$PasswordLoginDtoSerializer implements PrimitiveSerializer<PasswordLoginDto> {
  @override
  final Iterable<Type> types = const [PasswordLoginDto, _$PasswordLoginDto];

  @override
  final String wireName = r'PasswordLoginDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasswordLoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.deviceId != null) {
      yield r'deviceId';
      yield serializers.serialize(
        object.deviceId,
        specifiedType: const FullType(String),
      );
    }
    yield r'identifier';
    yield serializers.serialize(
      object.identifier,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PasswordLoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasswordLoginDtoBuilder result,
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
        case r'identifier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.identifier = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PasswordLoginDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasswordLoginDtoBuilder();
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

