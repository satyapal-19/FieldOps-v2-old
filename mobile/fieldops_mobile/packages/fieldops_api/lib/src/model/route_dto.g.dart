// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RouteDto extends RouteDto {
  @override
  final String staffId;
  @override
  final String date;
  @override
  final RouteShiftDto? shift;
  @override
  final RouteSummaryDto summary;
  @override
  final BuiltList<RoutePointDto> points;
  @override
  final bool pointsPurged;
  @override
  final BuiltList<RouteTamperEventDto> tamperEvents;

  factory _$RouteDto([void Function(RouteDtoBuilder)? updates]) =>
      (RouteDtoBuilder()..update(updates))._build();

  _$RouteDto._(
      {required this.staffId,
      required this.date,
      this.shift,
      required this.summary,
      required this.points,
      required this.pointsPurged,
      required this.tamperEvents})
      : super._();
  @override
  RouteDto rebuild(void Function(RouteDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteDtoBuilder toBuilder() => RouteDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteDto &&
        staffId == other.staffId &&
        date == other.date &&
        shift == other.shift &&
        summary == other.summary &&
        points == other.points &&
        pointsPurged == other.pointsPurged &&
        tamperEvents == other.tamperEvents;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, shift.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, pointsPurged.hashCode);
    _$hash = $jc(_$hash, tamperEvents.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteDto')
          ..add('staffId', staffId)
          ..add('date', date)
          ..add('shift', shift)
          ..add('summary', summary)
          ..add('points', points)
          ..add('pointsPurged', pointsPurged)
          ..add('tamperEvents', tamperEvents))
        .toString();
  }
}

class RouteDtoBuilder implements Builder<RouteDto, RouteDtoBuilder> {
  _$RouteDto? _$v;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  RouteShiftDtoBuilder? _shift;
  RouteShiftDtoBuilder get shift => _$this._shift ??= RouteShiftDtoBuilder();
  set shift(RouteShiftDtoBuilder? shift) => _$this._shift = shift;

  RouteSummaryDtoBuilder? _summary;
  RouteSummaryDtoBuilder get summary =>
      _$this._summary ??= RouteSummaryDtoBuilder();
  set summary(RouteSummaryDtoBuilder? summary) => _$this._summary = summary;

  ListBuilder<RoutePointDto>? _points;
  ListBuilder<RoutePointDto> get points =>
      _$this._points ??= ListBuilder<RoutePointDto>();
  set points(ListBuilder<RoutePointDto>? points) => _$this._points = points;

  bool? _pointsPurged;
  bool? get pointsPurged => _$this._pointsPurged;
  set pointsPurged(bool? pointsPurged) => _$this._pointsPurged = pointsPurged;

  ListBuilder<RouteTamperEventDto>? _tamperEvents;
  ListBuilder<RouteTamperEventDto> get tamperEvents =>
      _$this._tamperEvents ??= ListBuilder<RouteTamperEventDto>();
  set tamperEvents(ListBuilder<RouteTamperEventDto>? tamperEvents) =>
      _$this._tamperEvents = tamperEvents;

  RouteDtoBuilder() {
    RouteDto._defaults(this);
  }

  RouteDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _staffId = $v.staffId;
      _date = $v.date;
      _shift = $v.shift?.toBuilder();
      _summary = $v.summary.toBuilder();
      _points = $v.points.toBuilder();
      _pointsPurged = $v.pointsPurged;
      _tamperEvents = $v.tamperEvents.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteDto other) {
    _$v = other as _$RouteDto;
  }

  @override
  void update(void Function(RouteDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteDto build() => _build();

  _$RouteDto _build() {
    _$RouteDto _$result;
    try {
      _$result = _$v ??
          _$RouteDto._(
            staffId: BuiltValueNullFieldError.checkNotNull(
                staffId, r'RouteDto', 'staffId'),
            date: BuiltValueNullFieldError.checkNotNull(
                date, r'RouteDto', 'date'),
            shift: _shift?.build(),
            summary: summary.build(),
            points: points.build(),
            pointsPurged: BuiltValueNullFieldError.checkNotNull(
                pointsPurged, r'RouteDto', 'pointsPurged'),
            tamperEvents: tamperEvents.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'shift';
        _shift?.build();
        _$failedField = 'summary';
        summary.build();
        _$failedField = 'points';
        points.build();

        _$failedField = 'tamperEvents';
        tamperEvents.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RouteDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
