// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'punch_result_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PunchResultDto extends PunchResultDto {
  @override
  final bool replayed;
  @override
  final AttendanceLogDto attendance;

  factory _$PunchResultDto([void Function(PunchResultDtoBuilder)? updates]) =>
      (PunchResultDtoBuilder()..update(updates))._build();

  _$PunchResultDto._({required this.replayed, required this.attendance})
      : super._();
  @override
  PunchResultDto rebuild(void Function(PunchResultDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PunchResultDtoBuilder toBuilder() => PunchResultDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PunchResultDto &&
        replayed == other.replayed &&
        attendance == other.attendance;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, replayed.hashCode);
    _$hash = $jc(_$hash, attendance.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PunchResultDto')
          ..add('replayed', replayed)
          ..add('attendance', attendance))
        .toString();
  }
}

class PunchResultDtoBuilder
    implements Builder<PunchResultDto, PunchResultDtoBuilder> {
  _$PunchResultDto? _$v;

  bool? _replayed;
  bool? get replayed => _$this._replayed;
  set replayed(bool? replayed) => _$this._replayed = replayed;

  AttendanceLogDtoBuilder? _attendance;
  AttendanceLogDtoBuilder get attendance =>
      _$this._attendance ??= AttendanceLogDtoBuilder();
  set attendance(AttendanceLogDtoBuilder? attendance) =>
      _$this._attendance = attendance;

  PunchResultDtoBuilder() {
    PunchResultDto._defaults(this);
  }

  PunchResultDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _replayed = $v.replayed;
      _attendance = $v.attendance.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PunchResultDto other) {
    _$v = other as _$PunchResultDto;
  }

  @override
  void update(void Function(PunchResultDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PunchResultDto build() => _build();

  _$PunchResultDto _build() {
    _$PunchResultDto _$result;
    try {
      _$result = _$v ??
          _$PunchResultDto._(
            replayed: BuiltValueNullFieldError.checkNotNull(
                replayed, r'PunchResultDto', 'replayed'),
            attendance: attendance.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attendance';
        attendance.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PunchResultDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
