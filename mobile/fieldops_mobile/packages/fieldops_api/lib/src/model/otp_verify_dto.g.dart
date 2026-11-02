// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OtpVerifyDto extends OtpVerifyDto {
  @override
  final String? deviceId;
  @override
  final String phone;
  @override
  final String code;

  factory _$OtpVerifyDto([void Function(OtpVerifyDtoBuilder)? updates]) =>
      (OtpVerifyDtoBuilder()..update(updates))._build();

  _$OtpVerifyDto._({this.deviceId, required this.phone, required this.code})
      : super._();
  @override
  OtpVerifyDto rebuild(void Function(OtpVerifyDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OtpVerifyDtoBuilder toBuilder() => OtpVerifyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OtpVerifyDto &&
        deviceId == other.deviceId &&
        phone == other.phone &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OtpVerifyDto')
          ..add('deviceId', deviceId)
          ..add('phone', phone)
          ..add('code', code))
        .toString();
  }
}

class OtpVerifyDtoBuilder
    implements Builder<OtpVerifyDto, OtpVerifyDtoBuilder> {
  _$OtpVerifyDto? _$v;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  OtpVerifyDtoBuilder() {
    OtpVerifyDto._defaults(this);
  }

  OtpVerifyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deviceId = $v.deviceId;
      _phone = $v.phone;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OtpVerifyDto other) {
    _$v = other as _$OtpVerifyDto;
  }

  @override
  void update(void Function(OtpVerifyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OtpVerifyDto build() => _build();

  _$OtpVerifyDto _build() {
    final _$result = _$v ??
        _$OtpVerifyDto._(
          deviceId: deviceId,
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'OtpVerifyDto', 'phone'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'OtpVerifyDto', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
