//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_dto.g.dart';

/// NotificationDto
///
/// Properties:
/// * [id] 
/// * [kind] 
/// * [priority] 
/// * [title] 
/// * [titleMr] 
/// * [body] 
/// * [bodyMr] 
/// * [refType] 
/// * [refId] 
/// * [createdAt] 
/// * [readAt] 
@BuiltValue()
abstract class NotificationDto implements Built<NotificationDto, NotificationDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  NotificationDtoKindEnum get kind;
  // enum kindEnum {  SPOT_CHECK,  ALERT,  TASK,  CHAT,  REQUEST,  SYSTEM,  };

  @BuiltValueField(wireName: r'priority')
  NotificationDtoPriorityEnum get priority;
  // enum priorityEnum {  HIGH,  NORMAL,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'titleMr')
  String? get titleMr;

  @BuiltValueField(wireName: r'body')
  String? get body;

  @BuiltValueField(wireName: r'bodyMr')
  String? get bodyMr;

  @BuiltValueField(wireName: r'refType')
  String? get refType;

  @BuiltValueField(wireName: r'refId')
  String? get refId;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'readAt')
  DateTime? get readAt;

  NotificationDto._();

  factory NotificationDto([void updates(NotificationDtoBuilder b)]) = _$NotificationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationDto> get serializer => _$NotificationDtoSerializer();
}

class _$NotificationDtoSerializer implements PrimitiveSerializer<NotificationDto> {
  @override
  final Iterable<Type> types = const [NotificationDto, _$NotificationDto];

  @override
  final String wireName = r'NotificationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(NotificationDtoKindEnum),
    );
    yield r'priority';
    yield serializers.serialize(
      object.priority,
      specifiedType: const FullType(NotificationDtoPriorityEnum),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'titleMr';
    yield object.titleMr == null ? null : serializers.serialize(
      object.titleMr,
      specifiedType: const FullType.nullable(String),
    );
    yield r'body';
    yield object.body == null ? null : serializers.serialize(
      object.body,
      specifiedType: const FullType.nullable(String),
    );
    yield r'bodyMr';
    yield object.bodyMr == null ? null : serializers.serialize(
      object.bodyMr,
      specifiedType: const FullType.nullable(String),
    );
    yield r'refType';
    yield object.refType == null ? null : serializers.serialize(
      object.refType,
      specifiedType: const FullType.nullable(String),
    );
    yield r'refId';
    yield object.refId == null ? null : serializers.serialize(
      object.refId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'readAt';
    yield object.readAt == null ? null : serializers.serialize(
      object.readAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationDtoBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NotificationDtoKindEnum),
          ) as NotificationDtoKindEnum;
          result.kind = valueDes;
          break;
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NotificationDtoPriorityEnum),
          ) as NotificationDtoPriorityEnum;
          result.priority = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'titleMr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.titleMr = valueDes;
          break;
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.body = valueDes;
          break;
        case r'bodyMr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bodyMr = valueDes;
          break;
        case r'refType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.refType = valueDes;
          break;
        case r'refId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.refId = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'readAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.readAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationDtoBuilder();
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

class NotificationDtoKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SPOT_CHECK')
  static const NotificationDtoKindEnum SPOT_CHECK = _$notificationDtoKindEnum_SPOT_CHECK;
  @BuiltValueEnumConst(wireName: r'ALERT')
  static const NotificationDtoKindEnum ALERT = _$notificationDtoKindEnum_ALERT;
  @BuiltValueEnumConst(wireName: r'TASK')
  static const NotificationDtoKindEnum TASK = _$notificationDtoKindEnum_TASK;
  @BuiltValueEnumConst(wireName: r'CHAT')
  static const NotificationDtoKindEnum CHAT = _$notificationDtoKindEnum_CHAT;
  @BuiltValueEnumConst(wireName: r'REQUEST')
  static const NotificationDtoKindEnum REQUEST = _$notificationDtoKindEnum_REQUEST;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const NotificationDtoKindEnum SYSTEM = _$notificationDtoKindEnum_SYSTEM;

  static Serializer<NotificationDtoKindEnum> get serializer => _$notificationDtoKindEnumSerializer;

  const NotificationDtoKindEnum._(String name): super(name);

  static BuiltSet<NotificationDtoKindEnum> get values => _$notificationDtoKindEnumValues;
  static NotificationDtoKindEnum valueOf(String name) => _$notificationDtoKindEnumValueOf(name);
}

class NotificationDtoPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HIGH')
  static const NotificationDtoPriorityEnum HIGH = _$notificationDtoPriorityEnum_HIGH;
  @BuiltValueEnumConst(wireName: r'NORMAL')
  static const NotificationDtoPriorityEnum NORMAL = _$notificationDtoPriorityEnum_NORMAL;

  static Serializer<NotificationDtoPriorityEnum> get serializer => _$notificationDtoPriorityEnumSerializer;

  const NotificationDtoPriorityEnum._(String name): super(name);

  static BuiltSet<NotificationDtoPriorityEnum> get values => _$notificationDtoPriorityEnumValues;
  static NotificationDtoPriorityEnum valueOf(String name) => _$notificationDtoPriorityEnumValueOf(name);
}

