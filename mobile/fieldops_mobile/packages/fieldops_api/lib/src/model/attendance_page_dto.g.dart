// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AttendancePageDto extends AttendancePageDto {
  @override
  final BuiltList<AttendanceLogDto> items;
  @override
  final num page;
  @override
  final num pageSize;
  @override
  final num total;

  factory _$AttendancePageDto(
          [void Function(AttendancePageDtoBuilder)? updates]) =>
      (AttendancePageDtoBuilder()..update(updates))._build();

  _$AttendancePageDto._(
      {required this.items,
      required this.page,
      required this.pageSize,
      required this.total})
      : super._();
  @override
  AttendancePageDto rebuild(void Function(AttendancePageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttendancePageDtoBuilder toBuilder() =>
      AttendancePageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttendancePageDto &&
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
    return (newBuiltValueToStringHelper(r'AttendancePageDto')
          ..add('items', items)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('total', total))
        .toString();
  }
}

class AttendancePageDtoBuilder
    implements Builder<AttendancePageDto, AttendancePageDtoBuilder> {
  _$AttendancePageDto? _$v;

  ListBuilder<AttendanceLogDto>? _items;
  ListBuilder<AttendanceLogDto> get items =>
      _$this._items ??= ListBuilder<AttendanceLogDto>();
  set items(ListBuilder<AttendanceLogDto>? items) => _$this._items = items;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  AttendancePageDtoBuilder() {
    AttendancePageDto._defaults(this);
  }

  AttendancePageDtoBuilder get _$this {
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
  void replace(AttendancePageDto other) {
    _$v = other as _$AttendancePageDto;
  }

  @override
  void update(void Function(AttendancePageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttendancePageDto build() => _build();

  _$AttendancePageDto _build() {
    _$AttendancePageDto _$result;
    try {
      _$result = _$v ??
          _$AttendancePageDto._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'AttendancePageDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'AttendancePageDto', 'pageSize'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AttendancePageDto', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AttendancePageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
