// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_requested_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OtpRequestedDto extends OtpRequestedDto {
  @override
  final bool sent;
  @override
  final num expiresInSeconds;

  factory _$OtpRequestedDto([void Function(OtpRequestedDtoBuilder)? updates]) =>
      (OtpRequestedDtoBuilder()..update(updates))._build();

  _$OtpRequestedDto._({required this.sent, required this.expiresInSeconds})
      : super._();
  @override
  OtpRequestedDto rebuild(void Function(OtpRequestedDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OtpRequestedDtoBuilder toBuilder() => OtpRequestedDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OtpRequestedDto &&
        sent == other.sent &&
        expiresInSeconds == other.expiresInSeconds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sent.hashCode);
    _$hash = $jc(_$hash, expiresInSeconds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OtpRequestedDto')
          ..add('sent', sent)
          ..add('expiresInSeconds', expiresInSeconds))
        .toString();
  }
}

class OtpRequestedDtoBuilder
    implements Builder<OtpRequestedDto, OtpRequestedDtoBuilder> {
  _$OtpRequestedDto? _$v;

  bool? _sent;
  bool? get sent => _$this._sent;
  set sent(bool? sent) => _$this._sent = sent;

  num? _expiresInSeconds;
  num? get expiresInSeconds => _$this._expiresInSeconds;
  set expiresInSeconds(num? expiresInSeconds) =>
      _$this._expiresInSeconds = expiresInSeconds;

  OtpRequestedDtoBuilder() {
    OtpRequestedDto._defaults(this);
  }

  OtpRequestedDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sent = $v.sent;
      _expiresInSeconds = $v.expiresInSeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OtpRequestedDto other) {
    _$v = other as _$OtpRequestedDto;
  }

  @override
  void update(void Function(OtpRequestedDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OtpRequestedDto build() => _build();

  _$OtpRequestedDto _build() {
    final _$result = _$v ??
        _$OtpRequestedDto._(
          sent: BuiltValueNullFieldError.checkNotNull(
              sent, r'OtpRequestedDto', 'sent'),
          expiresInSeconds: BuiltValueNullFieldError.checkNotNull(
              expiresInSeconds, r'OtpRequestedDto', 'expiresInSeconds'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
