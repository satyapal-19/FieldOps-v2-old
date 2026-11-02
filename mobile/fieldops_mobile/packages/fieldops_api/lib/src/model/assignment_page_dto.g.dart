// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssignmentPageDto extends AssignmentPageDto {
  @override
  final BuiltList<AssignmentDto> items;
  @override
  final num page;
  @override
  final num pageSize;
  @override
  final num total;

  factory _$AssignmentPageDto(
          [void Function(AssignmentPageDtoBuilder)? updates]) =>
      (AssignmentPageDtoBuilder()..update(updates))._build();

  _$AssignmentPageDto._(
      {required this.items,
      required this.page,
      required this.pageSize,
      required this.total})
      : super._();
  @override
  AssignmentPageDto rebuild(void Function(AssignmentPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssignmentPageDtoBuilder toBuilder() =>
      AssignmentPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssignmentPageDto &&
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
    return (newBuiltValueToStringHelper(r'AssignmentPageDto')
          ..add('items', items)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('total', total))
        .toString();
  }
}

class AssignmentPageDtoBuilder
    implements Builder<AssignmentPageDto, AssignmentPageDtoBuilder> {
  _$AssignmentPageDto? _$v;

  ListBuilder<AssignmentDto>? _items;
  ListBuilder<AssignmentDto> get items =>
      _$this._items ??= ListBuilder<AssignmentDto>();
  set items(ListBuilder<AssignmentDto>? items) => _$this._items = items;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  AssignmentPageDtoBuilder() {
    AssignmentPageDto._defaults(this);
  }

  AssignmentPageDtoBuilder get _$this {
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
  void replace(AssignmentPageDto other) {
    _$v = other as _$AssignmentPageDto;
  }

  @override
  void update(void Function(AssignmentPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssignmentPageDto build() => _build();

  _$AssignmentPageDto _build() {
    _$AssignmentPageDto _$result;
    try {
      _$result = _$v ??
          _$AssignmentPageDto._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'AssignmentPageDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'AssignmentPageDto', 'pageSize'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AssignmentPageDto', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AssignmentPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
