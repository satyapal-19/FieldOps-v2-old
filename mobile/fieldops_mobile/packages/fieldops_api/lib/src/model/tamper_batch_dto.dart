//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fieldops_api/src/model/tamper_event_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tamper_batch_dto.g.dart';

/// TamperBatchDto
///
/// Properties:
/// * [events] 
@BuiltValue()
abstract class TamperBatchDto implements Built<TamperBatchDto, TamperBatchDtoBuilder> {
  @BuiltValueField(wireName: r'events')
  BuiltList<TamperEventDto> get events;

  TamperBatchDto._();

  factory TamperBatchDto([void updates(TamperBatchDtoBuilder b)]) = _$TamperBatchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TamperBatchDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TamperBatchDto> get serializer => _$TamperBatchDtoSerializer();
}

class _$TamperBatchDtoSerializer implements PrimitiveSerializer<TamperBatchDto> {
  @override
  final Iterable<Type> types = const [TamperBatchDto, _$TamperBatchDto];

  @override
  final String wireName = r'TamperBatchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TamperBatchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'events';
    yield serializers.serialize(
      object.events,
      specifiedType: const FullType(BuiltList, [FullType(TamperEventDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TamperBatchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TamperBatchDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TamperEventDto)]),
          ) as BuiltList<TamperEventDto>;
          result.events.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TamperBatchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TamperBatchDtoBuilder();
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

