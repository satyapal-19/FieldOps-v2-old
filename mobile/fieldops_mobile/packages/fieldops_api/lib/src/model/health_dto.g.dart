// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HealthDto extends HealthDto {
  @override
  final String status;
  @override
  final String environment;
  @override
  final String version;
  @override
  final num uptimeSeconds;
  @override
  final String time;

  factory _$HealthDto([void Function(HealthDtoBuilder)? updates]) =>
      (HealthDtoBuilder()..update(updates))._build();

  _$HealthDto._(
      {required this.status,
      required this.environment,
      required this.version,
      required this.uptimeSeconds,
      required this.time})
      : super._();
  @override
  HealthDto rebuild(void Function(HealthDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HealthDtoBuilder toBuilder() => HealthDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthDto &&
        status == other.status &&
        environment == other.environment &&
        version == other.version &&
        uptimeSeconds == other.uptimeSeconds &&
        time == other.time;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, uptimeSeconds.hashCode);
    _$hash = $jc(_$hash, time.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HealthDto')
          ..add('status', status)
          ..add('environment', environment)
          ..add('version', version)
          ..add('uptimeSeconds', uptimeSeconds)
          ..add('time', time))
        .toString();
  }
}

class HealthDtoBuilder implements Builder<HealthDto, HealthDtoBuilder> {
  _$HealthDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  num? _uptimeSeconds;
  num? get uptimeSeconds => _$this._uptimeSeconds;
  set uptimeSeconds(num? uptimeSeconds) =>
      _$this._uptimeSeconds = uptimeSeconds;

  String? _time;
  String? get time => _$this._time;
  set time(String? time) => _$this._time = time;

  HealthDtoBuilder() {
    HealthDto._defaults(this);
  }

  HealthDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _environment = $v.environment;
      _version = $v.version;
      _uptimeSeconds = $v.uptimeSeconds;
      _time = $v.time;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HealthDto other) {
    _$v = other as _$HealthDto;
  }

  @override
  void update(void Function(HealthDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HealthDto build() => _build();

  _$HealthDto _build() {
    final _$result = _$v ??
        _$HealthDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'HealthDto', 'status'),
          environment: BuiltValueNullFieldError.checkNotNull(
              environment, r'HealthDto', 'environment'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'HealthDto', 'version'),
          uptimeSeconds: BuiltValueNullFieldError.checkNotNull(
              uptimeSeconds, r'HealthDto', 'uptimeSeconds'),
          time:
              BuiltValueNullFieldError.checkNotNull(time, r'HealthDto', 'time'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
