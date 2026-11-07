//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'message_dto.g.dart';

/// MessageDto
///
/// Properties:
/// * [id] 
/// * [conversationId] 
/// * [senderId] 
/// * [type] 
/// * [text] 
/// * [hasMedia] - Voice note or photo attached (GET /chat/messages/{id}/media)
/// * [durationSec] 
/// * [latitude] 
/// * [longitude] 
/// * [createdAt] 
@BuiltValue()
abstract class MessageDto implements Built<MessageDto, MessageDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'conversationId')
  String get conversationId;

  @BuiltValueField(wireName: r'senderId')
  String get senderId;

  @BuiltValueField(wireName: r'type')
  MessageDtoTypeEnum get type;
  // enum typeEnum {  TEXT,  VOICE,  IMAGE,  LOCATION,  };

  @BuiltValueField(wireName: r'text')
  String? get text;

  /// Voice note or photo attached (GET /chat/messages/{id}/media)
  @BuiltValueField(wireName: r'hasMedia')
  bool get hasMedia;

  @BuiltValueField(wireName: r'durationSec')
  num? get durationSec;

  @BuiltValueField(wireName: r'latitude')
  num? get latitude;

  @BuiltValueField(wireName: r'longitude')
  num? get longitude;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  MessageDto._();

  factory MessageDto([void updates(MessageDtoBuilder b)]) = _$MessageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MessageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MessageDto> get serializer => _$MessageDtoSerializer();
}

class _$MessageDtoSerializer implements PrimitiveSerializer<MessageDto> {
  @override
  final Iterable<Type> types = const [MessageDto, _$MessageDto];

  @override
  final String wireName = r'MessageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MessageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'conversationId';
    yield serializers.serialize(
      object.conversationId,
      specifiedType: const FullType(String),
    );
    yield r'senderId';
    yield serializers.serialize(
      object.senderId,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(MessageDtoTypeEnum),
    );
    yield r'text';
    yield object.text == null ? null : serializers.serialize(
      object.text,
      specifiedType: const FullType.nullable(String),
    );
    yield r'hasMedia';
    yield serializers.serialize(
      object.hasMedia,
      specifiedType: const FullType(bool),
    );
    yield r'durationSec';
    yield object.durationSec == null ? null : serializers.serialize(
      object.durationSec,
      specifiedType: const FullType.nullable(num),
    );
    yield r'latitude';
    yield object.latitude == null ? null : serializers.serialize(
      object.latitude,
      specifiedType: const FullType.nullable(num),
    );
    yield r'longitude';
    yield object.longitude == null ? null : serializers.serialize(
      object.longitude,
      specifiedType: const FullType.nullable(num),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MessageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MessageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'conversationId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.conversationId = valueDes;
          break;
        case r'senderId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.senderId = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MessageDtoTypeEnum),
          ) as MessageDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.text = valueDes;
          break;
        case r'hasMedia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMedia = valueDes;
          break;
        case r'durationSec':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.durationSec = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.longitude = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MessageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MessageDtoBuilder();
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

class MessageDtoTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEXT')
  static const MessageDtoTypeEnum TEXT = _$messageDtoTypeEnum_TEXT;
  @BuiltValueEnumConst(wireName: r'VOICE')
  static const MessageDtoTypeEnum VOICE = _$messageDtoTypeEnum_VOICE;
  @BuiltValueEnumConst(wireName: r'IMAGE')
  static const MessageDtoTypeEnum IMAGE = _$messageDtoTypeEnum_IMAGE;
  @BuiltValueEnumConst(wireName: r'LOCATION')
  static const MessageDtoTypeEnum LOCATION = _$messageDtoTypeEnum_LOCATION;

  static Serializer<MessageDtoTypeEnum> get serializer => _$messageDtoTypeEnumSerializer;

  const MessageDtoTypeEnum._(String name): super(name);

  static BuiltSet<MessageDtoTypeEnum> get values => _$messageDtoTypeEnumValues;
  static MessageDtoTypeEnum valueOf(String name) => _$messageDtoTypeEnumValueOf(name);
}

