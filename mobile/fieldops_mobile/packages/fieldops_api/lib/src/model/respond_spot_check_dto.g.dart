// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'respond_spot_check_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RespondSpotCheckDto extends RespondSpotCheckDto {
  @override
  final String clientUuid;
  @override
  final String challengeId;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final num accuracyM;
  @override
  final String? faceImageBase64;
  @override
  final String? aadhaarPidXml;
  @override
  final String? aadhaarTxn;

  factory _$RespondSpotCheckDto(
          [void Function(RespondSpotCheckDtoBuilder)? updates]) =>
      (RespondSpotCheckDtoBuilder()..update(updates))._build();

  _$RespondSpotCheckDto._(
      {required this.clientUuid,
      required this.challengeId,
      required this.latitude,
      required this.longitude,
      required this.accuracyM,
      this.faceImageBase64,
      this.aadhaarPidXml,
      this.aadhaarTxn})
      : super._();
  @override
  RespondSpotCheckDto rebuild(
          void Function(RespondSpotCheckDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RespondSpotCheckDtoBuilder toBuilder() =>
      RespondSpotCheckDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RespondSpotCheckDto &&
        clientUuid == other.clientUuid &&
        challengeId == other.challengeId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        accuracyM == other.accuracyM &&
        faceImageBase64 == other.faceImageBase64 &&
        aadhaarPidXml == other.aadhaarPidXml &&
        aadhaarTxn == other.aadhaarTxn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientUuid.hashCode);
    _$hash = $jc(_$hash, challengeId.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, accuracyM.hashCode);
    _$hash = $jc(_$hash, faceImageBase64.hashCode);
    _$hash = $jc(_$hash, aadhaarPidXml.hashCode);
    _$hash = $jc(_$hash, aadhaarTxn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RespondSpotCheckDto')
          ..add('clientUuid', clientUuid)
          ..add('challengeId', challengeId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('accuracyM', accuracyM)
          ..add('faceImageBase64', faceImageBase64)
          ..add('aadhaarPidXml', aadhaarPidXml)
          ..add('aadhaarTxn', aadhaarTxn))
        .toString();
  }
}

class RespondSpotCheckDtoBuilder
    implements Builder<RespondSpotCheckDto, RespondSpotCheckDtoBuilder> {
  _$RespondSpotCheckDto? _$v;

  String? _clientUuid;
  String? get clientUuid => _$this._clientUuid;
  set clientUuid(String? clientUuid) => _$this._clientUuid = clientUuid;

  String? _challengeId;
  String? get challengeId => _$this._challengeId;
  set challengeId(String? challengeId) => _$this._challengeId = challengeId;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  num? _accuracyM;
  num? get accuracyM => _$this._accuracyM;
  set accuracyM(num? accuracyM) => _$this._accuracyM = accuracyM;

  String? _faceImageBase64;
  String? get faceImageBase64 => _$this._faceImageBase64;
  set faceImageBase64(String? faceImageBase64) =>
      _$this._faceImageBase64 = faceImageBase64;

  String? _aadhaarPidXml;
  String? get aadhaarPidXml => _$this._aadhaarPidXml;
  set aadhaarPidXml(String? aadhaarPidXml) =>
      _$this._aadhaarPidXml = aadhaarPidXml;

  String? _aadhaarTxn;
  String? get aadhaarTxn => _$this._aadhaarTxn;
  set aadhaarTxn(String? aadhaarTxn) => _$this._aadhaarTxn = aadhaarTxn;

  RespondSpotCheckDtoBuilder() {
    RespondSpotCheckDto._defaults(this);
  }

  RespondSpotCheckDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientUuid = $v.clientUuid;
      _challengeId = $v.challengeId;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _accuracyM = $v.accuracyM;
      _faceImageBase64 = $v.faceImageBase64;
      _aadhaarPidXml = $v.aadhaarPidXml;
      _aadhaarTxn = $v.aadhaarTxn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RespondSpotCheckDto other) {
    _$v = other as _$RespondSpotCheckDto;
  }

  @override
  void update(void Function(RespondSpotCheckDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RespondSpotCheckDto build() => _build();

  _$RespondSpotCheckDto _build() {
    final _$result = _$v ??
        _$RespondSpotCheckDto._(
          clientUuid: BuiltValueNullFieldError.checkNotNull(
              clientUuid, r'RespondSpotCheckDto', 'clientUuid'),
          challengeId: BuiltValueNullFieldError.checkNotNull(
              challengeId, r'RespondSpotCheckDto', 'challengeId'),
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'RespondSpotCheckDto', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'RespondSpotCheckDto', 'longitude'),
          accuracyM: BuiltValueNullFieldError.checkNotNull(
              accuracyM, r'RespondSpotCheckDto', 'accuracyM'),
          faceImageBase64: faceImageBase64,
          aadhaarPidXml: aadhaarPidXml,
          aadhaarTxn: aadhaarTxn,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
