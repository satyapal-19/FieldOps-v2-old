// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_login_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PasswordLoginDto extends PasswordLoginDto {
  @override
  final String? deviceId;
  @override
  final String identifier;
  @override
  final String password;

  factory _$PasswordLoginDto(
          [void Function(PasswordLoginDtoBuilder)? updates]) =>
      (PasswordLoginDtoBuilder()..update(updates))._build();

  _$PasswordLoginDto._(
      {this.deviceId, required this.identifier, required this.password})
      : super._();
  @override
  PasswordLoginDto rebuild(void Function(PasswordLoginDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PasswordLoginDtoBuilder toBuilder() =>
      PasswordLoginDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PasswordLoginDto &&
        deviceId == other.deviceId &&
        identifier == other.identifier &&
        password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, identifier.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PasswordLoginDto')
          ..add('deviceId', deviceId)
          ..add('identifier', identifier)
          ..add('password', password))
        .toString();
  }
}

class PasswordLoginDtoBuilder
    implements Builder<PasswordLoginDto, PasswordLoginDtoBuilder> {
  _$PasswordLoginDto? _$v;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _identifier;
  String? get identifier => _$this._identifier;
  set identifier(String? identifier) => _$this._identifier = identifier;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  PasswordLoginDtoBuilder() {
    PasswordLoginDto._defaults(this);
  }

  PasswordLoginDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deviceId = $v.deviceId;
      _identifier = $v.identifier;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PasswordLoginDto other) {
    _$v = other as _$PasswordLoginDto;
  }

  @override
  void update(void Function(PasswordLoginDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PasswordLoginDto build() => _build();

  _$PasswordLoginDto _build() {
    final _$result = _$v ??
        _$PasswordLoginDto._(
          deviceId: deviceId,
          identifier: BuiltValueNullFieldError.checkNotNull(
              identifier, r'PasswordLoginDto', 'identifier'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'PasswordLoginDto', 'password'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
