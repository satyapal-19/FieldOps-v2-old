// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tamper_event_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TamperEventDtoEventTypeEnum _$tamperEventDtoEventTypeEnum_GPS_DISABLED =
    const TamperEventDtoEventTypeEnum._('GPS_DISABLED');
const TamperEventDtoEventTypeEnum
    _$tamperEventDtoEventTypeEnum_PERMISSION_REVOKED =
    const TamperEventDtoEventTypeEnum._('PERMISSION_REVOKED');
const TamperEventDtoEventTypeEnum _$tamperEventDtoEventTypeEnum_AIRPLANE_MODE =
    const TamperEventDtoEventTypeEnum._('AIRPLANE_MODE');
const TamperEventDtoEventTypeEnum _$tamperEventDtoEventTypeEnum_DATA_DISABLED =
    const TamperEventDtoEventTypeEnum._('DATA_DISABLED');
const TamperEventDtoEventTypeEnum _$tamperEventDtoEventTypeEnum_DEVICE_OFFLINE =
    const TamperEventDtoEventTypeEnum._('DEVICE_OFFLINE');
const TamperEventDtoEventTypeEnum _$tamperEventDtoEventTypeEnum_MOCK_LOCATION =
    const TamperEventDtoEventTypeEnum._('MOCK_LOCATION');

TamperEventDtoEventTypeEnum _$tamperEventDtoEventTypeEnumValueOf(String name) {
  switch (name) {
    case 'GPS_DISABLED':
      return _$tamperEventDtoEventTypeEnum_GPS_DISABLED;
    case 'PERMISSION_REVOKED':
      return _$tamperEventDtoEventTypeEnum_PERMISSION_REVOKED;
    case 'AIRPLANE_MODE':
      return _$tamperEventDtoEventTypeEnum_AIRPLANE_MODE;
    case 'DATA_DISABLED':
      return _$tamperEventDtoEventTypeEnum_DATA_DISABLED;
    case 'DEVICE_OFFLINE':
      return _$tamperEventDtoEventTypeEnum_DEVICE_OFFLINE;
    case 'MOCK_LOCATION':
      return _$tamperEventDtoEventTypeEnum_MOCK_LOCATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TamperEventDtoEventTypeEnum>
    _$tamperEventDtoEventTypeEnumValues =
    BuiltSet<TamperEventDtoEventTypeEnum>(const <TamperEventDtoEventTypeEnum>[
  _$tamperEventDtoEventTypeEnum_GPS_DISABLED,
  _$tamperEventDtoEventTypeEnum_PERMISSION_REVOKED,
  _$tamperEventDtoEventTypeEnum_AIRPLANE_MODE,
  _$tamperEventDtoEventTypeEnum_DATA_DISABLED,
  _$tamperEventDtoEventTypeEnum_DEVICE_OFFLINE,
  _$tamperEventDtoEventTypeEnum_MOCK_LOCATION,
]);

Serializer<TamperEventDtoEventTypeEnum>
    _$tamperEventDtoEventTypeEnumSerializer =
    _$TamperEventDtoEventTypeEnumSerializer();

class _$TamperEventDtoEventTypeEnumSerializer
    implements PrimitiveSerializer<TamperEventDtoEventTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GPS_DISABLED': 'GPS_DISABLED',
    'PERMISSION_REVOKED': 'PERMISSION_REVOKED',
    'AIRPLANE_MODE': 'AIRPLANE_MODE',
    'DATA_DISABLED': 'DATA_DISABLED',
    'DEVICE_OFFLINE': 'DEVICE_OFFLINE',
    'MOCK_LOCATION': 'MOCK_LOCATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GPS_DISABLED': 'GPS_DISABLED',
    'PERMISSION_REVOKED': 'PERMISSION_REVOKED',
    'AIRPLANE_MODE': 'AIRPLANE_MODE',
    'DATA_DISABLED': 'DATA_DISABLED',
    'DEVICE_OFFLINE': 'DEVICE_OFFLINE',
    'MOCK_LOCATION': 'MOCK_LOCATION',
  };

  @override
  final Iterable<Type> types = const <Type>[TamperEventDtoEventTypeEnum];
  @override
  final String wireName = 'TamperEventDtoEventTypeEnum';

  @override
  Object serialize(Serializers serializers, TamperEventDtoEventTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TamperEventDtoEventTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TamperEventDtoEventTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TamperEventDto extends TamperEventDto {
  @override
  final String clientUuid;
  @override
  final TamperEventDtoEventTypeEnum eventType;
  @override
  final DateTime startedAt;
  @override
  final DateTime? resolvedAt;
  @override
  final num? lastLatitude;
  @override
  final num? lastLongitude;

  factory _$TamperEventDto([void Function(TamperEventDtoBuilder)? updates]) =>
      (TamperEventDtoBuilder()..update(updates))._build();

  _$TamperEventDto._(
      {required this.clientUuid,
      required this.eventType,
      required this.startedAt,
      this.resolvedAt,
      this.lastLatitude,
      this.lastLongitude})
      : super._();
  @override
  TamperEventDto rebuild(void Function(TamperEventDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TamperEventDtoBuilder toBuilder() => TamperEventDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TamperEventDto &&
        clientUuid == other.clientUuid &&
        eventType == other.eventType &&
        startedAt == other.startedAt &&
        resolvedAt == other.resolvedAt &&
        lastLatitude == other.lastLatitude &&
        lastLongitude == other.lastLongitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientUuid.hashCode);
    _$hash = $jc(_$hash, eventType.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, resolvedAt.hashCode);
    _$hash = $jc(_$hash, lastLatitude.hashCode);
    _$hash = $jc(_$hash, lastLongitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TamperEventDto')
          ..add('clientUuid', clientUuid)
          ..add('eventType', eventType)
          ..add('startedAt', startedAt)
          ..add('resolvedAt', resolvedAt)
          ..add('lastLatitude', lastLatitude)
          ..add('lastLongitude', lastLongitude))
        .toString();
  }
}

class TamperEventDtoBuilder
    implements Builder<TamperEventDto, TamperEventDtoBuilder> {
  _$TamperEventDto? _$v;

  String? _clientUuid;
  String? get clientUuid => _$this._clientUuid;
  set clientUuid(String? clientUuid) => _$this._clientUuid = clientUuid;

  TamperEventDtoEventTypeEnum? _eventType;
  TamperEventDtoEventTypeEnum? get eventType => _$this._eventType;
  set eventType(TamperEventDtoEventTypeEnum? eventType) =>
      _$this._eventType = eventType;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _resolvedAt;
  DateTime? get resolvedAt => _$this._resolvedAt;
  set resolvedAt(DateTime? resolvedAt) => _$this._resolvedAt = resolvedAt;

  num? _lastLatitude;
  num? get lastLatitude => _$this._lastLatitude;
  set lastLatitude(num? lastLatitude) => _$this._lastLatitude = lastLatitude;

  num? _lastLongitude;
  num? get lastLongitude => _$this._lastLongitude;
  set lastLongitude(num? lastLongitude) =>
      _$this._lastLongitude = lastLongitude;

  TamperEventDtoBuilder() {
    TamperEventDto._defaults(this);
  }

  TamperEventDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientUuid = $v.clientUuid;
      _eventType = $v.eventType;
      _startedAt = $v.startedAt;
      _resolvedAt = $v.resolvedAt;
      _lastLatitude = $v.lastLatitude;
      _lastLongitude = $v.lastLongitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TamperEventDto other) {
    _$v = other as _$TamperEventDto;
  }

  @override
  void update(void Function(TamperEventDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TamperEventDto build() => _build();

  _$TamperEventDto _build() {
    final _$result = _$v ??
        _$TamperEventDto._(
          clientUuid: BuiltValueNullFieldError.checkNotNull(
              clientUuid, r'TamperEventDto', 'clientUuid'),
          eventType: BuiltValueNullFieldError.checkNotNull(
              eventType, r'TamperEventDto', 'eventType'),
          startedAt: BuiltValueNullFieldError.checkNotNull(
              startedAt, r'TamperEventDto', 'startedAt'),
          resolvedAt: resolvedAt,
          lastLatitude: lastLatitude,
          lastLongitude: lastLongitude,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
