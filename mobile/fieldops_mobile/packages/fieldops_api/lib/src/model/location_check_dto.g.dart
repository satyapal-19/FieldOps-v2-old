// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_check_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LocationCheckDto extends LocationCheckDto {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$LocationCheckDto(
          [void Function(LocationCheckDtoBuilder)? updates]) =>
      (LocationCheckDtoBuilder()..update(updates))._build();

  _$LocationCheckDto._({required this.latitude, required this.longitude})
      : super._();
  @override
  LocationCheckDto rebuild(void Function(LocationCheckDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocationCheckDtoBuilder toBuilder() =>
      LocationCheckDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocationCheckDto &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LocationCheckDto')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class LocationCheckDtoBuilder
    implements Builder<LocationCheckDto, LocationCheckDtoBuilder> {
  _$LocationCheckDto? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  LocationCheckDtoBuilder() {
    LocationCheckDto._defaults(this);
  }

  LocationCheckDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LocationCheckDto other) {
    _$v = other as _$LocationCheckDto;
  }

  @override
  void update(void Function(LocationCheckDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LocationCheckDto build() => _build();

  _$LocationCheckDto _build() {
    final _$result = _$v ??
        _$LocationCheckDto._(
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'LocationCheckDto', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'LocationCheckDto', 'longitude'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
