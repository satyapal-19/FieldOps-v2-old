// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ward_day_report_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WardDayReportDto extends WardDayReportDto {
  @override
  final String date;
  @override
  final String wardId;
  @override
  final num assignedCount;
  @override
  final num presentCount;
  @override
  final num lateCount;
  @override
  final num halfDayCount;
  @override
  final num absentCount;
  @override
  final num onLeaveCount;
  @override
  final num proxyCount;
  @override
  final num autoCheckoutCount;
  @override
  final num suspiciousCount;
  @override
  final num distanceM;

  factory _$WardDayReportDto(
          [void Function(WardDayReportDtoBuilder)? updates]) =>
      (WardDayReportDtoBuilder()..update(updates))._build();

  _$WardDayReportDto._(
      {required this.date,
      required this.wardId,
      required this.assignedCount,
      required this.presentCount,
      required this.lateCount,
      required this.halfDayCount,
      required this.absentCount,
      required this.onLeaveCount,
      required this.proxyCount,
      required this.autoCheckoutCount,
      required this.suspiciousCount,
      required this.distanceM})
      : super._();
  @override
  WardDayReportDto rebuild(void Function(WardDayReportDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WardDayReportDtoBuilder toBuilder() =>
      WardDayReportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WardDayReportDto &&
        date == other.date &&
        wardId == other.wardId &&
        assignedCount == other.assignedCount &&
        presentCount == other.presentCount &&
        lateCount == other.lateCount &&
        halfDayCount == other.halfDayCount &&
        absentCount == other.absentCount &&
        onLeaveCount == other.onLeaveCount &&
        proxyCount == other.proxyCount &&
        autoCheckoutCount == other.autoCheckoutCount &&
        suspiciousCount == other.suspiciousCount &&
        distanceM == other.distanceM;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, assignedCount.hashCode);
    _$hash = $jc(_$hash, presentCount.hashCode);
    _$hash = $jc(_$hash, lateCount.hashCode);
    _$hash = $jc(_$hash, halfDayCount.hashCode);
    _$hash = $jc(_$hash, absentCount.hashCode);
    _$hash = $jc(_$hash, onLeaveCount.hashCode);
    _$hash = $jc(_$hash, proxyCount.hashCode);
    _$hash = $jc(_$hash, autoCheckoutCount.hashCode);
    _$hash = $jc(_$hash, suspiciousCount.hashCode);
    _$hash = $jc(_$hash, distanceM.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WardDayReportDto')
          ..add('date', date)
          ..add('wardId', wardId)
          ..add('assignedCount', assignedCount)
          ..add('presentCount', presentCount)
          ..add('lateCount', lateCount)
          ..add('halfDayCount', halfDayCount)
          ..add('absentCount', absentCount)
          ..add('onLeaveCount', onLeaveCount)
          ..add('proxyCount', proxyCount)
          ..add('autoCheckoutCount', autoCheckoutCount)
          ..add('suspiciousCount', suspiciousCount)
          ..add('distanceM', distanceM))
        .toString();
  }
}

class WardDayReportDtoBuilder
    implements Builder<WardDayReportDto, WardDayReportDtoBuilder> {
  _$WardDayReportDto? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  num? _assignedCount;
  num? get assignedCount => _$this._assignedCount;
  set assignedCount(num? assignedCount) =>
      _$this._assignedCount = assignedCount;

  num? _presentCount;
  num? get presentCount => _$this._presentCount;
  set presentCount(num? presentCount) => _$this._presentCount = presentCount;

  num? _lateCount;
  num? get lateCount => _$this._lateCount;
  set lateCount(num? lateCount) => _$this._lateCount = lateCount;

  num? _halfDayCount;
  num? get halfDayCount => _$this._halfDayCount;
  set halfDayCount(num? halfDayCount) => _$this._halfDayCount = halfDayCount;

  num? _absentCount;
  num? get absentCount => _$this._absentCount;
  set absentCount(num? absentCount) => _$this._absentCount = absentCount;

  num? _onLeaveCount;
  num? get onLeaveCount => _$this._onLeaveCount;
  set onLeaveCount(num? onLeaveCount) => _$this._onLeaveCount = onLeaveCount;

  num? _proxyCount;
  num? get proxyCount => _$this._proxyCount;
  set proxyCount(num? proxyCount) => _$this._proxyCount = proxyCount;

  num? _autoCheckoutCount;
  num? get autoCheckoutCount => _$this._autoCheckoutCount;
  set autoCheckoutCount(num? autoCheckoutCount) =>
      _$this._autoCheckoutCount = autoCheckoutCount;

  num? _suspiciousCount;
  num? get suspiciousCount => _$this._suspiciousCount;
  set suspiciousCount(num? suspiciousCount) =>
      _$this._suspiciousCount = suspiciousCount;

  num? _distanceM;
  num? get distanceM => _$this._distanceM;
  set distanceM(num? distanceM) => _$this._distanceM = distanceM;

  WardDayReportDtoBuilder() {
    WardDayReportDto._defaults(this);
  }

  WardDayReportDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _wardId = $v.wardId;
      _assignedCount = $v.assignedCount;
      _presentCount = $v.presentCount;
      _lateCount = $v.lateCount;
      _halfDayCount = $v.halfDayCount;
      _absentCount = $v.absentCount;
      _onLeaveCount = $v.onLeaveCount;
      _proxyCount = $v.proxyCount;
      _autoCheckoutCount = $v.autoCheckoutCount;
      _suspiciousCount = $v.suspiciousCount;
      _distanceM = $v.distanceM;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WardDayReportDto other) {
    _$v = other as _$WardDayReportDto;
  }

  @override
  void update(void Function(WardDayReportDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WardDayReportDto build() => _build();

  _$WardDayReportDto _build() {
    final _$result = _$v ??
        _$WardDayReportDto._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'WardDayReportDto', 'date'),
          wardId: BuiltValueNullFieldError.checkNotNull(
              wardId, r'WardDayReportDto', 'wardId'),
          assignedCount: BuiltValueNullFieldError.checkNotNull(
              assignedCount, r'WardDayReportDto', 'assignedCount'),
          presentCount: BuiltValueNullFieldError.checkNotNull(
              presentCount, r'WardDayReportDto', 'presentCount'),
          lateCount: BuiltValueNullFieldError.checkNotNull(
              lateCount, r'WardDayReportDto', 'lateCount'),
          halfDayCount: BuiltValueNullFieldError.checkNotNull(
              halfDayCount, r'WardDayReportDto', 'halfDayCount'),
          absentCount: BuiltValueNullFieldError.checkNotNull(
              absentCount, r'WardDayReportDto', 'absentCount'),
          onLeaveCount: BuiltValueNullFieldError.checkNotNull(
              onLeaveCount, r'WardDayReportDto', 'onLeaveCount'),
          proxyCount: BuiltValueNullFieldError.checkNotNull(
              proxyCount, r'WardDayReportDto', 'proxyCount'),
          autoCheckoutCount: BuiltValueNullFieldError.checkNotNull(
              autoCheckoutCount, r'WardDayReportDto', 'autoCheckoutCount'),
          suspiciousCount: BuiltValueNullFieldError.checkNotNull(
              suspiciousCount, r'WardDayReportDto', 'suspiciousCount'),
          distanceM: BuiltValueNullFieldError.checkNotNull(
              distanceM, r'WardDayReportDto', 'distanceM'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
