//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'test_login_dto.g.dart';

/// TestLoginDto
///
/// Properties:
/// * [deviceId] - App install ID (device binding comes after delivery, D3)
/// * [identifier] - Employee code or mobile number
@BuiltValue()
abstract class TestLoginDto implements Built<TestLoginDto, TestLoginDtoBuilder> {
  /// App install ID (device binding comes after delivery, D3)
  @BuiltValueField(wireName: r'deviceId')
  String? get deviceId;

  /// Employee code or mobile number
  @BuiltValueField(wireName: r'identifier')
  String get identifier;

  TestLoginDto._();

  factory TestLoginDto([void updates(TestLoginDtoBuilder b)]) = _$TestLoginDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TestLoginDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TestLoginDto> get serializer => _$TestLoginDtoSerializer();
}

class _$TestLoginDtoSerializer implements PrimitiveSerializer<TestLoginDto> {
  @override
  final Iterable<Type> types = const [TestLoginDto, _$TestLoginDto];

  @override
  final String wireName = r'TestLoginDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TestLoginDto object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    TestLoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TestLoginDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TestLoginDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TestLoginDtoBuilder();
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

