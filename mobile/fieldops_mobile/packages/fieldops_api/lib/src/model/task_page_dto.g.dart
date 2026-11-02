// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TaskPageDto extends TaskPageDto {
  @override
  final BuiltList<TaskDto> items;
  @override
  final num page;
  @override
  final num pageSize;
  @override
  final num total;

  factory _$TaskPageDto([void Function(TaskPageDtoBuilder)? updates]) =>
      (TaskPageDtoBuilder()..update(updates))._build();

  _$TaskPageDto._(
      {required this.items,
      required this.page,
      required this.pageSize,
      required this.total})
      : super._();
  @override
  TaskPageDto rebuild(void Function(TaskPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaskPageDtoBuilder toBuilder() => TaskPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaskPageDto &&
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
    return (newBuiltValueToStringHelper(r'TaskPageDto')
          ..add('items', items)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('total', total))
        .toString();
  }
}

class TaskPageDtoBuilder implements Builder<TaskPageDto, TaskPageDtoBuilder> {
  _$TaskPageDto? _$v;

  ListBuilder<TaskDto>? _items;
  ListBuilder<TaskDto> get items => _$this._items ??= ListBuilder<TaskDto>();
  set items(ListBuilder<TaskDto>? items) => _$this._items = items;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  TaskPageDtoBuilder() {
    TaskPageDto._defaults(this);
  }

  TaskPageDtoBuilder get _$this {
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
  void replace(TaskPageDto other) {
    _$v = other as _$TaskPageDto;
  }

  @override
  void update(void Function(TaskPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaskPageDto build() => _build();

  _$TaskPageDto _build() {
    _$TaskPageDto _$result;
    try {
      _$result = _$v ??
          _$TaskPageDto._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'TaskPageDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'TaskPageDto', 'pageSize'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'TaskPageDto', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TaskPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
