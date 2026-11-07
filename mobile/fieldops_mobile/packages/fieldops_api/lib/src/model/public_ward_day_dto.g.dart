// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_ward_day_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicWardDayDto extends PublicWardDayDto {
  @override
  final String date;
  @override
  final num assignedCount;
  @override
  final num presentCount;
  @override
  final num onLeaveCount;

  factory _$PublicWardDayDto(
          [void Function(PublicWardDayDtoBuilder)? updates]) =>
      (PublicWardDayDtoBuilder()..update(updates))._build();

  _$PublicWardDayDto._(
      {required this.date,
      required this.assignedCount,
      required this.presentCount,
      required this.onLeaveCount})
      : super._();
  @override
  PublicWardDayDto rebuild(void Function(PublicWardDayDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicWardDayDtoBuilder toBuilder() =>
      PublicWardDayDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicWardDayDto &&
        date == other.date &&
        assignedCount == other.assignedCount &&
        presentCount == other.presentCount &&
        onLeaveCount == other.onLeaveCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, assignedCount.hashCode);
    _$hash = $jc(_$hash, presentCount.hashCode);
    _$hash = $jc(_$hash, onLeaveCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicWardDayDto')
          ..add('date', date)
          ..add('assignedCount', assignedCount)
          ..add('presentCount', presentCount)
          ..add('onLeaveCount', onLeaveCount))
        .toString();
  }
}

class PublicWardDayDtoBuilder
    implements Builder<PublicWardDayDto, PublicWardDayDtoBuilder> {
  _$PublicWardDayDto? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  num? _assignedCount;
  num? get assignedCount => _$this._assignedCount;
  set assignedCount(num? assignedCount) =>
      _$this._assignedCount = assignedCount;

  num? _presentCount;
  num? get presentCount => _$this._presentCount;
  set presentCount(num? presentCount) => _$this._presentCount = presentCount;

  num? _onLeaveCount;
  num? get onLeaveCount => _$this._onLeaveCount;
  set onLeaveCount(num? onLeaveCount) => _$this._onLeaveCount = onLeaveCount;

  PublicWardDayDtoBuilder() {
    PublicWardDayDto._defaults(this);
  }

  PublicWardDayDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _assignedCount = $v.assignedCount;
      _presentCount = $v.presentCount;
      _onLeaveCount = $v.onLeaveCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicWardDayDto other) {
    _$v = other as _$PublicWardDayDto;
  }

  @override
  void update(void Function(PublicWardDayDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicWardDayDto build() => _build();

  _$PublicWardDayDto _build() {
    final _$result = _$v ??
        _$PublicWardDayDto._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'PublicWardDayDto', 'date'),
          assignedCount: BuiltValueNullFieldError.checkNotNull(
              assignedCount, r'PublicWardDayDto', 'assignedCount'),
          presentCount: BuiltValueNullFieldError.checkNotNull(
              presentCount, r'PublicWardDayDto', 'presentCount'),
          onLeaveCount: BuiltValueNullFieldError.checkNotNull(
              onLeaveCount, r'PublicWardDayDto', 'onLeaveCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
