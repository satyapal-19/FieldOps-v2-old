// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revoked_count_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RevokedCountDto extends RevokedCountDto {
  @override
  final num revoked;

  factory _$RevokedCountDto([void Function(RevokedCountDtoBuilder)? updates]) =>
      (RevokedCountDtoBuilder()..update(updates))._build();

  _$RevokedCountDto._({required this.revoked}) : super._();
  @override
  RevokedCountDto rebuild(void Function(RevokedCountDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RevokedCountDtoBuilder toBuilder() => RevokedCountDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RevokedCountDto && revoked == other.revoked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, revoked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RevokedCountDto')
          ..add('revoked', revoked))
        .toString();
  }
}

class RevokedCountDtoBuilder
    implements Builder<RevokedCountDto, RevokedCountDtoBuilder> {
  _$RevokedCountDto? _$v;

  num? _revoked;
  num? get revoked => _$this._revoked;
  set revoked(num? revoked) => _$this._revoked = revoked;

  RevokedCountDtoBuilder() {
    RevokedCountDto._defaults(this);
  }

  RevokedCountDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _revoked = $v.revoked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RevokedCountDto other) {
    _$v = other as _$RevokedCountDto;
  }

  @override
  void update(void Function(RevokedCountDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RevokedCountDto build() => _build();

  _$RevokedCountDto _build() {
    final _$result = _$v ??
        _$RevokedCountDto._(
          revoked: BuiltValueNullFieldError.checkNotNull(
              revoked, r'RevokedCountDto', 'revoked'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
