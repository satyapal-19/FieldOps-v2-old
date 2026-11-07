// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AppInfoDtoFaceProviderEnum _$appInfoDtoFaceProviderEnum_local =
    const AppInfoDtoFaceProviderEnum._('local');
const AppInfoDtoFaceProviderEnum _$appInfoDtoFaceProviderEnum_aadhaar =
    const AppInfoDtoFaceProviderEnum._('aadhaar');

AppInfoDtoFaceProviderEnum _$appInfoDtoFaceProviderEnumValueOf(String name) {
  switch (name) {
    case 'local':
      return _$appInfoDtoFaceProviderEnum_local;
    case 'aadhaar':
      return _$appInfoDtoFaceProviderEnum_aadhaar;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AppInfoDtoFaceProviderEnum> _$appInfoDtoFaceProviderEnumValues =
    BuiltSet<AppInfoDtoFaceProviderEnum>(const <AppInfoDtoFaceProviderEnum>[
  _$appInfoDtoFaceProviderEnum_local,
  _$appInfoDtoFaceProviderEnum_aadhaar,
]);

Serializer<AppInfoDtoFaceProviderEnum> _$appInfoDtoFaceProviderEnumSerializer =
    _$AppInfoDtoFaceProviderEnumSerializer();

class _$AppInfoDtoFaceProviderEnumSerializer
    implements PrimitiveSerializer<AppInfoDtoFaceProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'local': 'local',
    'aadhaar': 'aadhaar',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'local': 'local',
    'aadhaar': 'aadhaar',
  };

  @override
  final Iterable<Type> types = const <Type>[AppInfoDtoFaceProviderEnum];
  @override
  final String wireName = 'AppInfoDtoFaceProviderEnum';

  @override
  Object serialize(Serializers serializers, AppInfoDtoFaceProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AppInfoDtoFaceProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AppInfoDtoFaceProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AppInfoDto extends AppInfoDto {
  @override
  final num minVersionCode;
  @override
  final num latestVersionCode;
  @override
  final String? updateUrl;
  @override
  final AppInfoDtoFaceProviderEnum faceProvider;
  @override
  final num pingIntervalSeconds;
  @override
  final num silentGapMinutes;
  @override
  final DateTime serverTime;

  factory _$AppInfoDto([void Function(AppInfoDtoBuilder)? updates]) =>
      (AppInfoDtoBuilder()..update(updates))._build();

  _$AppInfoDto._(
      {required this.minVersionCode,
      required this.latestVersionCode,
      this.updateUrl,
      required this.faceProvider,
      required this.pingIntervalSeconds,
      required this.silentGapMinutes,
      required this.serverTime})
      : super._();
  @override
  AppInfoDto rebuild(void Function(AppInfoDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppInfoDtoBuilder toBuilder() => AppInfoDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppInfoDto &&
        minVersionCode == other.minVersionCode &&
        latestVersionCode == other.latestVersionCode &&
        updateUrl == other.updateUrl &&
        faceProvider == other.faceProvider &&
        pingIntervalSeconds == other.pingIntervalSeconds &&
        silentGapMinutes == other.silentGapMinutes &&
        serverTime == other.serverTime;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, minVersionCode.hashCode);
    _$hash = $jc(_$hash, latestVersionCode.hashCode);
    _$hash = $jc(_$hash, updateUrl.hashCode);
    _$hash = $jc(_$hash, faceProvider.hashCode);
    _$hash = $jc(_$hash, pingIntervalSeconds.hashCode);
    _$hash = $jc(_$hash, silentGapMinutes.hashCode);
    _$hash = $jc(_$hash, serverTime.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppInfoDto')
          ..add('minVersionCode', minVersionCode)
          ..add('latestVersionCode', latestVersionCode)
          ..add('updateUrl', updateUrl)
          ..add('faceProvider', faceProvider)
          ..add('pingIntervalSeconds', pingIntervalSeconds)
          ..add('silentGapMinutes', silentGapMinutes)
          ..add('serverTime', serverTime))
        .toString();
  }
}

class AppInfoDtoBuilder implements Builder<AppInfoDto, AppInfoDtoBuilder> {
  _$AppInfoDto? _$v;

  num? _minVersionCode;
  num? get minVersionCode => _$this._minVersionCode;
  set minVersionCode(num? minVersionCode) =>
      _$this._minVersionCode = minVersionCode;

  num? _latestVersionCode;
  num? get latestVersionCode => _$this._latestVersionCode;
  set latestVersionCode(num? latestVersionCode) =>
      _$this._latestVersionCode = latestVersionCode;

  String? _updateUrl;
  String? get updateUrl => _$this._updateUrl;
  set updateUrl(String? updateUrl) => _$this._updateUrl = updateUrl;

  AppInfoDtoFaceProviderEnum? _faceProvider;
  AppInfoDtoFaceProviderEnum? get faceProvider => _$this._faceProvider;
  set faceProvider(AppInfoDtoFaceProviderEnum? faceProvider) =>
      _$this._faceProvider = faceProvider;

  num? _pingIntervalSeconds;
  num? get pingIntervalSeconds => _$this._pingIntervalSeconds;
  set pingIntervalSeconds(num? pingIntervalSeconds) =>
      _$this._pingIntervalSeconds = pingIntervalSeconds;

  num? _silentGapMinutes;
  num? get silentGapMinutes => _$this._silentGapMinutes;
  set silentGapMinutes(num? silentGapMinutes) =>
      _$this._silentGapMinutes = silentGapMinutes;

  DateTime? _serverTime;
  DateTime? get serverTime => _$this._serverTime;
  set serverTime(DateTime? serverTime) => _$this._serverTime = serverTime;

  AppInfoDtoBuilder() {
    AppInfoDto._defaults(this);
  }

  AppInfoDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minVersionCode = $v.minVersionCode;
      _latestVersionCode = $v.latestVersionCode;
      _updateUrl = $v.updateUrl;
      _faceProvider = $v.faceProvider;
      _pingIntervalSeconds = $v.pingIntervalSeconds;
      _silentGapMinutes = $v.silentGapMinutes;
      _serverTime = $v.serverTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppInfoDto other) {
    _$v = other as _$AppInfoDto;
  }

  @override
  void update(void Function(AppInfoDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppInfoDto build() => _build();

  _$AppInfoDto _build() {
    final _$result = _$v ??
        _$AppInfoDto._(
          minVersionCode: BuiltValueNullFieldError.checkNotNull(
              minVersionCode, r'AppInfoDto', 'minVersionCode'),
          latestVersionCode: BuiltValueNullFieldError.checkNotNull(
              latestVersionCode, r'AppInfoDto', 'latestVersionCode'),
          updateUrl: updateUrl,
          faceProvider: BuiltValueNullFieldError.checkNotNull(
              faceProvider, r'AppInfoDto', 'faceProvider'),
          pingIntervalSeconds: BuiltValueNullFieldError.checkNotNull(
              pingIntervalSeconds, r'AppInfoDto', 'pingIntervalSeconds'),
          silentGapMinutes: BuiltValueNullFieldError.checkNotNull(
              silentGapMinutes, r'AppInfoDto', 'silentGapMinutes'),
          serverTime: BuiltValueNullFieldError.checkNotNull(
              serverTime, r'AppInfoDto', 'serverTime'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
