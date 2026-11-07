//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'marked_dto.g.dart';

/// MarkedDto
///
/// Properties:
/// * [marked] 
@BuiltValue()
abstract class MarkedDto implements Built<MarkedDto, MarkedDtoBuilder> {
  @BuiltValueField(wireName: r'marked')
  num get marked;

  MarkedDto._();

  factory MarkedDto([void updates(MarkedDtoBuilder b)]) = _$MarkedDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MarkedDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MarkedDto> get serializer => _$MarkedDtoSerializer();
}

class _$MarkedDtoSerializer implements PrimitiveSerializer<MarkedDto> {
  @override
  final Iterable<Type> types = const [MarkedDto, _$MarkedDto];

  @override
  final String wireName = r'MarkedDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MarkedDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'marked';
    yield serializers.serialize(
      object.marked,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MarkedDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MarkedDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'marked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.marked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MarkedDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MarkedDtoBuilder();
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

