// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ComplaintPageDto extends ComplaintPageDto {
  @override
  final BuiltList<ComplaintDto> items;
  @override
  final num page;
  @override
  final num pageSize;
  @override
  final num total;

  factory _$ComplaintPageDto(
          [void Function(ComplaintPageDtoBuilder)? updates]) =>
      (ComplaintPageDtoBuilder()..update(updates))._build();

  _$ComplaintPageDto._(
      {required this.items,
      required this.page,
      required this.pageSize,
      required this.total})
      : super._();
  @override
  ComplaintPageDto rebuild(void Function(ComplaintPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplaintPageDtoBuilder toBuilder() =>
      ComplaintPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplaintPageDto &&
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
    return (newBuiltValueToStringHelper(r'ComplaintPageDto')
          ..add('items', items)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('total', total))
        .toString();
  }
}

class ComplaintPageDtoBuilder
    implements Builder<ComplaintPageDto, ComplaintPageDtoBuilder> {
  _$ComplaintPageDto? _$v;

  ListBuilder<ComplaintDto>? _items;
  ListBuilder<ComplaintDto> get items =>
      _$this._items ??= ListBuilder<ComplaintDto>();
  set items(ListBuilder<ComplaintDto>? items) => _$this._items = items;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  ComplaintPageDtoBuilder() {
    ComplaintPageDto._defaults(this);
  }

  ComplaintPageDtoBuilder get _$this {
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
  void replace(ComplaintPageDto other) {
    _$v = other as _$ComplaintPageDto;
  }

  @override
  void update(void Function(ComplaintPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplaintPageDto build() => _build();

  _$ComplaintPageDto _build() {
    _$ComplaintPageDto _$result;
    try {
      _$result = _$v ??
          _$ComplaintPageDto._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'ComplaintPageDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'ComplaintPageDto', 'pageSize'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ComplaintPageDto', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ComplaintPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
