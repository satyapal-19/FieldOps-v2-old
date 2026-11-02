// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standing_roster_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StandingRosterPageDto extends StandingRosterPageDto {
  @override
  final BuiltList<StandingRosterDto> items;
  @override
  final num page;
  @override
  final num pageSize;
  @override
  final num total;

  factory _$StandingRosterPageDto(
          [void Function(StandingRosterPageDtoBuilder)? updates]) =>
      (StandingRosterPageDtoBuilder()..update(updates))._build();

  _$StandingRosterPageDto._(
      {required this.items,
      required this.page,
      required this.pageSize,
      required this.total})
      : super._();
  @override
  StandingRosterPageDto rebuild(
          void Function(StandingRosterPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StandingRosterPageDtoBuilder toBuilder() =>
      StandingRosterPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StandingRosterPageDto &&
        items == other.items &&
        page == other.page &&
        pageSize == other.pageSize &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, pageSize.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StandingRosterPageDto')
          ..add('items', items)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('total', total))
        .toString();
  }
}

class StandingRosterPageDtoBuilder
    implements Builder<StandingRosterPageDto, StandingRosterPageDtoBuilder> {
  _$StandingRosterPageDto? _$v;

  ListBuilder<StandingRosterDto>? _items;
  ListBuilder<StandingRosterDto> get items =>
      _$this._items ??= ListBuilder<StandingRosterDto>();
  set items(ListBuilder<StandingRosterDto>? items) => _$this._items = items;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  StandingRosterPageDtoBuilder() {
    StandingRosterPageDto._defaults(this);
  }

  StandingRosterPageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _page = $v.page;
      _pageSize = $v.pageSize;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StandingRosterPageDto other) {
    _$v = other as _$StandingRosterPageDto;
  }

  @override
  void update(void Function(StandingRosterPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StandingRosterPageDto build() => _build();

  _$StandingRosterPageDto _build() {
    _$StandingRosterPageDto _$result;
    try {
      _$result = _$v ??
          _$StandingRosterPageDto._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'StandingRosterPageDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'StandingRosterPageDto', 'pageSize'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'StandingRosterPageDto', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StandingRosterPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
