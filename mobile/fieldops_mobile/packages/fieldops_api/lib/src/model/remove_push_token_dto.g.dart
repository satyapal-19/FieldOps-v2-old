// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_push_token_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RemovePushTokenDto extends RemovePushTokenDto {
  @override
  final String token;

  factory _$RemovePushTokenDto(
          [void Function(RemovePushTokenDtoBuilder)? updates]) =>
      (RemovePushTokenDtoBuilder()..update(updates))._build();

  _$RemovePushTokenDto._({required this.token}) : super._();
  @override
  RemovePushTokenDto rebuild(
          void Function(RemovePushTokenDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RemovePushTokenDtoBuilder toBuilder() =>
      RemovePushTokenDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RemovePushTokenDto && token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RemovePushTokenDto')
          ..add('token', token))
        .toString();
  }
}

class RemovePushTokenDtoBuilder
    implements Builder<RemovePushTokenDto, RemovePushTokenDtoBuilder> {
  _$RemovePushTokenDto? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  RemovePushTokenDtoBuilder() {
    RemovePushTokenDto._defaults(this);
  }

  RemovePushTokenDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RemovePushTokenDto other) {
    _$v = other as _$RemovePushTokenDto;
  }

  @override
  void update(void Function(RemovePushTokenDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RemovePushTokenDto build() => _build();

  _$RemovePushTokenDto _build() {
    final _$result = _$v ??
        _$RemovePushTokenDto._(
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'RemovePushTokenDto', 'token'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
