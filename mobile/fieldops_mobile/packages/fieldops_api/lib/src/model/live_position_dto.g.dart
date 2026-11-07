// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_position_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LivePositionDtoStateEnum _$livePositionDtoStateEnum_ACTIVE =
    const LivePositionDtoStateEnum._('ACTIVE');
const LivePositionDtoStateEnum _$livePositionDtoStateEnum_STALE =
    const LivePositionDtoStateEnum._('STALE');
const LivePositionDtoStateEnum _$livePositionDtoStateEnum_SILENT =
    const LivePositionDtoStateEnum._('SILENT');
const LivePositionDtoStateEnum _$livePositionDtoStateEnum_NO_SIGNAL =
    const LivePositionDtoStateEnum._('NO_SIGNAL');

LivePositionDtoStateEnum _$livePositionDtoStateEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$livePositionDtoStateEnum_ACTIVE;
    case 'STALE':
      return _$livePositionDtoStateEnum_STALE;
    case 'SILENT':
      return _$livePositionDtoStateEnum_SILENT;
    case 'NO_SIGNAL':
      return _$livePositionDtoStateEnum_NO_SIGNAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LivePositionDtoStateEnum> _$livePositionDtoStateEnumValues =
    BuiltSet<LivePositionDtoStateEnum>(const <LivePositionDtoStateEnum>[
  _$livePositionDtoStateEnum_ACTIVE,
  _$livePositionDtoStateEnum_STALE,
  _$livePositionDtoStateEnum_SILENT,
  _$livePositionDtoStateEnum_NO_SIGNAL,
]);

Serializer<LivePositionDtoStateEnum> _$livePositionDtoStateEnumSerializer =
    _$LivePositionDtoStateEnumSerializer();

class _$LivePositionDtoStateEnumSerializer
    implements PrimitiveSerializer<LivePositionDtoStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'STALE': 'STALE',
    'SILENT': 'SILENT',
    'NO_SIGNAL': 'NO_SIGNAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'STALE': 'STALE',
    'SILENT': 'SILENT',
    'NO_SIGNAL': 'NO_SIGNAL',
  };

  @override
  final Iterable<Type> types = const <Type>[LivePositionDtoStateEnum];
  @override
  final String wireName = 'LivePositionDtoStateEnum';

  @override
  Object serialize(Serializers serializers, LivePositionDtoStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LivePositionDtoStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LivePositionDtoStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LivePositionDto extends LivePositionDto {
  @override
  final String staffId;
  @override
  final String attendanceId;
  @override
  final String wardId;
  @override
  final String date;
  @override
  final DateTime checkinAt;
  @override
  final LivePositionDtoStateEnum state;
  @override
  final DateTime? lastSeenAt;
  @override
  final num? latitude;
  @override
  final num? longitude;
  @override
  final num? accuracyM;
  @override
  final bool? inWard;
  @override
  final bool isMocked;

  factory _$LivePositionDto([void Function(LivePositionDtoBuilder)? updates]) =>
      (LivePositionDtoBuilder()..update(updates))._build();

  _$LivePositionDto._(
      {required this.staffId,
      required this.attendanceId,
      required this.wardId,
      required this.date,
      required this.checkinAt,
      required this.state,
      this.lastSeenAt,
      this.latitude,
      this.longitude,
      this.accuracyM,
      this.inWard,
      required this.isMocked})
      : super._();
  @override
  LivePositionDto rebuild(void Function(LivePositionDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LivePositionDtoBuilder toBuilder() => LivePositionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LivePositionDto &&
        staffId == other.staffId &&
        attendanceId == other.attendanceId &&
        wardId == other.wardId &&
        date == other.date &&
        checkinAt == other.checkinAt &&
        state == other.state &&
        lastSeenAt == other.lastSeenAt &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        accuracyM == other.accuracyM &&
        inWard == other.inWard &&
        isMocked == other.isMocked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, attendanceId.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, checkinAt.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, lastSeenAt.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, accuracyM.hashCode);
    _$hash = $jc(_$hash, inWard.hashCode);
    _$hash = $jc(_$hash, isMocked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LivePositionDto')
          ..add('staffId', staffId)
          ..add('attendanceId', attendanceId)
          ..add('wardId', wardId)
          ..add('date', date)
          ..add('checkinAt', checkinAt)
          ..add('state', state)
          ..add('lastSeenAt', lastSeenAt)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('accuracyM', accuracyM)
          ..add('inWard', inWard)
          ..add('isMocked', isMocked))
        .toString();
  }
}

class LivePositionDtoBuilder
    implements Builder<LivePositionDto, LivePositionDtoBuilder> {
  _$LivePositionDto? _$v;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  String? _attendanceId;
  String? get attendanceId => _$this._attendanceId;
  set attendanceId(String? attendanceId) => _$this._attendanceId = attendanceId;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  DateTime? _checkinAt;
  DateTime? get checkinAt => _$this._checkinAt;
  set checkinAt(DateTime? checkinAt) => _$this._checkinAt = checkinAt;

  LivePositionDtoStateEnum? _state;
  LivePositionDtoStateEnum? get state => _$this._state;
  set state(LivePositionDtoStateEnum? state) => _$this._state = state;

  DateTime? _lastSeenAt;
  DateTime? get lastSeenAt => _$this._lastSeenAt;
  set lastSeenAt(DateTime? lastSeenAt) => _$this._lastSeenAt = lastSeenAt;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  num? _accuracyM;
  num? get accuracyM => _$this._accuracyM;
  set accuracyM(num? accuracyM) => _$this._accuracyM = accuracyM;

  bool? _inWard;
  bool? get inWard => _$this._inWard;
  set inWard(bool? inWard) => _$this._inWard = inWard;

  bool? _isMocked;
  bool? get isMocked => _$this._isMocked;
  set isMocked(bool? isMocked) => _$this._isMocked = isMocked;

  LivePositionDtoBuilder() {
    LivePositionDto._defaults(this);
  }

  LivePositionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _staffId = $v.staffId;
      _attendanceId = $v.attendanceId;
      _wardId = $v.wardId;
      _date = $v.date;
      _checkinAt = $v.checkinAt;
      _state = $v.state;
      _lastSeenAt = $v.lastSeenAt;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _accuracyM = $v.accuracyM;
      _inWard = $v.inWard;
      _isMocked = $v.isMocked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LivePositionDto other) {
    _$v = other as _$LivePositionDto;
  }

  @override
  void update(void Function(LivePositionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LivePositionDto build() => _build();

  _$LivePositionDto _build() {
    final _$result = _$v ??
        _$LivePositionDto._(
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'LivePositionDto', 'staffId'),
          attendanceId: BuiltValueNullFieldError.checkNotNull(
              attendanceId, r'LivePositionDto', 'attendanceId'),
          wardId: BuiltValueNullFieldError.checkNotNull(
              wardId, r'LivePositionDto', 'wardId'),
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'LivePositionDto', 'date'),
          checkinAt: BuiltValueNullFieldError.checkNotNull(
              checkinAt, r'LivePositionDto', 'checkinAt'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'LivePositionDto', 'state'),
          lastSeenAt: lastSeenAt,
          latitude: latitude,
          longitude: longitude,
          accuracyM: accuracyM,
          inWard: inWard,
          isMocked: BuiltValueNullFieldError.checkNotNull(
              isMocked, r'LivePositionDto', 'isMocked'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
