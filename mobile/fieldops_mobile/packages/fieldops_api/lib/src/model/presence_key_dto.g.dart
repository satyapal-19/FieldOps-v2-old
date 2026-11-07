// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presence_key_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PresenceKeyDto extends PresenceKeyDto {
  @override
  final String key;
  @override
  final num periodSeconds;
  @override
  final num digits;

  factory _$PresenceKeyDto([void Function(PresenceKeyDtoBuilder)? updates]) =>
      (PresenceKeyDtoBuilder()..update(updates))._build();

  _$PresenceKeyDto._(
      {required this.key, required this.periodSeconds, required this.digits})
      : super._();
  @override
  PresenceKeyDto rebuild(void Function(PresenceKeyDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PresenceKeyDtoBuilder toBuilder() => PresenceKeyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PresenceKeyDto &&
        key == other.key &&
        periodSeconds == other.periodSeconds &&
        digits == other.digits;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, periodSeconds.hashCode);
    _$hash = $jc(_$hash, digits.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PresenceKeyDto')
          ..add('key', key)
          ..add('periodSeconds', periodSeconds)
          ..add('digits', digits))
        .toString();
  }
}

class PresenceKeyDtoBuilder
    implements Builder<PresenceKeyDto, PresenceKeyDtoBuilder> {
  _$PresenceKeyDto? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  num? _periodSeconds;
  num? get periodSeconds => _$this._periodSeconds;
  set periodSeconds(num? periodSeconds) =>
      _$this._periodSeconds = periodSeconds;

  num? _digits;
  num? get digits => _$this._digits;
  set digits(num? digits) => _$this._digits = digits;

  PresenceKeyDtoBuilder() {
    PresenceKeyDto._defaults(this);
  }

  PresenceKeyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _periodSeconds = $v.periodSeconds;
      _digits = $v.digits;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PresenceKeyDto other) {
    _$v = other as _$PresenceKeyDto;
  }

  @override
  void update(void Function(PresenceKeyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PresenceKeyDto build() => _build();

  _$PresenceKeyDto _build() {
    final _$result = _$v ??
        _$PresenceKeyDto._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'PresenceKeyDto', 'key'),
          periodSeconds: BuiltValueNullFieldError.checkNotNull(
              periodSeconds, r'PresenceKeyDto', 'periodSeconds'),
          digits: BuiltValueNullFieldError.checkNotNull(
              digits, r'PresenceKeyDto', 'digits'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
