// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_report_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StaffReportDto extends StaffReportDto {
  @override
  final BuiltList<StaffReportRowDto> items;
  @override
  final num page;
  @override
  final num pageSize;
  @override
  final num total;

  factory _$StaffReportDto([void Function(StaffReportDtoBuilder)? updates]) =>
      (StaffReportDtoBuilder()..update(updates))._build();

  _$StaffReportDto._(
      {required this.items,
      required this.page,
      required this.pageSize,
      required this.total})
      : super._();
  @override
  StaffReportDto rebuild(void Function(StaffReportDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StaffReportDtoBuilder toBuilder() => StaffReportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StaffReportDto &&
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
    return (newBuiltValueToStringHelper(r'StaffReportDto')
          ..add('items', items)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('total', total))
        .toString();
  }
}

class StaffReportDtoBuilder
    implements Builder<StaffReportDto, StaffReportDtoBuilder> {
  _$StaffReportDto? _$v;

  ListBuilder<StaffReportRowDto>? _items;
  ListBuilder<StaffReportRowDto> get items =>
      _$this._items ??= ListBuilder<StaffReportRowDto>();
  set items(ListBuilder<StaffReportRowDto>? items) => _$this._items = items;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  StaffReportDtoBuilder() {
    StaffReportDto._defaults(this);
  }

  StaffReportDtoBuilder get _$this {
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
  void replace(StaffReportDto other) {
    _$v = other as _$StaffReportDto;
  }

  @override
  void update(void Function(StaffReportDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StaffReportDto build() => _build();

  _$StaffReportDto _build() {
    _$StaffReportDto _$result;
    try {
      _$result = _$v ??
          _$StaffReportDto._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'StaffReportDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'StaffReportDto', 'pageSize'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'StaffReportDto', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StaffReportDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
