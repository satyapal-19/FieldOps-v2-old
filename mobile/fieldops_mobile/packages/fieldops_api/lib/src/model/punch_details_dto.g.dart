// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'punch_details_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PunchDetailsDtoModeEnum _$punchDetailsDtoModeEnum_SELF =
    const PunchDetailsDtoModeEnum._('SELF');
const PunchDetailsDtoModeEnum _$punchDetailsDtoModeEnum_INSPECTOR_PROXY =
    const PunchDetailsDtoModeEnum._('INSPECTOR_PROXY');
const PunchDetailsDtoModeEnum _$punchDetailsDtoModeEnum_ADMIN_PROXY =
    const PunchDetailsDtoModeEnum._('ADMIN_PROXY');

PunchDetailsDtoModeEnum _$punchDetailsDtoModeEnumValueOf(String name) {
  switch (name) {
    case 'SELF':
      return _$punchDetailsDtoModeEnum_SELF;
    case 'INSPECTOR_PROXY':
      return _$punchDetailsDtoModeEnum_INSPECTOR_PROXY;
    case 'ADMIN_PROXY':
      return _$punchDetailsDtoModeEnum_ADMIN_PROXY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PunchDetailsDtoModeEnum> _$punchDetailsDtoModeEnumValues =
    BuiltSet<PunchDetailsDtoModeEnum>(const <PunchDetailsDtoModeEnum>[
  _$punchDetailsDtoModeEnum_SELF,
  _$punchDetailsDtoModeEnum_INSPECTOR_PROXY,
  _$punchDetailsDtoModeEnum_ADMIN_PROXY,
]);

Serializer<PunchDetailsDtoModeEnum> _$punchDetailsDtoModeEnumSerializer =
    _$PunchDetailsDtoModeEnumSerializer();

class _$PunchDetailsDtoModeEnumSerializer
    implements PrimitiveSerializer<PunchDetailsDtoModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SELF': 'SELF',
    'INSPECTOR_PROXY': 'INSPECTOR_PROXY',
    'ADMIN_PROXY': 'ADMIN_PROXY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SELF': 'SELF',
    'INSPECTOR_PROXY': 'INSPECTOR_PROXY',
    'ADMIN_PROXY': 'ADMIN_PROXY',
  };

  @override
  final Iterable<Type> types = const <Type>[PunchDetailsDtoModeEnum];
  @override
  final String wireName = 'PunchDetailsDtoModeEnum';

  @override
  Object serialize(Serializers serializers, PunchDetailsDtoModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PunchDetailsDtoModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PunchDetailsDtoModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PunchDetailsDto extends PunchDetailsDto {
  @override
  final DateTime at;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final num? accuracyM;
  @override
  final bool? inGeofence;
  @override
  final PunchDetailsDtoModeEnum? mode;
  @override
  final String? markedById;

  factory _$PunchDetailsDto([void Function(PunchDetailsDtoBuilder)? updates]) =>
      (PunchDetailsDtoBuilder()..update(updates))._build();

  _$PunchDetailsDto._(
      {required this.at,
      required this.latitude,
      required this.longitude,
      this.accuracyM,
      this.inGeofence,
      this.mode,
      this.markedById})
      : super._();
  @override
  PunchDetailsDto rebuild(void Function(PunchDetailsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PunchDetailsDtoBuilder toBuilder() => PunchDetailsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PunchDetailsDto &&
        at == other.at &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        accuracyM == other.accuracyM &&
        inGeofence == other.inGeofence &&
        mode == other.mode &&
        markedById == other.markedById;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, accuracyM.hashCode);
    _$hash = $jc(_$hash, inGeofence.hashCode);
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, markedById.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PunchDetailsDto')
          ..add('at', at)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('accuracyM', accuracyM)
          ..add('inGeofence', inGeofence)
          ..add('mode', mode)
          ..add('markedById', markedById))
        .toString();
  }
}

class PunchDetailsDtoBuilder
    implements Builder<PunchDetailsDto, PunchDetailsDtoBuilder> {
  _$PunchDetailsDto? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  num? _accuracyM;
  num? get accuracyM => _$this._accuracyM;
  set accuracyM(num? accuracyM) => _$this._accuracyM = accuracyM;

  bool? _inGeofence;
  bool? get inGeofence => _$this._inGeofence;
  set inGeofence(bool? inGeofence) => _$this._inGeofence = inGeofence;

  PunchDetailsDtoModeEnum? _mode;
  PunchDetailsDtoModeEnum? get mode => _$this._mode;
  set mode(PunchDetailsDtoModeEnum? mode) => _$this._mode = mode;

  String? _markedById;
  String? get markedById => _$this._markedById;
  set markedById(String? markedById) => _$this._markedById = markedById;

  PunchDetailsDtoBuilder() {
    PunchDetailsDto._defaults(this);
  }

  PunchDetailsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _accuracyM = $v.accuracyM;
      _inGeofence = $v.inGeofence;
      _mode = $v.mode;
      _markedById = $v.markedById;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PunchDetailsDto other) {
    _$v = other as _$PunchDetailsDto;
  }

  @override
  void update(void Function(PunchDetailsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PunchDetailsDto build() => _build();

  _$PunchDetailsDto _build() {
    final _$result = _$v ??
        _$PunchDetailsDto._(
          at: BuiltValueNullFieldError.checkNotNull(
              at, r'PunchDetailsDto', 'at'),
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'PunchDetailsDto', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'PunchDetailsDto', 'longitude'),
          accuracyM: accuracyM,
          inGeofence: inGeofence,
          mode: mode,
          markedById: markedById,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
