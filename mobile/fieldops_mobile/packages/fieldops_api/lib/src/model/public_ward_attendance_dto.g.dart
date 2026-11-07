// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_ward_attendance_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicWardAttendanceDto extends PublicWardAttendanceDto {
  @override
  final String wardId;
  @override
  final BuiltList<PublicWardDayDto> days;

  factory _$PublicWardAttendanceDto(
          [void Function(PublicWardAttendanceDtoBuilder)? updates]) =>
      (PublicWardAttendanceDtoBuilder()..update(updates))._build();

  _$PublicWardAttendanceDto._({required this.wardId, required this.days})
      : super._();
  @override
  PublicWardAttendanceDto rebuild(
          void Function(PublicWardAttendanceDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicWardAttendanceDtoBuilder toBuilder() =>
      PublicWardAttendanceDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicWardAttendanceDto &&
        wardId == other.wardId &&
        days == other.days;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, days.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicWardAttendanceDto')
          ..add('wardId', wardId)
          ..add('days', days))
        .toString();
  }
}

class PublicWardAttendanceDtoBuilder
    implements
        Builder<PublicWardAttendanceDto, PublicWardAttendanceDtoBuilder> {
  _$PublicWardAttendanceDto? _$v;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  ListBuilder<PublicWardDayDto>? _days;
  ListBuilder<PublicWardDayDto> get days =>
      _$this._days ??= ListBuilder<PublicWardDayDto>();
  set days(ListBuilder<PublicWardDayDto>? days) => _$this._days = days;

  PublicWardAttendanceDtoBuilder() {
    PublicWardAttendanceDto._defaults(this);
  }

  PublicWardAttendanceDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _wardId = $v.wardId;
      _days = $v.days.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicWardAttendanceDto other) {
    _$v = other as _$PublicWardAttendanceDto;
  }

  @override
  void update(void Function(PublicWardAttendanceDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicWardAttendanceDto build() => _build();

  _$PublicWardAttendanceDto _build() {
    _$PublicWardAttendanceDto _$result;
    try {
      _$result = _$v ??
          _$PublicWardAttendanceDto._(
            wardId: BuiltValueNullFieldError.checkNotNull(
                wardId, r'PublicWardAttendanceDto', 'wardId'),
            days: days.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'days';
        days.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicWardAttendanceDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
