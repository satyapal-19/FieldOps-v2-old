// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_check_result_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LocationCheckResultDto extends LocationCheckResultDto {
  @override
  final String wardId;
  @override
  final bool inside;
  @override
  final bool withinTolerance;
  @override
  final num distanceToEdgeMeters;

  factory _$LocationCheckResultDto(
          [void Function(LocationCheckResultDtoBuilder)? updates]) =>
      (LocationCheckResultDtoBuilder()..update(updates))._build();

  _$LocationCheckResultDto._(
      {required this.wardId,
      required this.inside,
      required this.withinTolerance,
      required this.distanceToEdgeMeters})
      : super._();
  @override
  LocationCheckResultDto rebuild(
          void Function(LocationCheckResultDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocationCheckResultDtoBuilder toBuilder() =>
      LocationCheckResultDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocationCheckResultDto &&
        wardId == other.wardId &&
        inside == other.inside &&
        withinTolerance == other.withinTolerance &&
        distanceToEdgeMeters == other.distanceToEdgeMeters;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, inside.hashCode);
    _$hash = $jc(_$hash, withinTolerance.hashCode);
    _$hash = $jc(_$hash, distanceToEdgeMeters.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LocationCheckResultDto')
          ..add('wardId', wardId)
          ..add('inside', inside)
          ..add('withinTolerance', withinTolerance)
          ..add('distanceToEdgeMeters', distanceToEdgeMeters))
        .toString();
  }
}

class LocationCheckResultDtoBuilder
    implements Builder<LocationCheckResultDto, LocationCheckResultDtoBuilder> {
  _$LocationCheckResultDto? _$v;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  bool? _inside;
  bool? get inside => _$this._inside;
  set inside(bool? inside) => _$this._inside = inside;

  bool? _withinTolerance;
  bool? get withinTolerance => _$this._withinTolerance;
  set withinTolerance(bool? withinTolerance) =>
      _$this._withinTolerance = withinTolerance;

  num? _distanceToEdgeMeters;
  num? get distanceToEdgeMeters => _$this._distanceToEdgeMeters;
  set distanceToEdgeMeters(num? distanceToEdgeMeters) =>
      _$this._distanceToEdgeMeters = distanceToEdgeMeters;

  LocationCheckResultDtoBuilder() {
    LocationCheckResultDto._defaults(this);
  }

  LocationCheckResultDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _wardId = $v.wardId;
      _inside = $v.inside;
      _withinTolerance = $v.withinTolerance;
      _distanceToEdgeMeters = $v.distanceToEdgeMeters;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LocationCheckResultDto other) {
    _$v = other as _$LocationCheckResultDto;
  }

  @override
  void update(void Function(LocationCheckResultDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LocationCheckResultDto build() => _build();

  _$LocationCheckResultDto _build() {
    final _$result = _$v ??
        _$LocationCheckResultDto._(
          wardId: BuiltValueNullFieldError.checkNotNull(
              wardId, r'LocationCheckResultDto', 'wardId'),
          inside: BuiltValueNullFieldError.checkNotNull(
              inside, r'LocationCheckResultDto', 'inside'),
          withinTolerance: BuiltValueNullFieldError.checkNotNull(
              withinTolerance, r'LocationCheckResultDto', 'withinTolerance'),
          distanceToEdgeMeters: BuiltValueNullFieldError.checkNotNull(
              distanceToEdgeMeters,
              r'LocationCheckResultDto',
              'distanceToEdgeMeters'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
