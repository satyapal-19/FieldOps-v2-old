// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office_location_check_result_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OfficeLocationCheckResultDto extends OfficeLocationCheckResultDto {
  @override
  final String officeId;
  @override
  final bool inside;
  @override
  final bool withinTolerance;
  @override
  final num distanceToEdgeMeters;
  @override
  final num bufferMeters;

  factory _$OfficeLocationCheckResultDto(
          [void Function(OfficeLocationCheckResultDtoBuilder)? updates]) =>
      (OfficeLocationCheckResultDtoBuilder()..update(updates))._build();

  _$OfficeLocationCheckResultDto._(
      {required this.officeId,
      required this.inside,
      required this.withinTolerance,
      required this.distanceToEdgeMeters,
      required this.bufferMeters})
      : super._();
  @override
  OfficeLocationCheckResultDto rebuild(
          void Function(OfficeLocationCheckResultDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OfficeLocationCheckResultDtoBuilder toBuilder() =>
      OfficeLocationCheckResultDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OfficeLocationCheckResultDto &&
        officeId == other.officeId &&
        inside == other.inside &&
        withinTolerance == other.withinTolerance &&
        distanceToEdgeMeters == other.distanceToEdgeMeters &&
        bufferMeters == other.bufferMeters;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, officeId.hashCode);
    _$hash = $jc(_$hash, inside.hashCode);
    _$hash = $jc(_$hash, withinTolerance.hashCode);
    _$hash = $jc(_$hash, distanceToEdgeMeters.hashCode);
    _$hash = $jc(_$hash, bufferMeters.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OfficeLocationCheckResultDto')
          ..add('officeId', officeId)
          ..add('inside', inside)
          ..add('withinTolerance', withinTolerance)
          ..add('distanceToEdgeMeters', distanceToEdgeMeters)
          ..add('bufferMeters', bufferMeters))
        .toString();
  }
}

class OfficeLocationCheckResultDtoBuilder
    implements
        Builder<OfficeLocationCheckResultDto,
            OfficeLocationCheckResultDtoBuilder> {
  _$OfficeLocationCheckResultDto? _$v;

  String? _officeId;
  String? get officeId => _$this._officeId;
  set officeId(String? officeId) => _$this._officeId = officeId;

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

  num? _bufferMeters;
  num? get bufferMeters => _$this._bufferMeters;
  set bufferMeters(num? bufferMeters) => _$this._bufferMeters = bufferMeters;

  OfficeLocationCheckResultDtoBuilder() {
    OfficeLocationCheckResultDto._defaults(this);
  }

  OfficeLocationCheckResultDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _officeId = $v.officeId;
      _inside = $v.inside;
      _withinTolerance = $v.withinTolerance;
      _distanceToEdgeMeters = $v.distanceToEdgeMeters;
      _bufferMeters = $v.bufferMeters;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OfficeLocationCheckResultDto other) {
    _$v = other as _$OfficeLocationCheckResultDto;
  }

  @override
  void update(void Function(OfficeLocationCheckResultDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OfficeLocationCheckResultDto build() => _build();

  _$OfficeLocationCheckResultDto _build() {
    final _$result = _$v ??
        _$OfficeLocationCheckResultDto._(
          officeId: BuiltValueNullFieldError.checkNotNull(
              officeId, r'OfficeLocationCheckResultDto', 'officeId'),
          inside: BuiltValueNullFieldError.checkNotNull(
              inside, r'OfficeLocationCheckResultDto', 'inside'),
          withinTolerance: BuiltValueNullFieldError.checkNotNull(
              withinTolerance,
              r'OfficeLocationCheckResultDto',
              'withinTolerance'),
          distanceToEdgeMeters: BuiltValueNullFieldError.checkNotNull(
              distanceToEdgeMeters,
              r'OfficeLocationCheckResultDto',
              'distanceToEdgeMeters'),
          bufferMeters: BuiltValueNullFieldError.checkNotNull(
              bufferMeters, r'OfficeLocationCheckResultDto', 'bufferMeters'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
