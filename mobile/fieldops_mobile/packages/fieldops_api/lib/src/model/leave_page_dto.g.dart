// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LeavePageDto extends LeavePageDto {
  @override
  final BuiltList<LeaveRequestDto> items;
  @override
  final num page;
  @override
  final num pageSize;
  @override
  final num total;

  factory _$LeavePageDto([void Function(LeavePageDtoBuilder)? updates]) =>
      (LeavePageDtoBuilder()..update(updates))._build();

  _$LeavePageDto._(
      {required this.items,
      required this.page,
      required this.pageSize,
      required this.total})
      : super._();
  @override
  LeavePageDto rebuild(void Function(LeavePageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LeavePageDtoBuilder toBuilder() => LeavePageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LeavePageDto &&
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
    return (newBuiltValueToStringHelper(r'LeavePageDto')
          ..add('items', items)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('total', total))
        .toString();
  }
}

class LeavePageDtoBuilder
    implements Builder<LeavePageDto, LeavePageDtoBuilder> {
  _$LeavePageDto? _$v;

  ListBuilder<LeaveRequestDto>? _items;
  ListBuilder<LeaveRequestDto> get items =>
      _$this._items ??= ListBuilder<LeaveRequestDto>();
  set items(ListBuilder<LeaveRequestDto>? items) => _$this._items = items;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  LeavePageDtoBuilder() {
    LeavePageDto._defaults(this);
  }

  LeavePageDtoBuilder get _$this {
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
  void replace(LeavePageDto other) {
    _$v = other as _$LeavePageDto;
  }

  @override
  void update(void Function(LeavePageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LeavePageDto build() => _build();

  _$LeavePageDto _build() {
    _$LeavePageDto _$result;
    try {
      _$result = _$v ??
          _$LeavePageDto._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'LeavePageDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'LeavePageDto', 'pageSize'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'LeavePageDto', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LeavePageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
