// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regularization_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegularizationPageDto extends RegularizationPageDto {
  @override
  final BuiltList<RegularizationRequestDto> items;
  @override
  final num page;
  @override
  final num pageSize;
  @override
  final num total;

  factory _$RegularizationPageDto(
          [void Function(RegularizationPageDtoBuilder)? updates]) =>
      (RegularizationPageDtoBuilder()..update(updates))._build();

  _$RegularizationPageDto._(
      {required this.items,
      required this.page,
      required this.pageSize,
      required this.total})
      : super._();
  @override
  RegularizationPageDto rebuild(
          void Function(RegularizationPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegularizationPageDtoBuilder toBuilder() =>
      RegularizationPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegularizationPageDto &&
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
    return (newBuiltValueToStringHelper(r'RegularizationPageDto')
          ..add('items', items)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('total', total))
        .toString();
  }
}

class RegularizationPageDtoBuilder
    implements Builder<RegularizationPageDto, RegularizationPageDtoBuilder> {
  _$RegularizationPageDto? _$v;

  ListBuilder<RegularizationRequestDto>? _items;
  ListBuilder<RegularizationRequestDto> get items =>
      _$this._items ??= ListBuilder<RegularizationRequestDto>();
  set items(ListBuilder<RegularizationRequestDto>? items) =>
      _$this._items = items;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  RegularizationPageDtoBuilder() {
    RegularizationPageDto._defaults(this);
  }

  RegularizationPageDtoBuilder get _$this {
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
  void replace(RegularizationPageDto other) {
    _$v = other as _$RegularizationPageDto;
  }

  @override
  void update(void Function(RegularizationPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegularizationPageDto build() => _build();

  _$RegularizationPageDto _build() {
    _$RegularizationPageDto _$result;
    try {
      _$result = _$v ??
          _$RegularizationPageDto._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'RegularizationPageDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'RegularizationPageDto', 'pageSize'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'RegularizationPageDto', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RegularizationPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
