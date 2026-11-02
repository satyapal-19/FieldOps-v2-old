// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StaffPageDto extends StaffPageDto {
  @override
  final BuiltList<StaffProfileDto> items;
  @override
  final num page;
  @override
  final num pageSize;
  @override
  final num total;

  factory _$StaffPageDto([void Function(StaffPageDtoBuilder)? updates]) =>
      (StaffPageDtoBuilder()..update(updates))._build();

  _$StaffPageDto._(
      {required this.items,
      required this.page,
      required this.pageSize,
      required this.total})
      : super._();
  @override
  StaffPageDto rebuild(void Function(StaffPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StaffPageDtoBuilder toBuilder() => StaffPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StaffPageDto &&
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
    return (newBuiltValueToStringHelper(r'StaffPageDto')
          ..add('items', items)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('total', total))
        .toString();
  }
}

class StaffPageDtoBuilder
    implements Builder<StaffPageDto, StaffPageDtoBuilder> {
  _$StaffPageDto? _$v;

  ListBuilder<StaffProfileDto>? _items;
  ListBuilder<StaffProfileDto> get items =>
      _$this._items ??= ListBuilder<StaffProfileDto>();
  set items(ListBuilder<StaffProfileDto>? items) => _$this._items = items;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  StaffPageDtoBuilder() {
    StaffPageDto._defaults(this);
  }

  StaffPageDtoBuilder get _$this {
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
  void replace(StaffPageDto other) {
    _$v = other as _$StaffPageDto;
  }

  @override
  void update(void Function(StaffPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StaffPageDto build() => _build();

  _$StaffPageDto _build() {
    _$StaffPageDto _$result;
    try {
      _$result = _$v ??
          _$StaffPageDto._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'StaffPageDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'StaffPageDto', 'pageSize'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'StaffPageDto', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StaffPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
