// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AlertPageDto extends AlertPageDto {
  @override
  final BuiltList<AlertDto> items;
  @override
  final num page;
  @override
  final num pageSize;
  @override
  final num total;

  factory _$AlertPageDto([void Function(AlertPageDtoBuilder)? updates]) =>
      (AlertPageDtoBuilder()..update(updates))._build();

  _$AlertPageDto._(
      {required this.items,
      required this.page,
      required this.pageSize,
      required this.total})
      : super._();
  @override
  AlertPageDto rebuild(void Function(AlertPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AlertPageDtoBuilder toBuilder() => AlertPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AlertPageDto &&
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
    return (newBuiltValueToStringHelper(r'AlertPageDto')
          ..add('items', items)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('total', total))
        .toString();
  }
}

class AlertPageDtoBuilder
    implements Builder<AlertPageDto, AlertPageDtoBuilder> {
  _$AlertPageDto? _$v;

  ListBuilder<AlertDto>? _items;
  ListBuilder<AlertDto> get items => _$this._items ??= ListBuilder<AlertDto>();
  set items(ListBuilder<AlertDto>? items) => _$this._items = items;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  AlertPageDtoBuilder() {
    AlertPageDto._defaults(this);
  }

  AlertPageDtoBuilder get _$this {
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
  void replace(AlertPageDto other) {
    _$v = other as _$AlertPageDto;
  }

  @override
  void update(void Function(AlertPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AlertPageDto build() => _build();

  _$AlertPageDto _build() {
    _$AlertPageDto _$result;
    try {
      _$result = _$v ??
          _$AlertPageDto._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'AlertPageDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'AlertPageDto', 'pageSize'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AlertPageDto', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AlertPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
