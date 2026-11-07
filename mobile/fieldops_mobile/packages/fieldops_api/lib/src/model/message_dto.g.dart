// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MessageDtoTypeEnum _$messageDtoTypeEnum_TEXT =
    const MessageDtoTypeEnum._('TEXT');
const MessageDtoTypeEnum _$messageDtoTypeEnum_VOICE =
    const MessageDtoTypeEnum._('VOICE');
const MessageDtoTypeEnum _$messageDtoTypeEnum_IMAGE =
    const MessageDtoTypeEnum._('IMAGE');
const MessageDtoTypeEnum _$messageDtoTypeEnum_LOCATION =
    const MessageDtoTypeEnum._('LOCATION');

MessageDtoTypeEnum _$messageDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'TEXT':
      return _$messageDtoTypeEnum_TEXT;
    case 'VOICE':
      return _$messageDtoTypeEnum_VOICE;
    case 'IMAGE':
      return _$messageDtoTypeEnum_IMAGE;
    case 'LOCATION':
      return _$messageDtoTypeEnum_LOCATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MessageDtoTypeEnum> _$messageDtoTypeEnumValues =
    BuiltSet<MessageDtoTypeEnum>(const <MessageDtoTypeEnum>[
  _$messageDtoTypeEnum_TEXT,
  _$messageDtoTypeEnum_VOICE,
  _$messageDtoTypeEnum_IMAGE,
  _$messageDtoTypeEnum_LOCATION,
]);

Serializer<MessageDtoTypeEnum> _$messageDtoTypeEnumSerializer =
    _$MessageDtoTypeEnumSerializer();

class _$MessageDtoTypeEnumSerializer
    implements PrimitiveSerializer<MessageDtoTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEXT': 'TEXT',
    'VOICE': 'VOICE',
    'IMAGE': 'IMAGE',
    'LOCATION': 'LOCATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEXT': 'TEXT',
    'VOICE': 'VOICE',
    'IMAGE': 'IMAGE',
    'LOCATION': 'LOCATION',
  };

  @override
  final Iterable<Type> types = const <Type>[MessageDtoTypeEnum];
  @override
  final String wireName = 'MessageDtoTypeEnum';

  @override
  Object serialize(Serializers serializers, MessageDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MessageDtoTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MessageDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MessageDto extends MessageDto {
  @override
  final String id;
  @override
  final String conversationId;
  @override
  final String senderId;
  @override
  final MessageDtoTypeEnum type;
  @override
  final String? text;
  @override
  final bool hasMedia;
  @override
  final num? durationSec;
  @override
  final num? latitude;
  @override
  final num? longitude;
  @override
  final DateTime createdAt;

  factory _$MessageDto([void Function(MessageDtoBuilder)? updates]) =>
      (MessageDtoBuilder()..update(updates))._build();

  _$MessageDto._(
      {required this.id,
      required this.conversationId,
      required this.senderId,
      required this.type,
      this.text,
      required this.hasMedia,
      this.durationSec,
      this.latitude,
      this.longitude,
      required this.createdAt})
      : super._();
  @override
  MessageDto rebuild(void Function(MessageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MessageDtoBuilder toBuilder() => MessageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MessageDto &&
        id == other.id &&
        conversationId == other.conversationId &&
        senderId == other.senderId &&
        type == other.type &&
        text == other.text &&
        hasMedia == other.hasMedia &&
        durationSec == other.durationSec &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, conversationId.hashCode);
    _$hash = $jc(_$hash, senderId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, hasMedia.hashCode);
    _$hash = $jc(_$hash, durationSec.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MessageDto')
          ..add('id', id)
          ..add('conversationId', conversationId)
          ..add('senderId', senderId)
          ..add('type', type)
          ..add('text', text)
          ..add('hasMedia', hasMedia)
          ..add('durationSec', durationSec)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class MessageDtoBuilder implements Builder<MessageDto, MessageDtoBuilder> {
  _$MessageDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _conversationId;
  String? get conversationId => _$this._conversationId;
  set conversationId(String? conversationId) =>
      _$this._conversationId = conversationId;

  String? _senderId;
  String? get senderId => _$this._senderId;
  set senderId(String? senderId) => _$this._senderId = senderId;

  MessageDtoTypeEnum? _type;
  MessageDtoTypeEnum? get type => _$this._type;
  set type(MessageDtoTypeEnum? type) => _$this._type = type;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  bool? _hasMedia;
  bool? get hasMedia => _$this._hasMedia;
  set hasMedia(bool? hasMedia) => _$this._hasMedia = hasMedia;

  num? _durationSec;
  num? get durationSec => _$this._durationSec;
  set durationSec(num? durationSec) => _$this._durationSec = durationSec;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MessageDtoBuilder() {
    MessageDto._defaults(this);
  }

  MessageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _conversationId = $v.conversationId;
      _senderId = $v.senderId;
      _type = $v.type;
      _text = $v.text;
      _hasMedia = $v.hasMedia;
      _durationSec = $v.durationSec;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MessageDto other) {
    _$v = other as _$MessageDto;
  }

  @override
  void update(void Function(MessageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MessageDto build() => _build();

  _$MessageDto _build() {
    final _$result = _$v ??
        _$MessageDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'MessageDto', 'id'),
          conversationId: BuiltValueNullFieldError.checkNotNull(
              conversationId, r'MessageDto', 'conversationId'),
          senderId: BuiltValueNullFieldError.checkNotNull(
              senderId, r'MessageDto', 'senderId'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'MessageDto', 'type'),
          text: text,
          hasMedia: BuiltValueNullFieldError.checkNotNull(
              hasMedia, r'MessageDto', 'hasMedia'),
          durationSec: durationSec,
          latitude: latitude,
          longitude: longitude,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'MessageDto', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
