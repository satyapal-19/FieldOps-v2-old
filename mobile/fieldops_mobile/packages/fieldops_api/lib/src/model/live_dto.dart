//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fieldops_api/src/model/live_position_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'live_dto.g.dart';

/// LiveDto
///
/// Properties:
/// * [at] - Server time of this snapshot
/// * [items] 
@BuiltValue()
abstract class LiveDto implements Built<LiveDto, LiveDtoBuilder> {
  /// Server time of this snapshot
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'items')
  BuiltList<LivePositionDto> get items;

  LiveDto._();

  factory LiveDto([void updates(LiveDtoBuilder b)]) = _$LiveDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LiveDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LiveDto> get serializer => _$LiveDtoSerializer();
}

class _$LiveDtoSerializer implements PrimitiveSerializer<LiveDto> {
  @override
  final Iterable<Type> types = const [LiveDto, _$LiveDto];

  @override
  final String wireName = r'LiveDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LiveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(LivePositionDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LiveDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LiveDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.at = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(LivePositionDto)]),
          ) as BuiltList<LivePositionDto>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LiveDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LiveDtoBuilder();
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

