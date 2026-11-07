// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_report_row_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StaffReportRowDto extends StaffReportRowDto {
  @override
  final String staffId;
  @override
  final num days;
  @override
  final num present;
  @override
  final num late_;
  @override
  final num lateMinutes;
  @override
  final num halfDay;
  @override
  final num absent;
  @override
  final num onLeave;
  @override
  final num regularized;
  @override
  final num autoCheckout;
  @override
  final num suspicious;

  factory _$StaffReportRowDto(
          [void Function(StaffReportRowDtoBuilder)? updates]) =>
      (StaffReportRowDtoBuilder()..update(updates))._build();

  _$StaffReportRowDto._(
      {required this.staffId,
      required this.days,
      required this.present,
      required this.late_,
      required this.lateMinutes,
      required this.halfDay,
      required this.absent,
      required this.onLeave,
      required this.regularized,
      required this.autoCheckout,
      required this.suspicious})
      : super._();
  @override
  StaffReportRowDto rebuild(void Function(StaffReportRowDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StaffReportRowDtoBuilder toBuilder() =>
      StaffReportRowDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StaffReportRowDto &&
        staffId == other.staffId &&
        days == other.days &&
        present == other.present &&
        late_ == other.late_ &&
        lateMinutes == other.lateMinutes &&
        halfDay == other.halfDay &&
        absent == other.absent &&
        onLeave == other.onLeave &&
        regularized == other.regularized &&
        autoCheckout == other.autoCheckout &&
        suspicious == other.suspicious;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, days.hashCode);
    _$hash = $jc(_$hash, present.hashCode);
    _$hash = $jc(_$hash, late_.hashCode);
    _$hash = $jc(_$hash, lateMinutes.hashCode);
    _$hash = $jc(_$hash, halfDay.hashCode);
    _$hash = $jc(_$hash, absent.hashCode);
    _$hash = $jc(_$hash, onLeave.hashCode);
    _$hash = $jc(_$hash, regularized.hashCode);
    _$hash = $jc(_$hash, autoCheckout.hashCode);
    _$hash = $jc(_$hash, suspicious.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StaffReportRowDto')
          ..add('staffId', staffId)
          ..add('days', days)
          ..add('present', present)
          ..add('late_', late_)
          ..add('lateMinutes', lateMinutes)
          ..add('halfDay', halfDay)
          ..add('absent', absent)
          ..add('onLeave', onLeave)
          ..add('regularized', regularized)
          ..add('autoCheckout', autoCheckout)
          ..add('suspicious', suspicious))
        .toString();
  }
}

class StaffReportRowDtoBuilder
    implements Builder<StaffReportRowDto, StaffReportRowDtoBuilder> {
  _$StaffReportRowDto? _$v;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  num? _days;
  num? get days => _$this._days;
  set days(num? days) => _$this._days = days;

  num? _present;
  num? get present => _$this._present;
  set present(num? present) => _$this._present = present;

  num? _late_;
  num? get late_ => _$this._late_;
  set late_(num? late_) => _$this._late_ = late_;

  num? _lateMinutes;
  num? get lateMinutes => _$this._lateMinutes;
  set lateMinutes(num? lateMinutes) => _$this._lateMinutes = lateMinutes;

  num? _halfDay;
  num? get halfDay => _$this._halfDay;
  set halfDay(num? halfDay) => _$this._halfDay = halfDay;

  num? _absent;
  num? get absent => _$this._absent;
  set absent(num? absent) => _$this._absent = absent;

  num? _onLeave;
  num? get onLeave => _$this._onLeave;
  set onLeave(num? onLeave) => _$this._onLeave = onLeave;

  num? _regularized;
  num? get regularized => _$this._regularized;
  set regularized(num? regularized) => _$this._regularized = regularized;

  num? _autoCheckout;
  num? get autoCheckout => _$this._autoCheckout;
  set autoCheckout(num? autoCheckout) => _$this._autoCheckout = autoCheckout;

  num? _suspicious;
  num? get suspicious => _$this._suspicious;
  set suspicious(num? suspicious) => _$this._suspicious = suspicious;

  StaffReportRowDtoBuilder() {
    StaffReportRowDto._defaults(this);
  }

  StaffReportRowDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _staffId = $v.staffId;
      _days = $v.days;
      _present = $v.present;
      _late_ = $v.late_;
      _lateMinutes = $v.lateMinutes;
      _halfDay = $v.halfDay;
      _absent = $v.absent;
      _onLeave = $v.onLeave;
      _regularized = $v.regularized;
      _autoCheckout = $v.autoCheckout;
      _suspicious = $v.suspicious;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StaffReportRowDto other) {
    _$v = other as _$StaffReportRowDto;
  }

  @override
  void update(void Function(StaffReportRowDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StaffReportRowDto build() => _build();

  _$StaffReportRowDto _build() {
    final _$result = _$v ??
        _$StaffReportRowDto._(
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'StaffReportRowDto', 'staffId'),
          days: BuiltValueNullFieldError.checkNotNull(
              days, r'StaffReportRowDto', 'days'),
          present: BuiltValueNullFieldError.checkNotNull(
              present, r'StaffReportRowDto', 'present'),
          late_: BuiltValueNullFieldError.checkNotNull(
              late_, r'StaffReportRowDto', 'late_'),
          lateMinutes: BuiltValueNullFieldError.checkNotNull(
              lateMinutes, r'StaffReportRowDto', 'lateMinutes'),
          halfDay: BuiltValueNullFieldError.checkNotNull(
              halfDay, r'StaffReportRowDto', 'halfDay'),
          absent: BuiltValueNullFieldError.checkNotNull(
              absent, r'StaffReportRowDto', 'absent'),
          onLeave: BuiltValueNullFieldError.checkNotNull(
              onLeave, r'StaffReportRowDto', 'onLeave'),
          regularized: BuiltValueNullFieldError.checkNotNull(
              regularized, r'StaffReportRowDto', 'regularized'),
          autoCheckout: BuiltValueNullFieldError.checkNotNull(
              autoCheckout, r'StaffReportRowDto', 'autoCheckout'),
          suspicious: BuiltValueNullFieldError.checkNotNull(
              suspicious, r'StaffReportRowDto', 'suspicious'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
