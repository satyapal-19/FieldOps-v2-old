//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fieldops_api/src/model/notification_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inbox_dto.g.dart';

/// InboxDto
///
/// Properties:
/// * [items] - Newest first
/// * [unreadCount] 
@BuiltValue()
abstract class InboxDto implements Built<InboxDto, InboxDtoBuilder> {
  /// Newest first
  @BuiltValueField(wireName: r'items')
  BuiltList<NotificationDto> get items;

  @BuiltValueField(wireName: r'unreadCount')
  num get unreadCount;

  InboxDto._();

  factory InboxDto([void updates(InboxDtoBuilder b)]) = _$InboxDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InboxDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InboxDto> get serializer => _$InboxDtoSerializer();
}

class _$InboxDtoSerializer implements PrimitiveSerializer<InboxDto> {
  @override
  final Iterable<Type> types = const [InboxDto, _$InboxDto];

  @override
  final String wireName = r'InboxDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InboxDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(NotificationDto)]),
    );
    yield r'unreadCount';
    yield serializers.serialize(
      object.unreadCount,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InboxDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InboxDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(NotificationDto)]),
          ) as BuiltList<NotificationDto>;
          result.items.replace(valueDes);
          break;
        case r'unreadCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.unreadCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InboxDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InboxDtoBuilder();
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

