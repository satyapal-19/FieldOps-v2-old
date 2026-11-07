//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'send_message_dto.g.dart';

/// SendMessageDto
///
/// Properties:
/// * [clientUuid] - Made on the phone: a retry sends once
/// * [type] 
/// * [text] - TEXT
/// * [uploadId] - VOICE / IMAGE: your upload (POST /uploads)
/// * [durationSec] - VOICE: length in seconds
/// * [latitude] 
/// * [longitude] 
@BuiltValue()
abstract class SendMessageDto implements Built<SendMessageDto, SendMessageDtoBuilder> {
  /// Made on the phone: a retry sends once
  @BuiltValueField(wireName: r'clientUuid')
  String get clientUuid;

  @BuiltValueField(wireName: r'type')
  SendMessageDtoTypeEnum get type;
  // enum typeEnum {  TEXT,  VOICE,  IMAGE,  LOCATION,  };

  /// TEXT
  @BuiltValueField(wireName: r'text')
  String? get text;

  /// VOICE / IMAGE: your upload (POST /uploads)
  @BuiltValueField(wireName: r'uploadId')
  String? get uploadId;

  /// VOICE: length in seconds
  @BuiltValueField(wireName: r'durationSec')
  num? get durationSec;

  @BuiltValueField(wireName: r'latitude')
  num? get latitude;

  @BuiltValueField(wireName: r'longitude')
  num? get longitude;

  SendMessageDto._();

  factory SendMessageDto([void updates(SendMessageDtoBuilder b)]) = _$SendMessageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SendMessageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SendMessageDto> get serializer => _$SendMessageDtoSerializer();
}

class _$SendMessageDtoSerializer implements PrimitiveSerializer<SendMessageDto> {
  @override
  final Iterable<Type> types = const [SendMessageDto, _$SendMessageDto];

  @override
  final String wireName = r'SendMessageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SendMessageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clientUuid';
    yield serializers.serialize(
      object.clientUuid,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(SendMessageDtoTypeEnum),
    );
    if (object.text != null) {
      yield r'text';
      yield serializers.serialize(
        object.text,
        specifiedType: const FullType(String),
      );
    }
    if (object.uploadId != null) {
      yield r'uploadId';
      yield serializers.serialize(
        object.uploadId,
        specifiedType: const FullType(String),
      );
    }
    if (object.durationSec != null) {
      yield r'durationSec';
      yield serializers.serialize(
        object.durationSec,
        specifiedType: const FullType(num),
      );
    }
    if (object.latitude != null) {
      yield r'latitude';
      yield serializers.serialize(
        object.latitude,
        specifiedType: const FullType(num),
      );
    }
    if (object.longitude != null) {
      yield r'longitude';
      yield serializers.serialize(
        object.longitude,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SendMessageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SendMessageDtoBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SendMessageDtoTypeEnum),
          ) as SendMessageDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'uploadId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uploadId = valueDes;
          break;
        case r'durationSec':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.durationSec = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SendMessageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SendMessageDtoBuilder();
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

class SendMessageDtoTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEXT')
  static const SendMessageDtoTypeEnum TEXT = _$sendMessageDtoTypeEnum_TEXT;
  @BuiltValueEnumConst(wireName: r'VOICE')
  static const SendMessageDtoTypeEnum VOICE = _$sendMessageDtoTypeEnum_VOICE;
  @BuiltValueEnumConst(wireName: r'IMAGE')
  static const SendMessageDtoTypeEnum IMAGE = _$sendMessageDtoTypeEnum_IMAGE;
  @BuiltValueEnumConst(wireName: r'LOCATION')
  static const SendMessageDtoTypeEnum LOCATION = _$sendMessageDtoTypeEnum_LOCATION;

  static Serializer<SendMessageDtoTypeEnum> get serializer => _$sendMessageDtoTypeEnumSerializer;

  const SendMessageDtoTypeEnum._(String name): super(name);

  static BuiltSet<SendMessageDtoTypeEnum> get values => _$sendMessageDtoTypeEnumValues;
  static SendMessageDtoTypeEnum valueOf(String name) => _$sendMessageDtoTypeEnumValueOf(name);
}

