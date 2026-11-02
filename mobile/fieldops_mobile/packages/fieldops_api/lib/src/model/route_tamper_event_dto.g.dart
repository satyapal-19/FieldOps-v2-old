// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_tamper_event_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RouteTamperEventDtoEventTypeEnum
    _$routeTamperEventDtoEventTypeEnum_GPS_DISABLED =
    const RouteTamperEventDtoEventTypeEnum._('GPS_DISABLED');
const RouteTamperEventDtoEventTypeEnum
    _$routeTamperEventDtoEventTypeEnum_PERMISSION_REVOKED =
    const RouteTamperEventDtoEventTypeEnum._('PERMISSION_REVOKED');
const RouteTamperEventDtoEventTypeEnum
    _$routeTamperEventDtoEventTypeEnum_AIRPLANE_MODE =
    const RouteTamperEventDtoEventTypeEnum._('AIRPLANE_MODE');
const RouteTamperEventDtoEventTypeEnum
    _$routeTamperEventDtoEventTypeEnum_DATA_DISABLED =
    const RouteTamperEventDtoEventTypeEnum._('DATA_DISABLED');
const RouteTamperEventDtoEventTypeEnum
    _$routeTamperEventDtoEventTypeEnum_DEVICE_OFFLINE =
    const RouteTamperEventDtoEventTypeEnum._('DEVICE_OFFLINE');
const RouteTamperEventDtoEventTypeEnum
    _$routeTamperEventDtoEventTypeEnum_MOCK_LOCATION =
    const RouteTamperEventDtoEventTypeEnum._('MOCK_LOCATION');
const RouteTamperEventDtoEventTypeEnum
    _$routeTamperEventDtoEventTypeEnum_SILENT_GAP =
    const RouteTamperEventDtoEventTypeEnum._('SILENT_GAP');

RouteTamperEventDtoEventTypeEnum _$routeTamperEventDtoEventTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'GPS_DISABLED':
      return _$routeTamperEventDtoEventTypeEnum_GPS_DISABLED;
    case 'PERMISSION_REVOKED':
      return _$routeTamperEventDtoEventTypeEnum_PERMISSION_REVOKED;
    case 'AIRPLANE_MODE':
      return _$routeTamperEventDtoEventTypeEnum_AIRPLANE_MODE;
    case 'DATA_DISABLED':
      return _$routeTamperEventDtoEventTypeEnum_DATA_DISABLED;
    case 'DEVICE_OFFLINE':
      return _$routeTamperEventDtoEventTypeEnum_DEVICE_OFFLINE;
    case 'MOCK_LOCATION':
      return _$routeTamperEventDtoEventTypeEnum_MOCK_LOCATION;
    case 'SILENT_GAP':
      return _$routeTamperEventDtoEventTypeEnum_SILENT_GAP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RouteTamperEventDtoEventTypeEnum>
    _$routeTamperEventDtoEventTypeEnumValues = BuiltSet<
        RouteTamperEventDtoEventTypeEnum>(const <RouteTamperEventDtoEventTypeEnum>[
  _$routeTamperEventDtoEventTypeEnum_GPS_DISABLED,
  _$routeTamperEventDtoEventTypeEnum_PERMISSION_REVOKED,
  _$routeTamperEventDtoEventTypeEnum_AIRPLANE_MODE,
  _$routeTamperEventDtoEventTypeEnum_DATA_DISABLED,
  _$routeTamperEventDtoEventTypeEnum_DEVICE_OFFLINE,
  _$routeTamperEventDtoEventTypeEnum_MOCK_LOCATION,
  _$routeTamperEventDtoEventTypeEnum_SILENT_GAP,
]);

const RouteTamperEventDtoSource_Enum _$routeTamperEventDtoSourceEnum_DEVICE =
    const RouteTamperEventDtoSource_Enum._('DEVICE');
const RouteTamperEventDtoSource_Enum _$routeTamperEventDtoSourceEnum_SERVER =
    const RouteTamperEventDtoSource_Enum._('SERVER');

RouteTamperEventDtoSource_Enum _$routeTamperEventDtoSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'DEVICE':
      return _$routeTamperEventDtoSourceEnum_DEVICE;
    case 'SERVER':
      return _$routeTamperEventDtoSourceEnum_SERVER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RouteTamperEventDtoSource_Enum>
    _$routeTamperEventDtoSourceEnumValues = BuiltSet<
        RouteTamperEventDtoSource_Enum>(const <RouteTamperEventDtoSource_Enum>[
  _$routeTamperEventDtoSourceEnum_DEVICE,
  _$routeTamperEventDtoSourceEnum_SERVER,
]);

Serializer<RouteTamperEventDtoEventTypeEnum>
    _$routeTamperEventDtoEventTypeEnumSerializer =
    _$RouteTamperEventDtoEventTypeEnumSerializer();
Serializer<RouteTamperEventDtoSource_Enum>
    _$routeTamperEventDtoSourceEnumSerializer =
    _$RouteTamperEventDtoSource_EnumSerializer();

class _$RouteTamperEventDtoEventTypeEnumSerializer
    implements PrimitiveSerializer<RouteTamperEventDtoEventTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GPS_DISABLED': 'GPS_DISABLED',
    'PERMISSION_REVOKED': 'PERMISSION_REVOKED',
    'AIRPLANE_MODE': 'AIRPLANE_MODE',
    'DATA_DISABLED': 'DATA_DISABLED',
    'DEVICE_OFFLINE': 'DEVICE_OFFLINE',
    'MOCK_LOCATION': 'MOCK_LOCATION',
    'SILENT_GAP': 'SILENT_GAP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GPS_DISABLED': 'GPS_DISABLED',
    'PERMISSION_REVOKED': 'PERMISSION_REVOKED',
    'AIRPLANE_MODE': 'AIRPLANE_MODE',
    'DATA_DISABLED': 'DATA_DISABLED',
    'DEVICE_OFFLINE': 'DEVICE_OFFLINE',
    'MOCK_LOCATION': 'MOCK_LOCATION',
    'SILENT_GAP': 'SILENT_GAP',
  };

  @override
  final Iterable<Type> types = const <Type>[RouteTamperEventDtoEventTypeEnum];
  @override
  final String wireName = 'RouteTamperEventDtoEventTypeEnum';

  @override
  Object serialize(
          Serializers serializers, RouteTamperEventDtoEventTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RouteTamperEventDtoEventTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RouteTamperEventDtoEventTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RouteTamperEventDtoSource_EnumSerializer
    implements PrimitiveSerializer<RouteTamperEventDtoSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DEVICE': 'DEVICE',
    'SERVER': 'SERVER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DEVICE': 'DEVICE',
    'SERVER': 'SERVER',
  };

  @override
  final Iterable<Type> types = const <Type>[RouteTamperEventDtoSource_Enum];
  @override
  final String wireName = 'RouteTamperEventDtoSource_Enum';

  @override
  Object serialize(
          Serializers serializers, RouteTamperEventDtoSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RouteTamperEventDtoSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RouteTamperEventDtoSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RouteTamperEventDto extends RouteTamperEventDto {
  @override
  final RouteTamperEventDtoEventTypeEnum eventType;
  @override
  final RouteTamperEventDtoSource_Enum source_;
  @override
  final DateTime startedAt;
  @override
  final DateTime? resolvedAt;

  factory _$RouteTamperEventDto(
          [void Function(RouteTamperEventDtoBuilder)? updates]) =>
      (RouteTamperEventDtoBuilder()..update(updates))._build();

  _$RouteTamperEventDto._(
      {required this.eventType,
      required this.source_,
      required this.startedAt,
      this.resolvedAt})
      : super._();
  @override
  RouteTamperEventDto rebuild(
          void Function(RouteTamperEventDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteTamperEventDtoBuilder toBuilder() =>
      RouteTamperEventDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteTamperEventDto &&
        eventType == other.eventType &&
        source_ == other.source_ &&
        startedAt == other.startedAt &&
        resolvedAt == other.resolvedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, eventType.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, resolvedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteTamperEventDto')
          ..add('eventType', eventType)
          ..add('source_', source_)
          ..add('startedAt', startedAt)
          ..add('resolvedAt', resolvedAt))
        .toString();
  }
}

class RouteTamperEventDtoBuilder
    implements Builder<RouteTamperEventDto, RouteTamperEventDtoBuilder> {
  _$RouteTamperEventDto? _$v;

  RouteTamperEventDtoEventTypeEnum? _eventType;
  RouteTamperEventDtoEventTypeEnum? get eventType => _$this._eventType;
  set eventType(RouteTamperEventDtoEventTypeEnum? eventType) =>
      _$this._eventType = eventType;

  RouteTamperEventDtoSource_Enum? _source_;
  RouteTamperEventDtoSource_Enum? get source_ => _$this._source_;
  set source_(RouteTamperEventDtoSource_Enum? source_) =>
      _$this._source_ = source_;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _resolvedAt;
  DateTime? get resolvedAt => _$this._resolvedAt;
  set resolvedAt(DateTime? resolvedAt) => _$this._resolvedAt = resolvedAt;

  RouteTamperEventDtoBuilder() {
    RouteTamperEventDto._defaults(this);
  }

  RouteTamperEventDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _eventType = $v.eventType;
      _source_ = $v.source_;
      _startedAt = $v.startedAt;
      _resolvedAt = $v.resolvedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteTamperEventDto other) {
    _$v = other as _$RouteTamperEventDto;
  }

  @override
  void update(void Function(RouteTamperEventDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteTamperEventDto build() => _build();

  _$RouteTamperEventDto _build() {
    final _$result = _$v ??
        _$RouteTamperEventDto._(
          eventType: BuiltValueNullFieldError.checkNotNull(
              eventType, r'RouteTamperEventDto', 'eventType'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'RouteTamperEventDto', 'source_'),
          startedAt: BuiltValueNullFieldError.checkNotNull(
              startedAt, r'RouteTamperEventDto', 'startedAt'),
          resolvedAt: resolvedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
