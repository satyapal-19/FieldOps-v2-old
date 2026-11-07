// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_read_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MarkReadDto extends MarkReadDto {
  @override
  final BuiltList<String>? ids;
  @override
  final bool? all;

  factory _$MarkReadDto([void Function(MarkReadDtoBuilder)? updates]) =>
      (MarkReadDtoBuilder()..update(updates))._build();

  _$MarkReadDto._({this.ids, this.all}) : super._();
  @override
  MarkReadDto rebuild(void Function(MarkReadDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MarkReadDtoBuilder toBuilder() => MarkReadDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MarkReadDto && ids == other.ids && all == other.all;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ids.hashCode);
    _$hash = $jc(_$hash, all.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MarkReadDto')
          ..add('ids', ids)
          ..add('all', all))
        .toString();
  }
}

class MarkReadDtoBuilder implements Builder<MarkReadDto, MarkReadDtoBuilder> {
  _$MarkReadDto? _$v;

  ListBuilder<String>? _ids;
  ListBuilder<String> get ids => _$this._ids ??= ListBuilder<String>();
  set ids(ListBuilder<String>? ids) => _$this._ids = ids;

  bool? _all;
  bool? get all => _$this._all;
  set all(bool? all) => _$this._all = all;

  MarkReadDtoBuilder() {
    MarkReadDto._defaults(this);
  }

  MarkReadDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ids = $v.ids?.toBuilder();
      _all = $v.all;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MarkReadDto other) {
    _$v = other as _$MarkReadDto;
  }

  @override
  void update(void Function(MarkReadDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MarkReadDto build() => _build();

  _$MarkReadDto _build() {
    _$MarkReadDto _$result;
    try {
      _$result = _$v ??
          _$MarkReadDto._(
            ids: _ids?.build(),
            all: all,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ids';
        _ids?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MarkReadDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
