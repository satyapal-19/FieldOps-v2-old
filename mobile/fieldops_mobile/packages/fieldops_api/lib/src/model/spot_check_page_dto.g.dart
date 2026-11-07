// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_check_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SpotCheckPageDto extends SpotCheckPageDto {
  @override
  final BuiltList<SpotCheckDto> items;
  @override
  final num page;
  @override
  final num pageSize;
  @override
  final num total;

  factory _$SpotCheckPageDto(
          [void Function(SpotCheckPageDtoBuilder)? updates]) =>
      (SpotCheckPageDtoBuilder()..update(updates))._build();

  _$SpotCheckPageDto._(
      {required this.items,
      required this.page,
      required this.pageSize,
      required this.total})
      : super._();
  @override
  SpotCheckPageDto rebuild(void Function(SpotCheckPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SpotCheckPageDtoBuilder toBuilder() =>
      SpotCheckPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SpotCheckPageDto &&
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
    return (newBuiltValueToStringHelper(r'SpotCheckPageDto')
          ..add('items', items)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('total', total))
        .toString();
  }
}

class SpotCheckPageDtoBuilder
    implements Builder<SpotCheckPageDto, SpotCheckPageDtoBuilder> {
  _$SpotCheckPageDto? _$v;

  ListBuilder<SpotCheckDto>? _items;
  ListBuilder<SpotCheckDto> get items =>
      _$this._items ??= ListBuilder<SpotCheckDto>();
  set items(ListBuilder<SpotCheckDto>? items) => _$this._items = items;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  SpotCheckPageDtoBuilder() {
    SpotCheckPageDto._defaults(this);
  }

  SpotCheckPageDtoBuilder get _$this {
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
  void replace(SpotCheckPageDto other) {
    _$v = other as _$SpotCheckPageDto;
  }

  @override
  void update(void Function(SpotCheckPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SpotCheckPageDto build() => _build();

  _$SpotCheckPageDto _build() {
    _$SpotCheckPageDto _$result;
    try {
      _$result = _$v ??
          _$SpotCheckPageDto._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'SpotCheckPageDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'SpotCheckPageDto', 'pageSize'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'SpotCheckPageDto', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SpotCheckPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
