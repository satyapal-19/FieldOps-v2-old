//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'conversation_dto.g.dart';

/// ConversationDto
///
/// Properties:
/// * [id] 
/// * [type] 
/// * [title] 
/// * [wardId] 
/// * [inspectorId] 
/// * [date] 
/// * [archived] - Read-only (a past squad chat)
/// * [canPost] - Whether you may post here (broadcasts are one-way)
/// * [memberIds] - Active members (staff ids)
/// * [lastMessageAt] 
/// * [unread] 
@BuiltValue()
abstract class ConversationDto implements Built<ConversationDto, ConversationDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  ConversationDtoTypeEnum get type;
  // enum typeEnum {  DIRECT,  SQUAD_TEAM,  WARD_BROADCAST,  CITY_BROADCAST,  };

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'wardId')
  String? get wardId;

  @BuiltValueField(wireName: r'inspectorId')
  String? get inspectorId;

  @BuiltValueField(wireName: r'date')
  String? get date;

  /// Read-only (a past squad chat)
  @BuiltValueField(wireName: r'archived')
  bool get archived;

  /// Whether you may post here (broadcasts are one-way)
  @BuiltValueField(wireName: r'canPost')
  bool get canPost;

  /// Active members (staff ids)
  @BuiltValueField(wireName: r'memberIds')
  BuiltList<String> get memberIds;

  @BuiltValueField(wireName: r'lastMessageAt')
  DateTime? get lastMessageAt;

  @BuiltValueField(wireName: r'unread')
  num get unread;

  ConversationDto._();

  factory ConversationDto([void updates(ConversationDtoBuilder b)]) = _$ConversationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConversationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConversationDto> get serializer => _$ConversationDtoSerializer();
}

class _$ConversationDtoSerializer implements PrimitiveSerializer<ConversationDto> {
  @override
  final Iterable<Type> types = const [ConversationDto, _$ConversationDto];

  @override
  final String wireName = r'ConversationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConversationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(ConversationDtoTypeEnum),
    );
    yield r'title';
    yield object.title == null ? null : serializers.serialize(
      object.title,
      specifiedType: const FullType.nullable(String),
    );
    yield r'wardId';
    yield object.wardId == null ? null : serializers.serialize(
      object.wardId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'inspectorId';
    yield object.inspectorId == null ? null : serializers.serialize(
      object.inspectorId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'date';
    yield object.date == null ? null : serializers.serialize(
      object.date,
      specifiedType: const FullType.nullable(String),
    );
    yield r'archived';
    yield serializers.serialize(
      object.archived,
      specifiedType: const FullType(bool),
    );
    yield r'canPost';
    yield serializers.serialize(
      object.canPost,
      specifiedType: const FullType(bool),
    );
    yield r'memberIds';
    yield serializers.serialize(
      object.memberIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'lastMessageAt';
    yield object.lastMessageAt == null ? null : serializers.serialize(
      object.lastMessageAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'unread';
    yield serializers.serialize(
      object.unread,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConversationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConversationDtoBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ConversationDtoTypeEnum),
          ) as ConversationDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.wardId = valueDes;
          break;
        case r'inspectorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.inspectorId = valueDes;
          break;
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.date = valueDes;
          break;
        case r'archived':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.archived = valueDes;
          break;
        case r'canPost':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canPost = valueDes;
          break;
        case r'memberIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.memberIds.replace(valueDes);
          break;
        case r'lastMessageAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastMessageAt = valueDes;
          break;
        case r'unread':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.unread = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConversationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConversationDtoBuilder();
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

class ConversationDtoTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DIRECT')
  static const ConversationDtoTypeEnum DIRECT = _$conversationDtoTypeEnum_DIRECT;
  @BuiltValueEnumConst(wireName: r'SQUAD_TEAM')
  static const ConversationDtoTypeEnum SQUAD_TEAM = _$conversationDtoTypeEnum_SQUAD_TEAM;
  @BuiltValueEnumConst(wireName: r'WARD_BROADCAST')
  static const ConversationDtoTypeEnum WARD_BROADCAST = _$conversationDtoTypeEnum_WARD_BROADCAST;
  @BuiltValueEnumConst(wireName: r'CITY_BROADCAST')
  static const ConversationDtoTypeEnum CITY_BROADCAST = _$conversationDtoTypeEnum_CITY_BROADCAST;

  static Serializer<ConversationDtoTypeEnum> get serializer => _$conversationDtoTypeEnumSerializer;

  const ConversationDtoTypeEnum._(String name): super(name);

  static BuiltSet<ConversationDtoTypeEnum> get values => _$conversationDtoTypeEnumValues;
  static ConversationDtoTypeEnum valueOf(String name) => _$conversationDtoTypeEnumValueOf(name);
}

