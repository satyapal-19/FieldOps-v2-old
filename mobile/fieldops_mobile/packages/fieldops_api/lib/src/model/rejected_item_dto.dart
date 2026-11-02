//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'rejected_item_dto.g.dart';

/// RejectedItemDto
///
/// Properties:
/// * [clientUuid] 
/// * [reason] 
@BuiltValue()
abstract class RejectedItemDto implements Built<RejectedItemDto, RejectedItemDtoBuilder> {
  @BuiltValueField(wireName: r'clientUuid')
  String get clientUuid;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  RejectedItemDto._();

  factory RejectedItemDto([void updates(RejectedItemDtoBuilder b)]) = _$RejectedItemDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RejectedItemDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RejectedItemDto> get serializer => _$RejectedItemDtoSerializer();
}

class _$RejectedItemDtoSerializer implements PrimitiveSerializer<RejectedItemDto> {
  @override
  final Iterable<Type> types = const [RejectedItemDto, _$RejectedItemDto];

  @override
  final String wireName = r'RejectedItemDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RejectedItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clientUuid';
    yield serializers.serialize(
      object.clientUuid,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RejectedItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RejectedItemDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clientUuid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientUuid = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RejectedItemDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RejectedItemDtoBuilder();
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

