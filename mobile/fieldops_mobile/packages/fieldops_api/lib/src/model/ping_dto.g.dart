// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ping_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PingDto extends PingDto {
  @override
  final String clientUuid;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final num? accuracyM;
  @override
  final num? batteryPct;
  @override
  final bool? isMocked;
  @override
  final bool? fromOffline;
  @override
  final DateTime recordedAt;

  factory _$PingDto([void Function(PingDtoBuilder)? updates]) =>
      (PingDtoBuilder()..update(updates))._build();

  _$PingDto._(
      {required this.clientUuid,
      required this.latitude,
      required this.longitude,
      this.accuracyM,
      this.batteryPct,
      this.isMocked,
      this.fromOffline,
      required this.recordedAt})
      : super._();
  @override
  PingDto rebuild(void Function(PingDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PingDtoBuilder toBuilder() => PingDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PingDto &&
        clientUuid == other.clientUuid &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        accuracyM == other.accuracyM &&
        batteryPct == other.batteryPct &&
        isMocked == other.isMocked &&
        fromOffline == other.fromOffline &&
        recordedAt == other.recordedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientUuid.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, accuracyM.hashCode);
    _$hash = $jc(_$hash, batteryPct.hashCode);
    _$hash = $jc(_$hash, isMocked.hashCode);
    _$hash = $jc(_$hash, fromOffline.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PingDto')
          ..add('clientUuid', clientUuid)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('accuracyM', accuracyM)
          ..add('batteryPct', batteryPct)
          ..add('isMocked', isMocked)
          ..add('fromOffline', fromOffline)
          ..add('recordedAt', recordedAt))
        .toString();
  }
}

class PingDtoBuilder implements Builder<PingDto, PingDtoBuilder> {
  _$PingDto? _$v;

  String? _clientUuid;
  String? get clientUuid => _$this._clientUuid;
  set clientUuid(String? clientUuid) => _$this._clientUuid = clientUuid;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  num? _accuracyM;
  num? get accuracyM => _$this._accuracyM;
  set accuracyM(num? accuracyM) => _$this._accuracyM = accuracyM;

  num? _batteryPct;
  num? get batteryPct => _$this._batteryPct;
  set batteryPct(num? batteryPct) => _$this._batteryPct = batteryPct;

  bool? _isMocked;
  bool? get isMocked => _$this._isMocked;
  set isMocked(bool? isMocked) => _$this._isMocked = isMocked;

  bool? _fromOffline;
  bool? get fromOffline => _$this._fromOffline;
  set fromOffline(bool? fromOffline) => _$this._fromOffline = fromOffline;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  PingDtoBuilder() {
    PingDto._defaults(this);
  }

  PingDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientUuid = $v.clientUuid;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _accuracyM = $v.accuracyM;
      _batteryPct = $v.batteryPct;
      _isMocked = $v.isMocked;
      _fromOffline = $v.fromOffline;
      _recordedAt = $v.recordedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PingDto other) {
    _$v = other as _$PingDto;
  }

  @override
  void update(void Function(PingDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PingDto build() => _build();

  _$PingDto _build() {
    final _$result = _$v ??
        _$PingDto._(
          clientUuid: BuiltValueNullFieldError.checkNotNull(
              clientUuid, r'PingDto', 'clientUuid'),
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'PingDto', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'PingDto', 'longitude'),
          accuracyM: accuracyM,
          batteryPct: batteryPct,
          isMocked: isMocked,
          fromOffline: fromOffline,
          recordedAt: BuiltValueNullFieldError.checkNotNull(
              recordedAt, r'PingDto', 'recordedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
