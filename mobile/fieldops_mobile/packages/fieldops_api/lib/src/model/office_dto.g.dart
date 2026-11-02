// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OfficeDtoZoneEnum _$officeDtoZoneEnum_SANGLI =
    const OfficeDtoZoneEnum._('SANGLI');
const OfficeDtoZoneEnum _$officeDtoZoneEnum_MIRAJ =
    const OfficeDtoZoneEnum._('MIRAJ');
const OfficeDtoZoneEnum _$officeDtoZoneEnum_KUPWAD =
    const OfficeDtoZoneEnum._('KUPWAD');

OfficeDtoZoneEnum _$officeDtoZoneEnumValueOf(String name) {
  switch (name) {
    case 'SANGLI':
      return _$officeDtoZoneEnum_SANGLI;
    case 'MIRAJ':
      return _$officeDtoZoneEnum_MIRAJ;
    case 'KUPWAD':
      return _$officeDtoZoneEnum_KUPWAD;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OfficeDtoZoneEnum> _$officeDtoZoneEnumValues =
    BuiltSet<OfficeDtoZoneEnum>(const <OfficeDtoZoneEnum>[
  _$officeDtoZoneEnum_SANGLI,
  _$officeDtoZoneEnum_MIRAJ,
  _$officeDtoZoneEnum_KUPWAD,
]);

Serializer<OfficeDtoZoneEnum> _$officeDtoZoneEnumSerializer =
    _$OfficeDtoZoneEnumSerializer();

class _$OfficeDtoZoneEnumSerializer
    implements PrimitiveSerializer<OfficeDtoZoneEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SANGLI': 'SANGLI',
    'MIRAJ': 'MIRAJ',
    'KUPWAD': 'KUPWAD',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SANGLI': 'SANGLI',
    'MIRAJ': 'MIRAJ',
    'KUPWAD': 'KUPWAD',
  };

  @override
  final Iterable<Type> types = const <Type>[OfficeDtoZoneEnum];
  @override
  final String wireName = 'OfficeDtoZoneEnum';

  @override
  Object serialize(Serializers serializers, OfficeDtoZoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OfficeDtoZoneEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OfficeDtoZoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OfficeDto extends OfficeDto {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String nameMr;
  @override
  final OfficeDtoZoneEnum zone;
  @override
  final BuiltMap<String, JsonObject?> premises;
  @override
  final num bufferMeters;
  @override
  final bool isActive;
  @override
  final num version;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  factory _$OfficeDto([void Function(OfficeDtoBuilder)? updates]) =>
      (OfficeDtoBuilder()..update(updates))._build();

  _$OfficeDto._(
      {required this.id,
      required this.code,
      required this.name,
      required this.nameMr,
      required this.zone,
      required this.premises,
      required this.bufferMeters,
      required this.isActive,
      required this.version,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  OfficeDto rebuild(void Function(OfficeDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OfficeDtoBuilder toBuilder() => OfficeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OfficeDto &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        nameMr == other.nameMr &&
        zone == other.zone &&
        premises == other.premises &&
        bufferMeters == other.bufferMeters &&
        isActive == other.isActive &&
        version == other.version &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameMr.hashCode);
    _$hash = $jc(_$hash, zone.hashCode);
    _$hash = $jc(_$hash, premises.hashCode);
    _$hash = $jc(_$hash, bufferMeters.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OfficeDto')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('nameMr', nameMr)
          ..add('zone', zone)
          ..add('premises', premises)
          ..add('bufferMeters', bufferMeters)
          ..add('isActive', isActive)
          ..add('version', version)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class OfficeDtoBuilder implements Builder<OfficeDto, OfficeDtoBuilder> {
  _$OfficeDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameMr;
  String? get nameMr => _$this._nameMr;
  set nameMr(String? nameMr) => _$this._nameMr = nameMr;

  OfficeDtoZoneEnum? _zone;
  OfficeDtoZoneEnum? get zone => _$this._zone;
  set zone(OfficeDtoZoneEnum? zone) => _$this._zone = zone;

  MapBuilder<String, JsonObject?>? _premises;
  MapBuilder<String, JsonObject?> get premises =>
      _$this._premises ??= MapBuilder<String, JsonObject?>();
  set premises(MapBuilder<String, JsonObject?>? premises) =>
      _$this._premises = premises;

  num? _bufferMeters;
  num? get bufferMeters => _$this._bufferMeters;
  set bufferMeters(num? bufferMeters) => _$this._bufferMeters = bufferMeters;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  OfficeDtoBuilder() {
    OfficeDto._defaults(this);
  }

  OfficeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _nameMr = $v.nameMr;
      _zone = $v.zone;
      _premises = $v.premises.toBuilder();
      _bufferMeters = $v.bufferMeters;
      _isActive = $v.isActive;
      _version = $v.version;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OfficeDto other) {
    _$v = other as _$OfficeDto;
  }

  @override
  void update(void Function(OfficeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OfficeDto build() => _build();

  _$OfficeDto _build() {
    _$OfficeDto _$result;
    try {
      _$result = _$v ??
          _$OfficeDto._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'OfficeDto', 'id'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'OfficeDto', 'code'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'OfficeDto', 'name'),
            nameMr: BuiltValueNullFieldError.checkNotNull(
                nameMr, r'OfficeDto', 'nameMr'),
            zone: BuiltValueNullFieldError.checkNotNull(
                zone, r'OfficeDto', 'zone'),
            premises: premises.build(),
            bufferMeters: BuiltValueNullFieldError.checkNotNull(
                bufferMeters, r'OfficeDto', 'bufferMeters'),
            isActive: BuiltValueNullFieldError.checkNotNull(
                isActive, r'OfficeDto', 'isActive'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'OfficeDto', 'version'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'OfficeDto', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'OfficeDto', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'premises';
        premises.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OfficeDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
