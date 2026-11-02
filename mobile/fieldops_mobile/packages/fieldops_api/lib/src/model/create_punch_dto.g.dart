// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_punch_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreatePunchDtoTypeEnum _$createPunchDtoTypeEnum_IN =
    const CreatePunchDtoTypeEnum._('IN');
const CreatePunchDtoTypeEnum _$createPunchDtoTypeEnum_OUT =
    const CreatePunchDtoTypeEnum._('OUT');

CreatePunchDtoTypeEnum _$createPunchDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'IN':
      return _$createPunchDtoTypeEnum_IN;
    case 'OUT':
      return _$createPunchDtoTypeEnum_OUT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreatePunchDtoTypeEnum> _$createPunchDtoTypeEnumValues =
    BuiltSet<CreatePunchDtoTypeEnum>(const <CreatePunchDtoTypeEnum>[
  _$createPunchDtoTypeEnum_IN,
  _$createPunchDtoTypeEnum_OUT,
]);

Serializer<CreatePunchDtoTypeEnum> _$createPunchDtoTypeEnumSerializer =
    _$CreatePunchDtoTypeEnumSerializer();

class _$CreatePunchDtoTypeEnumSerializer
    implements PrimitiveSerializer<CreatePunchDtoTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'IN': 'CHECK_IN',
    'OUT': 'CHECK_OUT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CHECK_IN': 'IN',
    'CHECK_OUT': 'OUT',
  };

  @override
  final Iterable<Type> types = const <Type>[CreatePunchDtoTypeEnum];
  @override
  final String wireName = 'CreatePunchDtoTypeEnum';

  @override
  Object serialize(Serializers serializers, CreatePunchDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreatePunchDtoTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreatePunchDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreatePunchDto extends CreatePunchDto {
  @override
  final String clientUuid;
  @override
  final CreatePunchDtoTypeEnum type;
  @override
  final String? staffId;
  @override
  final String challengeId;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final num accuracyM;
  @override
  final bool? isMocked;
  @override
  final String? faceImageBase64;
  @override
  final String? aadhaarPidXml;
  @override
  final String? aadhaarTxn;

  factory _$CreatePunchDto([void Function(CreatePunchDtoBuilder)? updates]) =>
      (CreatePunchDtoBuilder()..update(updates))._build();

  _$CreatePunchDto._(
      {required this.clientUuid,
      required this.type,
      this.staffId,
      required this.challengeId,
      required this.latitude,
      required this.longitude,
      required this.accuracyM,
      this.isMocked,
      this.faceImageBase64,
      this.aadhaarPidXml,
      this.aadhaarTxn})
      : super._();
  @override
  CreatePunchDto rebuild(void Function(CreatePunchDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatePunchDtoBuilder toBuilder() => CreatePunchDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatePunchDto &&
        clientUuid == other.clientUuid &&
        type == other.type &&
        staffId == other.staffId &&
        challengeId == other.challengeId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        accuracyM == other.accuracyM &&
        isMocked == other.isMocked &&
        faceImageBase64 == other.faceImageBase64 &&
        aadhaarPidXml == other.aadhaarPidXml &&
        aadhaarTxn == other.aadhaarTxn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientUuid.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, challengeId.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, accuracyM.hashCode);
    _$hash = $jc(_$hash, isMocked.hashCode);
    _$hash = $jc(_$hash, faceImageBase64.hashCode);
    _$hash = $jc(_$hash, aadhaarPidXml.hashCode);
    _$hash = $jc(_$hash, aadhaarTxn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreatePunchDto')
          ..add('clientUuid', clientUuid)
          ..add('type', type)
          ..add('staffId', staffId)
          ..add('challengeId', challengeId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('accuracyM', accuracyM)
          ..add('isMocked', isMocked)
          ..add('faceImageBase64', faceImageBase64)
          ..add('aadhaarPidXml', aadhaarPidXml)
          ..add('aadhaarTxn', aadhaarTxn))
        .toString();
  }
}

class CreatePunchDtoBuilder
    implements Builder<CreatePunchDto, CreatePunchDtoBuilder> {
  _$CreatePunchDto? _$v;

  String? _clientUuid;
  String? get clientUuid => _$this._clientUuid;
  set clientUuid(String? clientUuid) => _$this._clientUuid = clientUuid;

  CreatePunchDtoTypeEnum? _type;
  CreatePunchDtoTypeEnum? get type => _$this._type;
  set type(CreatePunchDtoTypeEnum? type) => _$this._type = type;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

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

  bool? _isMocked;
  bool? get isMocked => _$this._isMocked;
  set isMocked(bool? isMocked) => _$this._isMocked = isMocked;

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

  CreatePunchDtoBuilder() {
    CreatePunchDto._defaults(this);
  }

  CreatePunchDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientUuid = $v.clientUuid;
      _type = $v.type;
      _staffId = $v.staffId;
      _challengeId = $v.challengeId;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _accuracyM = $v.accuracyM;
      _isMocked = $v.isMocked;
      _faceImageBase64 = $v.faceImageBase64;
      _aadhaarPidXml = $v.aadhaarPidXml;
      _aadhaarTxn = $v.aadhaarTxn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatePunchDto other) {
    _$v = other as _$CreatePunchDto;
  }

  @override
  void update(void Function(CreatePunchDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatePunchDto build() => _build();

  _$CreatePunchDto _build() {
    final _$result = _$v ??
        _$CreatePunchDto._(
          clientUuid: BuiltValueNullFieldError.checkNotNull(
              clientUuid, r'CreatePunchDto', 'clientUuid'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CreatePunchDto', 'type'),
          staffId: staffId,
          challengeId: BuiltValueNullFieldError.checkNotNull(
              challengeId, r'CreatePunchDto', 'challengeId'),
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'CreatePunchDto', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'CreatePunchDto', 'longitude'),
          accuracyM: BuiltValueNullFieldError.checkNotNull(
              accuracyM, r'CreatePunchDto', 'accuracyM'),
          isMocked: isMocked,
          faceImageBase64: faceImageBase64,
          aadhaarPidXml: aadhaarPidXml,
          aadhaarTxn: aadhaarTxn,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
