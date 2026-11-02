// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LogoutDto extends LogoutDto {
  @override
  final bool? everywhere;

  factory _$LogoutDto([void Function(LogoutDtoBuilder)? updates]) =>
      (LogoutDtoBuilder()..update(updates))._build();

  _$LogoutDto._({this.everywhere}) : super._();
  @override
  LogoutDto rebuild(void Function(LogoutDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LogoutDtoBuilder toBuilder() => LogoutDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LogoutDto && everywhere == other.everywhere;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, everywhere.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LogoutDto')
          ..add('everywhere', everywhere))
        .toString();
  }
}

class LogoutDtoBuilder implements Builder<LogoutDto, LogoutDtoBuilder> {
  _$LogoutDto? _$v;

  bool? _everywhere;
  bool? get everywhere => _$this._everywhere;
  set everywhere(bool? everywhere) => _$this._everywhere = everywhere;

  LogoutDtoBuilder() {
    LogoutDto._defaults(this);
  }

  LogoutDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _everywhere = $v.everywhere;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LogoutDto other) {
    _$v = other as _$LogoutDto;
  }

  @override
  void update(void Function(LogoutDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LogoutDto build() => _build();

  _$LogoutDto _build() {
    final _$result = _$v ??
        _$LogoutDto._(
          everywhere: everywhere,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
