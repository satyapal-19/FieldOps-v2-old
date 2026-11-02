// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_tokens_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SessionTokensDto extends SessionTokensDto {
  @override
  final String accessToken;
  @override
  final String tokenType;
  @override
  final num expiresInSeconds;
  @override
  final String refreshToken;
  @override
  final DateTime refreshExpiresAt;
  @override
  final StaffProfileDto staff;

  factory _$SessionTokensDto(
          [void Function(SessionTokensDtoBuilder)? updates]) =>
      (SessionTokensDtoBuilder()..update(updates))._build();

  _$SessionTokensDto._(
      {required this.accessToken,
      required this.tokenType,
      required this.expiresInSeconds,
      required this.refreshToken,
      required this.refreshExpiresAt,
      required this.staff})
      : super._();
  @override
  SessionTokensDto rebuild(void Function(SessionTokensDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SessionTokensDtoBuilder toBuilder() =>
      SessionTokensDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SessionTokensDto &&
        accessToken == other.accessToken &&
        tokenType == other.tokenType &&
        expiresInSeconds == other.expiresInSeconds &&
        refreshToken == other.refreshToken &&
        refreshExpiresAt == other.refreshExpiresAt &&
        staff == other.staff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, tokenType.hashCode);
    _$hash = $jc(_$hash, expiresInSeconds.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, refreshExpiresAt.hashCode);
    _$hash = $jc(_$hash, staff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SessionTokensDto')
          ..add('accessToken', accessToken)
          ..add('tokenType', tokenType)
          ..add('expiresInSeconds', expiresInSeconds)
          ..add('refreshToken', refreshToken)
          ..add('refreshExpiresAt', refreshExpiresAt)
          ..add('staff', staff))
        .toString();
  }
}

class SessionTokensDtoBuilder
    implements Builder<SessionTokensDto, SessionTokensDtoBuilder> {
  _$SessionTokensDto? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _tokenType;
  String? get tokenType => _$this._tokenType;
  set tokenType(String? tokenType) => _$this._tokenType = tokenType;

  num? _expiresInSeconds;
  num? get expiresInSeconds => _$this._expiresInSeconds;
  set expiresInSeconds(num? expiresInSeconds) =>
      _$this._expiresInSeconds = expiresInSeconds;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  DateTime? _refreshExpiresAt;
  DateTime? get refreshExpiresAt => _$this._refreshExpiresAt;
  set refreshExpiresAt(DateTime? refreshExpiresAt) =>
      _$this._refreshExpiresAt = refreshExpiresAt;

  StaffProfileDtoBuilder? _staff;
  StaffProfileDtoBuilder get staff =>
      _$this._staff ??= StaffProfileDtoBuilder();
  set staff(StaffProfileDtoBuilder? staff) => _$this._staff = staff;

  SessionTokensDtoBuilder() {
    SessionTokensDto._defaults(this);
  }

  SessionTokensDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _tokenType = $v.tokenType;
      _expiresInSeconds = $v.expiresInSeconds;
      _refreshToken = $v.refreshToken;
      _refreshExpiresAt = $v.refreshExpiresAt;
      _staff = $v.staff.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SessionTokensDto other) {
    _$v = other as _$SessionTokensDto;
  }

  @override
  void update(void Function(SessionTokensDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SessionTokensDto build() => _build();

  _$SessionTokensDto _build() {
    _$SessionTokensDto _$result;
    try {
      _$result = _$v ??
          _$SessionTokensDto._(
            accessToken: BuiltValueNullFieldError.checkNotNull(
                accessToken, r'SessionTokensDto', 'accessToken'),
            tokenType: BuiltValueNullFieldError.checkNotNull(
                tokenType, r'SessionTokensDto', 'tokenType'),
            expiresInSeconds: BuiltValueNullFieldError.checkNotNull(
                expiresInSeconds, r'SessionTokensDto', 'expiresInSeconds'),
            refreshToken: BuiltValueNullFieldError.checkNotNull(
                refreshToken, r'SessionTokensDto', 'refreshToken'),
            refreshExpiresAt: BuiltValueNullFieldError.checkNotNull(
                refreshExpiresAt, r'SessionTokensDto', 'refreshExpiresAt'),
            staff: staff.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'staff';
        staff.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SessionTokensDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
