// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LiveDto extends LiveDto {
  @override
  final DateTime at;
  @override
  final BuiltList<LivePositionDto> items;

  factory _$LiveDto([void Function(LiveDtoBuilder)? updates]) =>
      (LiveDtoBuilder()..update(updates))._build();

  _$LiveDto._({required this.at, required this.items}) : super._();
  @override
  LiveDto rebuild(void Function(LiveDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LiveDtoBuilder toBuilder() => LiveDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LiveDto && at == other.at && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LiveDto')
          ..add('at', at)
          ..add('items', items))
        .toString();
  }
}

class LiveDtoBuilder implements Builder<LiveDto, LiveDtoBuilder> {
  _$LiveDto? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  ListBuilder<LivePositionDto>? _items;
  ListBuilder<LivePositionDto> get items =>
      _$this._items ??= ListBuilder<LivePositionDto>();
  set items(ListBuilder<LivePositionDto>? items) => _$this._items = items;

  LiveDtoBuilder() {
    LiveDto._defaults(this);
  }

  LiveDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LiveDto other) {
    _$v = other as _$LiveDto;
  }

  @override
  void update(void Function(LiveDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LiveDto build() => _build();

  _$LiveDto _build() {
    _$LiveDto _$result;
    try {
      _$result = _$v ??
          _$LiveDto._(
            at: BuiltValueNullFieldError.checkNotNull(at, r'LiveDto', 'at'),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LiveDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
