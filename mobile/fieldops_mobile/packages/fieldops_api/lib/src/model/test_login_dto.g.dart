// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_login_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TestLoginDto extends TestLoginDto {
  @override
  final String? deviceId;
  @override
  final String identifier;

  factory _$TestLoginDto([void Function(TestLoginDtoBuilder)? updates]) =>
      (TestLoginDtoBuilder()..update(updates))._build();

  _$TestLoginDto._({this.deviceId, required this.identifier}) : super._();
  @override
  TestLoginDto rebuild(void Function(TestLoginDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TestLoginDtoBuilder toBuilder() => TestLoginDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TestLoginDto &&
        deviceId == other.deviceId &&
        identifier == other.identifier;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, identifier.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TestLoginDto')
          ..add('deviceId', deviceId)
          ..add('identifier', identifier))
        .toString();
  }
}

class TestLoginDtoBuilder
    implements Builder<TestLoginDto, TestLoginDtoBuilder> {
  _$TestLoginDto? _$v;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _identifier;
  String? get identifier => _$this._identifier;
  set identifier(String? identifier) => _$this._identifier = identifier;

  TestLoginDtoBuilder() {
    TestLoginDto._defaults(this);
  }

  TestLoginDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deviceId = $v.deviceId;
      _identifier = $v.identifier;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TestLoginDto other) {
    _$v = other as _$TestLoginDto;
  }

  @override
  void update(void Function(TestLoginDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TestLoginDto build() => _build();

  _$TestLoginDto _build() {
    final _$result = _$v ??
        _$TestLoginDto._(
          deviceId: deviceId,
          identifier: BuiltValueNullFieldError.checkNotNull(
              identifier, r'TestLoginDto', 'identifier'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
