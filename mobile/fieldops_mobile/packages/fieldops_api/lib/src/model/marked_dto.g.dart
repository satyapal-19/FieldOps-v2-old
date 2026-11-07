// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marked_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MarkedDto extends MarkedDto {
  @override
  final num marked;

  factory _$MarkedDto([void Function(MarkedDtoBuilder)? updates]) =>
      (MarkedDtoBuilder()..update(updates))._build();

  _$MarkedDto._({required this.marked}) : super._();
  @override
  MarkedDto rebuild(void Function(MarkedDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MarkedDtoBuilder toBuilder() => MarkedDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MarkedDto && marked == other.marked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, marked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MarkedDto')..add('marked', marked))
        .toString();
  }
}

class MarkedDtoBuilder implements Builder<MarkedDto, MarkedDtoBuilder> {
  _$MarkedDto? _$v;

  num? _marked;
  num? get marked => _$this._marked;
  set marked(num? marked) => _$this._marked = marked;

  MarkedDtoBuilder() {
    MarkedDto._defaults(this);
  }

  MarkedDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _marked = $v.marked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MarkedDto other) {
    _$v = other as _$MarkedDto;
  }

  @override
  void update(void Function(MarkedDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MarkedDto build() => _build();

  _$MarkedDto _build() {
    final _$result = _$v ??
        _$MarkedDto._(
          marked: BuiltValueNullFieldError.checkNotNull(
              marked, r'MarkedDto', 'marked'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
