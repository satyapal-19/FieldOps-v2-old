// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_point_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoutePointDto extends RoutePointDto {
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final num? accuracyM;
  @override
  final DateTime recordedAt;
  @override
  final bool? inWard;
  @override
  final bool isStationary;
  @override
  final bool isMocked;
  @override
  final bool fromOffline;

  factory _$RoutePointDto([void Function(RoutePointDtoBuilder)? updates]) =>
      (RoutePointDtoBuilder()..update(updates))._build();

  _$RoutePointDto._(
      {required this.latitude,
      required this.longitude,
      this.accuracyM,
      required this.recordedAt,
      this.inWard,
      required this.isStationary,
      required this.isMocked,
      required this.fromOffline})
      : super._();
  @override
  RoutePointDto rebuild(void Function(RoutePointDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoutePointDtoBuilder toBuilder() => RoutePointDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoutePointDto &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        accuracyM == other.accuracyM &&
        recordedAt == other.recordedAt &&
        inWard == other.inWard &&
        isStationary == other.isStationary &&
        isMocked == other.isMocked &&
        fromOffline == other.fromOffline;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, accuracyM.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jc(_$hash, inWard.hashCode);
    _$hash = $jc(_$hash, isStationary.hashCode);
    _$hash = $jc(_$hash, isMocked.hashCode);
    _$hash = $jc(_$hash, fromOffline.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoutePointDto')
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('accuracyM', accuracyM)
          ..add('recordedAt', recordedAt)
          ..add('inWard', inWard)
          ..add('isStationary', isStationary)
          ..add('isMocked', isMocked)
          ..add('fromOffline', fromOffline))
        .toString();
  }
}

class RoutePointDtoBuilder
    implements Builder<RoutePointDto, RoutePointDtoBuilder> {
  _$RoutePointDto? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  num? _accuracyM;
  num? get accuracyM => _$this._accuracyM;
  set accuracyM(num? accuracyM) => _$this._accuracyM = accuracyM;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  bool? _inWard;
  bool? get inWard => _$this._inWard;
  set inWard(bool? inWard) => _$this._inWard = inWard;

  bool? _isStationary;
  bool? get isStationary => _$this._isStationary;
  set isStationary(bool? isStationary) => _$this._isStationary = isStationary;

  bool? _isMocked;
  bool? get isMocked => _$this._isMocked;
  set isMocked(bool? isMocked) => _$this._isMocked = isMocked;

  bool? _fromOffline;
  bool? get fromOffline => _$this._fromOffline;
  set fromOffline(bool? fromOffline) => _$this._fromOffline = fromOffline;

  RoutePointDtoBuilder() {
    RoutePointDto._defaults(this);
  }

  RoutePointDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _accuracyM = $v.accuracyM;
      _recordedAt = $v.recordedAt;
      _inWard = $v.inWard;
      _isStationary = $v.isStationary;
      _isMocked = $v.isMocked;
      _fromOffline = $v.fromOffline;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoutePointDto other) {
    _$v = other as _$RoutePointDto;
  }

  @override
  void update(void Function(RoutePointDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoutePointDto build() => _build();

  _$RoutePointDto _build() {
    final _$result = _$v ??
        _$RoutePointDto._(
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'RoutePointDto', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'RoutePointDto', 'longitude'),
          accuracyM: accuracyM,
          recordedAt: BuiltValueNullFieldError.checkNotNull(
              recordedAt, r'RoutePointDto', 'recordedAt'),
          inWard: inWard,
          isStationary: BuiltValueNullFieldError.checkNotNull(
              isStationary, r'RoutePointDto', 'isStationary'),
          isMocked: BuiltValueNullFieldError.checkNotNull(
              isMocked, r'RoutePointDto', 'isMocked'),
          fromOffline: BuiltValueNullFieldError.checkNotNull(
              fromOffline, r'RoutePointDto', 'fromOffline'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
