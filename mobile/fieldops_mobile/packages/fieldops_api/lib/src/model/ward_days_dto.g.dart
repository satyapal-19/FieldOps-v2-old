// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ward_days_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WardDaysDto extends WardDaysDto {
  @override
  final BuiltList<WardDayReportDto> items;

  factory _$WardDaysDto([void Function(WardDaysDtoBuilder)? updates]) =>
      (WardDaysDtoBuilder()..update(updates))._build();

  _$WardDaysDto._({required this.items}) : super._();
  @override
  WardDaysDto rebuild(void Function(WardDaysDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WardDaysDtoBuilder toBuilder() => WardDaysDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WardDaysDto && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WardDaysDto')..add('items', items))
        .toString();
  }
}

class WardDaysDtoBuilder implements Builder<WardDaysDto, WardDaysDtoBuilder> {
  _$WardDaysDto? _$v;

  ListBuilder<WardDayReportDto>? _items;
  ListBuilder<WardDayReportDto> get items =>
      _$this._items ??= ListBuilder<WardDayReportDto>();
  set items(ListBuilder<WardDayReportDto>? items) => _$this._items = items;

  WardDaysDtoBuilder() {
    WardDaysDto._defaults(this);
  }

  WardDaysDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WardDaysDto other) {
    _$v = other as _$WardDaysDto;
  }

  @override
  void update(void Function(WardDaysDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WardDaysDto build() => _build();

  _$WardDaysDto _build() {
    _$WardDaysDto _$result;
    try {
      _$result = _$v ??
          _$WardDaysDto._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WardDaysDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
