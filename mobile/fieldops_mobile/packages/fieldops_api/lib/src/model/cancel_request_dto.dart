//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancel_request_dto.g.dart';

/// CancelRequestDto
///
/// Properties:
/// * [expectedVersion] 
@BuiltValue()
abstract class CancelRequestDto implements Built<CancelRequestDto, CancelRequestDtoBuilder> {
  @BuiltValueField(wireName: r'expectedVersion')
  num get expectedVersion;

  CancelRequestDto._();

  factory CancelRequestDto([void updates(CancelRequestDtoBuilder b)]) = _$CancelRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancelRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancelRequestDto> get serializer => _$CancelRequestDtoSerializer();
}

class _$CancelRequestDtoSerializer implements PrimitiveSerializer<CancelRequestDto> {
  @override
  final Iterable<Type> types = const [CancelRequestDto, _$CancelRequestDto];

  @override
  final String wireName = r'CancelRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancelRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expectedVersion';
    yield serializers.serialize(
      object.expectedVersion,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancelRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancelRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expectedVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.expectedVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancelRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancelRequestDtoBuilder();
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

