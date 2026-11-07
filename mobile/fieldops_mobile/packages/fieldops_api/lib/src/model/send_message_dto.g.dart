// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SendMessageDtoTypeEnum _$sendMessageDtoTypeEnum_TEXT =
    const SendMessageDtoTypeEnum._('TEXT');
const SendMessageDtoTypeEnum _$sendMessageDtoTypeEnum_VOICE =
    const SendMessageDtoTypeEnum._('VOICE');
const SendMessageDtoTypeEnum _$sendMessageDtoTypeEnum_IMAGE =
    const SendMessageDtoTypeEnum._('IMAGE');
const SendMessageDtoTypeEnum _$sendMessageDtoTypeEnum_LOCATION =
    const SendMessageDtoTypeEnum._('LOCATION');

SendMessageDtoTypeEnum _$sendMessageDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'TEXT':
      return _$sendMessageDtoTypeEnum_TEXT;
    case 'VOICE':
      return _$sendMessageDtoTypeEnum_VOICE;
    case 'IMAGE':
      return _$sendMessageDtoTypeEnum_IMAGE;
    case 'LOCATION':
      return _$sendMessageDtoTypeEnum_LOCATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SendMessageDtoTypeEnum> _$sendMessageDtoTypeEnumValues =
    BuiltSet<SendMessageDtoTypeEnum>(const <SendMessageDtoTypeEnum>[
  _$sendMessageDtoTypeEnum_TEXT,
  _$sendMessageDtoTypeEnum_VOICE,
  _$sendMessageDtoTypeEnum_IMAGE,
  _$sendMessageDtoTypeEnum_LOCATION,
]);

Serializer<SendMessageDtoTypeEnum> _$sendMessageDtoTypeEnumSerializer =
    _$SendMessageDtoTypeEnumSerializer();

class _$SendMessageDtoTypeEnumSerializer
    implements PrimitiveSerializer<SendMessageDtoTypeEnum> {
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
  final Iterable<Type> types = const <Type>[SendMessageDtoTypeEnum];
  @override
  final String wireName = 'SendMessageDtoTypeEnum';

  @override
  Object serialize(Serializers serializers, SendMessageDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SendMessageDtoTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SendMessageDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SendMessageDto extends SendMessageDto {
  @override
  final String clientUuid;
  @override
  final SendMessageDtoTypeEnum type;
  @override
  final String? text;
  @override
  final String? uploadId;
  @override
  final num? durationSec;
  @override
  final num? latitude;
  @override
  final num? longitude;

  factory _$SendMessageDto([void Function(SendMessageDtoBuilder)? updates]) =>
      (SendMessageDtoBuilder()..update(updates))._build();

  _$SendMessageDto._(
      {required this.clientUuid,
      required this.type,
      this.text,
      this.uploadId,
      this.durationSec,
      this.latitude,
      this.longitude})
      : super._();
  @override
  SendMessageDto rebuild(void Function(SendMessageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SendMessageDtoBuilder toBuilder() => SendMessageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SendMessageDto &&
        clientUuid == other.clientUuid &&
        type == other.type &&
        text == other.text &&
        uploadId == other.uploadId &&
        durationSec == other.durationSec &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientUuid.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, uploadId.hashCode);
    _$hash = $jc(_$hash, durationSec.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SendMessageDto')
          ..add('clientUuid', clientUuid)
          ..add('type', type)
          ..add('text', text)
          ..add('uploadId', uploadId)
          ..add('durationSec', durationSec)
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class SendMessageDtoBuilder
    implements Builder<SendMessageDto, SendMessageDtoBuilder> {
  _$SendMessageDto? _$v;

  String? _clientUuid;
  String? get clientUuid => _$this._clientUuid;
  set clientUuid(String? clientUuid) => _$this._clientUuid = clientUuid;

  SendMessageDtoTypeEnum? _type;
  SendMessageDtoTypeEnum? get type => _$this._type;
  set type(SendMessageDtoTypeEnum? type) => _$this._type = type;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _uploadId;
  String? get uploadId => _$this._uploadId;
  set uploadId(String? uploadId) => _$this._uploadId = uploadId;

  num? _durationSec;
  num? get durationSec => _$this._durationSec;
  set durationSec(num? durationSec) => _$this._durationSec = durationSec;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  SendMessageDtoBuilder() {
    SendMessageDto._defaults(this);
  }

  SendMessageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientUuid = $v.clientUuid;
      _type = $v.type;
      _text = $v.text;
      _uploadId = $v.uploadId;
      _durationSec = $v.durationSec;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SendMessageDto other) {
    _$v = other as _$SendMessageDto;
  }

  @override
  void update(void Function(SendMessageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SendMessageDto build() => _build();

  _$SendMessageDto _build() {
    final _$result = _$v ??
        _$SendMessageDto._(
          clientUuid: BuiltValueNullFieldError.checkNotNull(
              clientUuid, r'SendMessageDto', 'clientUuid'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'SendMessageDto', 'type'),
          text: text,
          uploadId: uploadId,
          durationSec: durationSec,
          latitude: latitude,
          longitude: longitude,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
