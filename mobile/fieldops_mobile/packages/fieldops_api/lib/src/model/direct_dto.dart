//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'direct_dto.g.dart';

/// DirectDto
///
/// Properties:
/// * [staffId] 
@BuiltValue()
abstract class DirectDto implements Built<DirectDto, DirectDtoBuilder> {
  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  DirectDto._();

  factory DirectDto([void updates(DirectDtoBuilder b)]) = _$DirectDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectDto> get serializer => _$DirectDtoSerializer();
}

class _$DirectDtoSerializer implements PrimitiveSerializer<DirectDto> {
  @override
  final Iterable<Type> types = const [DirectDto, _$DirectDto];

  @override
  final String wireName = r'DirectDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'staffId';
    yield serializers.serialize(
      object.staffId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'staffId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.staffId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectDtoBuilder();
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

