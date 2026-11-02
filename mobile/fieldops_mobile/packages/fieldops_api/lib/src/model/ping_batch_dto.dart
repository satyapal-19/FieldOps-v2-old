//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fieldops_api/src/model/ping_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ping_batch_dto.g.dart';

/// PingBatchDto
///
/// Properties:
/// * [pings] 
@BuiltValue()
abstract class PingBatchDto implements Built<PingBatchDto, PingBatchDtoBuilder> {
  @BuiltValueField(wireName: r'pings')
  BuiltList<PingDto> get pings;

  PingBatchDto._();

  factory PingBatchDto([void updates(PingBatchDtoBuilder b)]) = _$PingBatchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PingBatchDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PingBatchDto> get serializer => _$PingBatchDtoSerializer();
}

class _$PingBatchDtoSerializer implements PrimitiveSerializer<PingBatchDto> {
  @override
  final Iterable<Type> types = const [PingBatchDto, _$PingBatchDto];

  @override
  final String wireName = r'PingBatchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PingBatchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pings';
    yield serializers.serialize(
      object.pings,
      specifiedType: const FullType(BuiltList, [FullType(PingDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PingBatchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PingBatchDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PingDto)]),
          ) as BuiltList<PingDto>;
          result.pings.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PingBatchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PingBatchDtoBuilder();
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

