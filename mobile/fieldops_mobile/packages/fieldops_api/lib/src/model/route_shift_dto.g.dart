// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_shift_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RouteShiftDto extends RouteShiftDto {
  @override
  final String attendanceId;
  @override
  final String? wardId;
  @override
  final String? officeId;
  @override
  final DateTime? checkinAt;
  @override
  final DateTime? checkoutAt;

  factory _$RouteShiftDto([void Function(RouteShiftDtoBuilder)? updates]) =>
      (RouteShiftDtoBuilder()..update(updates))._build();

  _$RouteShiftDto._(
      {required this.attendanceId,
      this.wardId,
      this.officeId,
      this.checkinAt,
      this.checkoutAt})
      : super._();
  @override
  RouteShiftDto rebuild(void Function(RouteShiftDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteShiftDtoBuilder toBuilder() => RouteShiftDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteShiftDto &&
        attendanceId == other.attendanceId &&
        wardId == other.wardId &&
        officeId == other.officeId &&
        checkinAt == other.checkinAt &&
        checkoutAt == other.checkoutAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attendanceId.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, officeId.hashCode);
    _$hash = $jc(_$hash, checkinAt.hashCode);
    _$hash = $jc(_$hash, checkoutAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteShiftDto')
          ..add('attendanceId', attendanceId)
          ..add('wardId', wardId)
          ..add('officeId', officeId)
          ..add('checkinAt', checkinAt)
          ..add('checkoutAt', checkoutAt))
        .toString();
  }
}

class RouteShiftDtoBuilder
    implements Builder<RouteShiftDto, RouteShiftDtoBuilder> {
  _$RouteShiftDto? _$v;

  String? _attendanceId;
  String? get attendanceId => _$this._attendanceId;
  set attendanceId(String? attendanceId) => _$this._attendanceId = attendanceId;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  String? _officeId;
  String? get officeId => _$this._officeId;
  set officeId(String? officeId) => _$this._officeId = officeId;

  DateTime? _checkinAt;
  DateTime? get checkinAt => _$this._checkinAt;
  set checkinAt(DateTime? checkinAt) => _$this._checkinAt = checkinAt;

  DateTime? _checkoutAt;
  DateTime? get checkoutAt => _$this._checkoutAt;
  set checkoutAt(DateTime? checkoutAt) => _$this._checkoutAt = checkoutAt;

  RouteShiftDtoBuilder() {
    RouteShiftDto._defaults(this);
  }

  RouteShiftDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attendanceId = $v.attendanceId;
      _wardId = $v.wardId;
      _officeId = $v.officeId;
      _checkinAt = $v.checkinAt;
      _checkoutAt = $v.checkoutAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteShiftDto other) {
    _$v = other as _$RouteShiftDto;
  }

  @override
  void update(void Function(RouteShiftDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteShiftDto build() => _build();

  _$RouteShiftDto _build() {
    final _$result = _$v ??
        _$RouteShiftDto._(
          attendanceId: BuiltValueNullFieldError.checkNotNull(
              attendanceId, r'RouteShiftDto', 'attendanceId'),
          wardId: wardId,
          officeId: officeId,
          checkinAt: checkinAt,
          checkoutAt: checkoutAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
